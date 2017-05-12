# encoding: utf-8
require "belzebuth/wait_condition/base"
module Belzebuth module WaitCondition
  class FileExist < Base
    def initialize(file)
      @file = file
    end

    def call(process)
      File.exist?(file)
    end
  end
end end
