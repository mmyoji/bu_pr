# frozen_string_literal: true

require "spec_helper"

require_relative "./../../lib/bu_pr/configuration"

describe BuPr::Configuration do
  let(:opts)   { {} }
  let(:config) { described_class.new(opts) }

  describe "attr_accessors" do
    subject { config }

    it "responds to accessors" do
      is_expected.to respond_to(:branch)
      is_expected.to respond_to(:branch=)
      is_expected.to respond_to(:title)
      is_expected.to respond_to(:title=)
      is_expected.to respond_to(:token)
      is_expected.to respond_to(:token=)
      is_expected.to respond_to(:repo)
      is_expected.to respond_to(:repo=)
    end
  end

  describe "#valid?" do
    subject { config.valid? }

    before do
      config.token = "dummy"
      config.repo  = "mmyoji/bu_pr"
    end

    context "w/ valid attrs" do
      it { is_expected.to eq true }
    end

    context "w/o token" do
      before do
        config.token = ""
      end

      it { is_expected.to eq false }
    end

    context "w/o repo" do
      before do
        config.repo = ""
      end

      it { is_expected.to eq false }
    end
  end
end

