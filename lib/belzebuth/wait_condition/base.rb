# encoding: utf-8
#
module Belzebuth module WaitCondition
  class Base
    def start
    end

    def complete
    end

    def call(process)
      raise NotImplemented, "#{self.class}#call is not implemented"
    end

    def sleep_time_between_condition
      0.5
    end
  end
end
