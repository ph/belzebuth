# encoding: utf-8
require "belzebuth/wait_condition/base"
require "uri"
require "net/http"

module Belzebuth module WaitCondition
  class Api < Base
    MAX_SLEEP_TIME = 10

    def initialize(uri, max_sleep_time = MAX_SLEEP_TIME)
      @uri = URI(uri)
      @sleep_time = 1
      @max_sleep_time = max_sleep_time
    end

    def call(process)
      Net::HTTP.get(@uri)
      true
    rescue => e
      @sleep_time = [@sleep_time +1, @max_sleep_time].min
      false
    end

    def sleep_time_between_condition
      @sleep_time
    end
  end
end end
