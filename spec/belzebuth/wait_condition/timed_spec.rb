# encoding: utf-8
require "belzebuth/wait_condition/timed"

describe Belzebuth::WaitCondition::Timed do
  let(:max_time) { 0.5 }
  let(:process) { instance_double("child_process") }

  subject { described_class.new(max_time) }

  it "wait for some time" do
    subject.start(process)
    expect(subject.call(process)).to be_falsey
    sleep(max_time + 1)
    expect(subject.call(process)).to be_truthy
  end

  it "doesn't sleep between condition" do
    expect(subject.sleep_time_between_condition).to eq(0)
  end
end
