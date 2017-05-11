# encoding: utf-8
require "belzebuth/wait_condition/blocking"

describe Belzebuth::WaitCondition::Blocking do
  subject { described_class.new.call(process) }

  context "when the process has exited" do
    let(:process) { instance_double("childprocess", :exited? => false) }

    it "returns false" do
      expect(subject).to be_falsey
    end
  end

  context "when the process is still running" do
    let(:process) { instance_double("childprocess", :exited? => true) }

    it "returns true" do
      expect(subject).to be_truthy
    end
  end
end
