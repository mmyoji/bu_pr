# frozen_string_literal: true
require 'singleton'

module BuPr
  class Configuration
    include Singleton

    attr_accessor(
      :branch,
      :title,
      :token,
      :repo,
    )

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
      token? && branch? && title? && repo?
    end

    private

    def token?
      token && token != ""
    end

    def branch?
      branch && branch != ""
    end

    def title?
      title && title != ""
    end

    def repo?
      repo && repo != ""
    end
  end
end
