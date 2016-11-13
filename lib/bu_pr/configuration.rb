# frozen_string_literal: true
require 'singleton'

module BuPr
  class Configuration
    include Singleton

    ACCESSORS = %i(
      access_token base_branch
      pr_title repo_name
    )

    attr_accessor(*ACCESSORS)

    def initialize
      @base_branch = "master"
      @pr_title    = "Bundle update #{Time.now.strftime('%F')}"

      @access_token = ENV["BUPR_TOKEN"]
      @repo_name    = ENV["BUPR_REPO"]
    end

    def valid?
      ACCESSORS.all? do |accr|
        val = public_send(accr)

        val && val != ""
      end
    end
  end
end
