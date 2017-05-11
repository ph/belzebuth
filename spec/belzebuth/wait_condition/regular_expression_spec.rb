# encoding: utf-8
require "belzebuth/wait_condition/regular_expression"

describe Belzebuth::WaitCondition::RegularExpression do
  let(:expression) { /Hello world/ }
  let(:process) { instance_double("childprocess", :stdout_lines => [message]) }

  subject { described_class.new(expression).call(process) }

  context "when it match" do
    let(:message) { "Hello world awesome" }

    it "returns true" do
      expect(subject).to be_truthy
    end
  end

  context "when it doesn't match" do
    let(:message) { "do not match" }

    it "returns false" do
      expect(subject).to be_falsey
    end
  end
end
