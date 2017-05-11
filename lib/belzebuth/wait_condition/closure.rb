# encoding: utf-8
require "belzebuth/wait_condition/base"

module Belzebuth module WaitCondition
  class Closure < Base
    def initialize(callback)
      @callback = callback
    end

    def call(process)
      @callback.call(process)
    end
  end
end end
