# frozen_string_literal: true
require "bu_pr/version"
require "bu_pr/configuration"
require "bu_pr/git"

require "bu_pr/handlers/github"

module BuPr
  module_function

  def configure
    @config = yield Configuration.instance
  end

  def config
    @config
  end

  def run
    configure do |c|
      c.access_token = ENV["BU_PR_ACCESS_TOKEN"]
      c.repo_name    = "mmyoji/bu_pr"
    end

    git = Git.new

    unless git.installed?
      raise "Git is not installed"
    end

    if system("bundle update") && !git.diff?
      puts "no update"
      exit
    end

    git.push

    handler = Handlers::Github.new config: config, current_branch: git.current_branch
    handler.call
  end
end
