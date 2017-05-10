# encoding: utf-8
require "wait_condition/base"
require "wait_condition/api"
require "wait_condition/regular_expression"
require "wait_condition/closure"
require "uri"

module Belzebuth
  def WaitCondition(wait_condition)
    case wait_condition
    when WaitCondition::Base
      wait_condition
    when Proc
      WaitCondition::Closure.new(wait_condition)
    when Regexp
      WaitCondition::RegularExpression.new(wait_condition)
    when String
      begin
        uri = uri(wait_condition)
        if uri.scheme == "http" || uri.scheme == "https"
          WaitCondition::Api.new(uri)
        else
          WaitCondition::RegularExpression.new(/^#{wait_condition}$/)
        end
      rescue
        WaitCondition::RegularExpression.new(/^#{wait_condition}/)
      end
    else
      raise "Unknown WaitCondition for: #{WaitCondition}"
    end
  end
end
