# encoding: utf-8
require "belzebuth/process"
require "belzebuth/wait_condition/base"

describe Belzebuth::Process do
  let(:cmd) { "ls" }
  let(:options) { { :wait_condition => wait_condition } }
  let(:wait_condition) do
    Class.new(Belzebuth::WaitCondition::Base) do
      def call(process)
        return true
      end
    end.new
  end

  subject { described_class.new(cmd, options) }

  describe "callbacks execution" do
    it "receives `#start`" do
      expect(wait_condition).to receive(:start).with(kind_of(Belzebuth::Response)).and_return(nil)
      subject.run
    end

    it "receives `#call`" do
      expect(wait_condition).to receive(:call).with(kind_of(Belzebuth::Response)).and_return(true)
      subject.run
    end

    context "when it takes more time for the wait condition to match" do
      it "receives `#sleep_time_between_condition`" do
        expect(wait_condition).to receive(:call).with(kind_of(Belzebuth::Response)).and_return(false)
        expect(wait_condition).to receive(:call).with(kind_of(Belzebuth::Response)).and_return(true)
        expect(wait_condition).to receive(:sleep_time_between_condition).with(kind_of(Belzebuth::Response)).and_return(0.1)
        subject.run
      end
    end

    it "receives `complete`" do
      expect(wait_condition).to receive(:complete).with(kind_of(Belzebuth::Response)).and_return(nil)
      subject.run
    end
  end

  describe "execution response" do
    subject { described_class.new(cmd, options).run }

    context "when successful" do
      let(:cmd) { "ls" }

      it "returns return the right exit code" do
        expect(subject).to be_successful
      end

      it "returns the stderr with no error" do
        expect(subject.stderr_lines).to be_empty
      end

      it "returns the stdout" do
        expect(subject.stdout_lines).not_to be_empty
      end
    end

    context "when failling" do
      let(:cmd) { "grep -axxxx" } # just make it fail

      it "returns return the right exit code" do
        expect(subject).to be_successful
      end

      it "returns the stderr with errors" do
        expect(subject.stderr_lines).not_to be_empty
      end

      it "returns the stdout" do
        expect(subject.stdout_lines).to be_empty
      end
    end

    context "when the execution timeout" do
      let(:cmd) { "sleep 10" }
      let(:options) { { :timeout => 0.5 } }
      subject { described_class.new(cmd, options) }

      it "raises an `ExecutionTimeout`" do
        expect { subject.run }.to raise_error(Belzebuth::ExecutionTimeout)
      end
    end
  end
end
