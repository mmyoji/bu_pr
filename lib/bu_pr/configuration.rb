# frozen_string_literal: true
module BuPr
  class Configuration
    ATTRS = %i(
      branch
      title
      token
      repo
    )

    attr_accessor(*ATTRS)

    def initialize opts = {}
      @branch = opts.fetch(:branch) { ENV.fetch("BUPR_BRANCH") { "master" } }
      @title  = opts.fetch(:title)  { ENV.fetch("BUPR_TITLE")  { default_title } }

      @token  = opts.fetch(:token) { ENV["BUPR_TOKEN"] }
      @repo   = opts.fetch(:repo)  { ENV["BUPR_REPO"] }
    end

    def valid?
      token? && branch? && title? && repo?
    end

    private

    ATTRS.each do |attr|
      define_method "#{attr}?" do
        v = public_send(attr)
        !v.nil? && v != ""
      end
    end

    def default_title
      "Bundle update #{Time.now.strftime('%F')}"
    end
  end
end
