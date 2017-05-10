# encoding: utf-8
require "Belzebuth/process"

describe Belzebuth::Process do
  let(:cmd) { "ls" }
  let(:options) { {} }
  let(:spy_wait_condition) { spy("wait_condition") }

  subject { described_class.new(cmd, options) }

  context "callback execution" do
    it "receives `#start`" do
      expect(spy).to have_received(:start)
      subject.run
    end

    it "receives `#call`" do
      expect(spy).to have_received(:call).with(kind_of(ChildProcess))
      subject.run
    end

    it "receives `#sleep_time_between_condition`" do
      expect(spy).to have_received(:sleep_time_between_condition)
      subject.run
    end
  end

  context "wraps the exection into a response" do
  end
end
