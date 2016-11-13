require "spec_helper"

require_relative "./../../lib/bu_pr/runner"

describe BuPr::Runner do
  let(:config_double) { double("config", valid?: true) }

  let(:runner) { described_class.new }

  describe "attr_reader" do
    subject { runner }

    it do
      is_expected.to respond_to :git
    end
  end

  describe "#call" do
    before do
      allow(runner).to receive(:config) { config_double }
      allow(runner.git).to receive(:installed?) { true }

      expect(runner).to receive(:bundle_update) { true }
    end

    context "w/o diff" do
      it "exits" do
        expect(runner.git).to receive(:diff?) { false }
        expect(runner.git).to_not receive(:push)

        runner.call
      end
    end

    context "w/ diff" do
      let(:handler_double) { double("handler") }

      before do
        allow(runner.git).to receive(:current_branch) { 'bundle-update' }
      end

      specify do
        expect(runner.git).to receive(:diff?) { true }
        expect(runner.git).to receive(:push)

        expect(BuPr::Handlers::Github).to \
          receive(:new)
          .with(config: runner.config, current_branch: 'bundle-update')
          .and_return(handler_double)

        expect(handler_double).to receive(:call)

        runner.call
      end
    end
  end

  describe "#config" do
    it "returns an instance of BuPr::Configuration" do
      expect(runner.config).to be_a(BuPr::Configuration)
    end
  end

  describe "#valid" do
    subject { runner.valid? }

    context "w/ invalid config" do
      specify do
        expect { subject }.to \
          raise_error(RuntimeError, "Invalid configuration")
      end
    end

    context "w/ git is not installed" do
      before do
        expect(runner).to receive(:config) { config_double }
        expect(runner.git).to receive(:installed?) { false }
      end

      specify do
        expect { subject }.to \
          raise_error(RuntimeError, "Git is not installed")
      end
    end

    context "w/ valid setuo" do
      before do
        expect(runner).to receive(:config) { config_double }
        expect(runner.git).to receive(:installed?) { true }
      end

      it { is_expected.to eq true }
    end
  end
end
