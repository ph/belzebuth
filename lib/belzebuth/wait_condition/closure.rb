# encoding: utf-8

module Belzebuth module WaitCondition
  class Closure < Base
    def new(callback)
      @callback = callback
    end

    def call(process)
      @callback.call(process)
    end
  end
end
