# frozen_string_literal: true
require "spec_helper"

require_relative "./../../lib/bu_pr/git"

describe BuPr::Git do
  let(:git) { described_class.new }

  describe "#current_branch" do
    let(:dummy_branches) {
      "cosme-literal\n* develop\n  handlable-channels\n  rails5\n  puma"
    }

    before do
      expect(git).to \
        receive(:branches).and_return(dummy_branches)
    end

    subject { git.current_branch }

    it { is_expected.to eq "develop" }
  end
end
