# encoding: utf-8
require "belzebuth/wait_condition/base"

module Belzebuth module WaitCondition
  class Timed < Base
    def initialize(time)
      @time = time
    end

    def start(process)
      @started_at = Time.now
    end

    def call(process)
      Time.now - @started_at > @time
    end

    def sleep_time_between_condition(process)
      0
    end
  end
end end
