# frozen_string_literal: true

require "spec_helper"

require_relative "./../../../lib/bu_pr/handlers/github"

describe BuPr::Handlers::Github do
  let(:config) {
    double \
      "config",
      branch: "master",
      repo:   "mmyoji/bu_pr",
      title:  "bundle update",
      token:  "dummy-token"
  }

  let(:handler) {
    described_class.new config: config, current_branch: "bundle-update"
  }

  describe "attr_reader" do
    specify do
      expect(handler.current_branch).to eq "bundle-update"

      expect(handler.base).to  eq config.branch
      expect(handler.repo).to  eq config.repo
      expect(handler.title).to eq config.title
      expect(handler.token).to eq config.token
    end
  end

  let(:client_double) { double("client") }
  let(:linker_double) { double("linker") }
  let(:pr_number)     { 111 }

  describe "#call" do
    specify do
      expect(handler).to \
        receive(:create_pull_request)
        .and_return(pr_number)

      expect(handler).to \
        receive(:diff_comment)
        .with(pr_number)

      handler.call
    end
  end

  describe '#create_pull_request' do
    it 'returns pull-request number' do
      h = handler

      expect(Octokit::Client).to \
        receive(:new).with(access_token: h.token)
        .and_return(client_double)

      expect(client_double).to \
        receive(:create_pull_request)
        .with(h.repo, h.base, "bundle-update", h.title)
        .and_return(number: pr_number)

      expect(h.create_pull_request).to eq pr_number
    end
  end

  describe '#diff_comment' do
    it 'adds a comment' do
      h = handler

      expect(linker_double).to receive(:formatter=)

      expect(linker_double).to \
        receive(:make_compare_links)
        .and_return(["rake 0.1..0.3", "rspec 3.1..3.3"])

      expect(linker_double).to \
        receive(:add_comment)
        .with(h.repo, pr_number, "rake 0.1..0.3\nrspec 3.1..3.3")

      expect(CompareLinker).to \
        receive(:new)
        .with(h.repo, pr_number)
        .and_return(linker_double)

      h.diff_comment(pr_number)
    end
  end
end
