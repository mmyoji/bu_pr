# frozen_string_literal: true
require "bu_pr/version"
require "bu_pr/configuration"
require "bu_pr/git"
require "bu_pr/handlers/github"
require "bu_pr/runner"
require "bu_pr/railtie" if defined?(Rails::Railtie)

module BuPr
end
