require "spec_helper"

require_relative "./../../lib/bu_pr/configuration"

describe BuPr::Configuration do
  let(:config) { described_class.instance }

  describe "attr_accessors" do
    subject { config }

    it "responds to accessors" do
      is_expected.to respond_to(:access_token)
      is_expected.to respond_to(:access_token=)

      is_expected.to respond_to(:base_branch)
      is_expected.to respond_to(:base_branch=)

      is_expected.to respond_to(:pr_title)
      is_expected.to respond_to(:pr_title=)

      is_expected.to respond_to(:repo_name)
      is_expected.to respond_to(:repo_name=)
    end
  end

  describe "#valid?" do
    subject { config.valid? }

    before do
      config.access_token = "dummy"
      config.repo_name    = "mmyoji/bu_pr"
    end

    context "w/ valid attrs" do
      it { is_expected.to eq true }
    end

    context "w/o access_token" do
      before do
        config.access_token = ""
      end

      it { is_expected.to eq false }
    end

    context "w/o repo_name" do
      before do
        config.repo_name = ""
      end

      it { is_expected.to eq false }
    end
  end
end

