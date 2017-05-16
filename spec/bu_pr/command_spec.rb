# frozen_string_literal: true

require "spec_helper"
require_relative "./../../lib/bu_pr/command"

describe BuPr::Command do
  let(:args)    { [] }
  let(:command) { described_class.new(args) }

  describe ".start" do
    it "calls Runner.call" do
      expect(BuPr::Runner).to receive(:call).with({})

      described_class.start args
    end
  end

  describe "#parse" do
    subject { command.parse }

    context "w/ shorthand args" do
      let(:args) { ["-b", "develop", "-r", "mmyoji/bu_pr"] }

      it { is_expected.to eq({ branch: "develop", repo: "mmyoji/bu_pr" }) }
    end

    context "w/ formal args" do
      let(:args) { ["--token=xxx", "--title", "Yahaha"] }

      it { is_expected.to eq({ token: "xxx", title: "Yahaha" }) }
    end

    context "w/ mixed args" do
      let(:args) { ["-r", "mmyoji/bu_pr", "--token", "xxx"] }

      it { is_expected.to eq({ repo: "mmyoji/bu_pr", token: "xxx" }) }
    end

    context "w/ blank args" do
      it { is_expected.to eq({}) }
    end
  end
end
