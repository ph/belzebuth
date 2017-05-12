# encoding: utf-8
require "belzebuth/wait_condition"
require "belzebuth/response"
require "shellwords"
require "childprocess"
require "tempfile"
require "bundler"

# @background_process = []

# stop_background_process

# elasticsearch(
#   :install_xpack => true
#   :config => {
#     # ....
#   }
# )

# response = logstash("-f ....")
# response = logstash_plugin("...")

# expect(response).to be_successful
# auto stop service at the end

module Belzebuth
  class ExecutionTimeout < StandardError; end

  def self.run(command, options = {})
    Process.new(command, options).run
  end

  class Process
    DEFAULT_OPTIONS = {
      :directory => Dir.pwd,
      :environment => {},
      :timeout => -1
    }

    def initialize(command, options = {})
      @command = command
      @options = DEFAULT_OPTIONS.merge(options)
      @wait_condition = Belzebuth::WaitCondition(@options.fetch(:wait_condition, WaitCondition::Blocking.new))
    end

    def run
      Bundler.with_clean_env do
        child_process = Response.new(ChildProcess.new(*Shellwords.split(@command)))
        child_process.cwd = @options[:directory]
        child_process.io.stdout = create_tempfile("stdout")
        child_process.io.stderr = create_tempfile("stderr")

        started_at = Time.now

        child_process.start
        @wait_condition.start(child_process)

        while !@wait_condition.call(child_process)
          sleep(@wait_condition.sleep_time_between_condition(child_process))

          if can_timeout? && Time.now - started_at > @options[:timeout]
            child_process.stop
            raise ExecutionTimeout, "`#{@command}` took too much time to execute (timeout: #{@options[:timeout]}) #{child_process}"
          end
        end

        @wait_condition.complete(child_process)
        child_process
      end
    end

    private

    def can_timeout?
      @options[:timeout] != -1
    end

    def create_tempfile(name)
      io = Tempfile.new("#{name}")
      io.sync = true
      io
    end
  end
end
