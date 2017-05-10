# encoding: utf-8
require "delegate"

module Belzebuth
  class Response < SimpleDelegator
    def stdout_lines
      io_readlines(io.stdout)
    end

    def stderr_lines
      io_readlines(io.stderr)
    end

    def successful?
      exit_code == 0
    end

    private
    def io_readlines(new_io)
      new_io.rewind
      new_io.readlines
    end
  end
end
