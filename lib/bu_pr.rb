# frozen_string_literal: true
require "bu_pr/version"
require "bu_pr/configuration"

require "logger"

require "octokit"
require "compare_linker"


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

    # check git installed
    unless system("git --help > /dev/null 2>&1")
      raise "Git is not installed"
    end

    current_branch = `git branch`.each_line do |line|
      matched = line.strip.match(/\*\s+(?<current_branch>.+)/)
      next unless matched

      break matched["current_branch"]
    end

    if system("bundle update") && !`git status`.include?("Gemfile.lock")
      puts "no update"
      exit
    end

    `git add Gemfile.lock` &&
      `git commit -m "bundle update"` &&
      `git push origin #{current_branch}`

    # bu_pr-dev
    oc = Octokit::Client.new access_token: config.access_token
    # not necessary??
    # oc.user.login
    repo_name = config.repo_name

    res = oc.create_pull_request(repo_name, config.base_branch, current_branch, config.pr_title)
    pr_number = res[:number]

    ENV['OCTOKIT_ACCESS_TOKEN'] = config.access_token

    compare_linker = CompareLinker.new repo_name, pr_number
    compare_linker.formatter = CompareLinker::Formatter::Markdown.new

    comment = "#{compare_linker.make_compare_links.to_a.join("\n")}"
    compare_linker.add_comment(repo_name, pr_number, comment)
  end
end
