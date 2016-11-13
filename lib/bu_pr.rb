# frozen_string_literal: true
require "bu_pr/version"
require "bu_pr/configuration"
require "bu_pr/git"

require "bu_pr/handlers/github"

require "bu_pr/runner"

module BuPr
  def configure
    conf = Configuration.instance
    yield conf

    Runner.config = conf
  end
  module_function :configure
end
