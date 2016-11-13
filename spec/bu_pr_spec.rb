require "spec_helper"

describe BuPr do
  it "has a version number" do
    expect(BuPr::VERSION).not_to be nil
  end

  describe ".configure" do
    specify do
      described_class.configure do |c|
        c.repo_name    = "mmyoji/bu_pr-test"
        c.access_token = "xxx"
      end

      conf = described_class::Runner.config

      expect(conf.repo_name).to eq "mmyoji/bu_pr-test"
      expect(conf.access_token).to eq "xxx"
    end
  end
end
