# encoding: utf-8
require "belzebuth/wait_condition/base"

module Belzebuth module WaitCondition
  class Blocking < Base
    def call(process)
      process.exited?
    end
  end
end end
