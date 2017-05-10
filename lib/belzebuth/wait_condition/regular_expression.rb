# encoding: utf-8
require "base"

module Belzebuth module WaitCondition
  class RegularExpression < Base
    def initialize(expression)
      @expression = expression
    end

    def call(process)
      io.stdout_lines.any? { |line| @expression.match(line) }
    end
  end
end
