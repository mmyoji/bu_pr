require "spec_helper"

require_relative "./../../../lib/bu_pr/handlers/github"

describe BuPr::Handlers::Github do
  let(:config) {
    double \
      "config",
      base_branch: "master",
      repo_name: "mmyoji/bu_pr",
      pr_title: "bundle update",
      access_token: "dummy-token"
  }

  let(:handler) {
    described_class.new config: config, current_branch: "bundle-update"
  }

  describe "attr_reader" do
    specify do
      expect(handler.current_branch).to eq "bundle-update"

      expect(handler.base).to  eq config.base_branch
      expect(handler.repo).to  eq config.repo_name
      expect(handler.title).to eq config.pr_title
      expect(handler.token).to eq config.access_token
    end
  end

  describe "#call" do
    let(:client_double) { double("client") }
    let(:linker_double) { double("linker") }
    let(:pr_number)     { 111 }

    specify do
      h = handler

      expect(client_double).to \
        receive(:create_pull_request)
        .with(h.repo, h.base, "bundle-update", h.title)
        .and_return(number: pr_number)

      expect(Octokit::Client).to \
        receive(:new).with(access_token: h.token)
        .and_return(client_double)

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

      handler.call
    end
  end
end