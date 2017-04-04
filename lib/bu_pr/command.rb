# frozen_string_literal: true
require "thor"

module BuPr
  class Command < ::Thor
    default_command :all

    desc "all", "Run bundle update and create pull-request"
    method_options(
      branch: :string,
      title:  :string,
      token:  :string,
      repo:   :string,
    )
    def all
      Runner.call(options)
    end
  end
end
