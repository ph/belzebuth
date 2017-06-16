# encoding: utf-8
require "belzebuth/wait_condition/api"

describe Belzebuth::WaitCondition::Api do
  let(:process) { instance_double("childprocess") }
  let(:uri) { "http://localhost" }
  let(:max_sleep_time) { 10 }

  subject { described_class.new(uri, max_sleep_time) }

  it "returns true if the uri answer" do
    allow(Net::HTTP).to receive(:get).and_return(true)
    expect(subject.call(process)).to be_truthy
  end

  it "returns false if the uri doesn't answer" do
    allow(Net::HTTP).to receive(:get).and_raise { "doesn't work" }
    expect(subject.call(process)).to be_falsey
  end

  describe "#sleep_time_between_condition" do
    let(:max_sleep_time) { 3 }

    it "increments the sleep time for each failures" do
      allow(Net::HTTP).to receive(:get).and_raise { "doesn't work" }
      subject.call(process)
      expect(subject.sleep_time_between_condition).to eq(1)
      subject.call(process)
      expect(subject.sleep_time_between_condition).to eq(2)
      subject.call(process)
      expect(subject.sleep_time_between_condition).to eq(3)
    end
  end
end
