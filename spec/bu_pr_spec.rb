require "spec_helper"

describe BuPr do
  it "has a version number" do
    expect(BuPr::VERSION).not_to be nil
  end

  describe ".configure" do
    specify do
      described_class.configure do |c|
        c.repo         = "mmyoji/bu_pr-test"
        c.token = "xxx"
      end

      conf = described_class::Runner.config

      expect(conf.repo).to eq "mmyoji/bu_pr-test"
      expect(conf.token).to eq "xxx"
    end
  end
end
