# encoding: utf-8
require "belzebuth/wait_condition/base"
require "belzebuth/wait_condition/api"
require "belzebuth/wait_condition/regular_expression"
require "belzebuth/wait_condition/closure"
require "belzebuth/wait_condition/blocking"
require "belzebuth/wait_condition/timed"
require "belzebuth/wait_condition/file_exist"
require "uri"

module Belzebuth
  def self.WaitCondition(wait_condition)
    case wait_condition
    when WaitCondition::Base
      wait_condition
    when Numeric
      WaitCondition::Timed.new(wait_condition)
    when Proc
      WaitCondition::Closure.new(wait_condition)
    when Regexp
      WaitCondition::RegularExpression.new(wait_condition)
    when String
      begin
        uri = URI(wait_condition)
        if uri.scheme == "http" || uri.scheme == "https"
          WaitCondition::Api.new(uri)
        else
          WaitCondition::RegularExpression.new(/^#{wait_condition}$/)
        end
      rescue => e
        WaitCondition::RegularExpression.new(/^#{wait_condition}/)
      end
    else
      raise "Unknown WaitCondition for: #{wait_condition}"
    end
  end
end
