# encoding: utf-8
require "belzebuth/wait_condition"

describe Belzebuth do
  subject { described_class.WaitCondition(wait_condition) }

  context "when the wait_condition instance doesn't implement WaitCondition::Base" do
    let(:wait_condition) { Class.new }

    it "raise an exception" do
      expect { subject }.to raise_error /Unknown WaitCondition/
    end
  end

  context "when is a string" do
    context "not a uri" do
      let(:wait_condition) { "hello world" }
      let(:process) { instance_double("childprocess", :stdout_lines => ["hello world"]) }

      it "wraps it into a RegularExpression" do
        expect(subject).to be_kind_of(Belzebuth::WaitCondition::RegularExpression)
        expect(subject.call(process)).to be_truthy
      end
    end

    context "when its a uri" do
      context "when its http" do
        let(:wait_condition) { "http://localhost" }

        it "wraps it into an Api" do
          expect(subject).to be_kind_of(Belzebuth::WaitCondition::Api)
        end
      end

      context "when its https" do
        let(:wait_condition) { "https://localhost" }

        it "wraps it into an Api" do
          expect(subject).to be_kind_of(Belzebuth::WaitCondition::Api)
        end
      end
    end
  end

  context "when its a proc" do
    let(:wait_condition) { proc { |process| 1 + 1} }

    it "returns a closure" do
      expect(subject).to be_kind_of(Belzebuth::WaitCondition::Closure)
    end
  end

  context "when its a RegularExpression" do
    let(:wait_condition) { /hello world/ }

    it "wrap it into a RegularExpression" do
      expect(subject).to be_kind_of(Belzebuth::WaitCondition::RegularExpression)
    end
  end
end
