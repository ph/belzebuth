# encoding: utf-8
require "belzebuth/wait_condition/base"

module Belzebuth module WaitCondition
  class RegularExpression < Base
    def initialize(expression)
      @expression = expression
    end

    def call(process)
      process.stdout_lines.any? { |line| @expression.match(line) }
    end
  end
end end
