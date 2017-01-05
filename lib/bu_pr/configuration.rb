# frozen_string_literal: true
require 'singleton'

module BuPr
  class Configuration
    include Singleton

    ACCESSORS = %i(
      token
      branch
      title
      repo
    )

    attr_accessor(*ACCESSORS)

    # DEPRECATED
    alias access_token token
    alias access_token= token=
    alias base_branch branch
    alias base_branch= branch=
    alias pr_title title
    alias pr_title= title=
    alias repo_name repo
    alias repo_name= repo=

    def initialize
      @branch = ENV.fetch("BUPR_BRANCH") { "master" }
      @title  = ENV.fetch("BUPR_TITLE")  { "Bundle update #{Time.now.strftime('%F')}" }

      @token  = ENV["BUPR_TOKEN"]
      @repo   = ENV["BUPR_REPO"]
    end

    def valid?
      ACCESSORS.all? do |accr|
        val = public_send(accr)

        val && val != ""
      end
    end
  end
end
