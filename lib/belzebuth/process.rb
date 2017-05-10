# encoding: utf-8
require "wait_condition"
require "response"
require "shellwords"
require "childprocess"
require "tempfile"
require "thread"

module Belzebuth
  class ExecutionTimeout < StandardErr; end

  def self.run(command, options = {})
    Process.new(command, options).run
  end

  class Process
    DEFAULT_OPTIONS = {
      :directory => Dir.pwd,
      :environment => {},
      :timeout => -1
    }

    DEBUG_IO_LINE = 10

    def initialize(command, options = {})
      @command = command
      @options = DEFAULT_OPTIONS.merge(options)
      @wait_condition = WaitCondition(@options.fetch(:wait_condition, WaitCondition::Blocking.new))
    end

    def run
      child_process = ChildProcess.new(Shellword.split(@command))
      child_process.cwd = @options[:directory]
      child_process.io.stdout = create_tempfile("stdout")
      child_process.io.stderr = create_tempfile("stderr")

      started_at = Time.now

      child_process.start

      response = response.new(child_process)
      while !@wait_condition.call(response)
        sleep(options.sleep_time_between_condition)

        if check_timeout? && Time.now - started_at > @options[:timeout]
          raise ExecutionTimeout, "`#{@command}` took too much time to execute (timeout: #{@options[:timeout]})\nstdout:\n#{debug_io(child_process.io.stdout)}\nstderr\n#{debug_io(child_process.io.stderr)}"
        end
      end

      @wait_condition.complete

      response
    end

    private
    def debug_io(io, truncate = DEBUG_IO_LINE)
      io.rewind
      io.readlines[-2..-1].join("\n")
    end

    def check_timeout?
      @options[:timeout] != -1
    end

    def create_tempfile(name)
      io = Tempfile.new("#{name}")
      io.sync = true
      io
    end
  end
end
