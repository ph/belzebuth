# encoding: utf-8
require "delegate"

module Belzebuth
  class Response < SimpleDelegator
    DEBUG_IO_LINE = 10

    def stdout_lines
      io_readlines(io.stdout)
    end

    def stderr_lines
      io_readlines(io.stderr)
    end

    def successful?
      exit_code == 0 || exit_code.nil?
    end

    def to_s
      "Reponse: \nstdout:\n#{debug_io(stdout_lines)}\nstderr\n#{debug_io(stderr_lines)}"
    end
    alias_method :inspect, :to_s

    private
    def debug_io(io, last_items = DEBUG_IO_LINE)
      return "" if io.empty?
      io.last(last_items).join("\n")
    end

    def io_readlines(new_io)
      new_io.rewind
      new_io.readlines
    end
  end
end
