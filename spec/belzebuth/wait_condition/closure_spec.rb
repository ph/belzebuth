# encoding: utf-8
require "belzebuth/wait_condition/closure"

describe Belzebuth::WaitCondition::Closure do
  let(:process) { instance_double("childprocess", :exit_code => 1) }
  let(:closure) { proc { |child_process| child_process.exit_code == 1 } }

  subject { described_class.new(closure).call(process) }

  it "execute the closure" do
    expect(subject).to be_truthy
  end
end
