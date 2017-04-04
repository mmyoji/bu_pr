# frozen_string_literal: true
module BuPr
  class Configuration
    ATTRS = %i(
      branch
      title
      token
      repo
    )

    # @return [String]
    attr_accessor(*ATTRS)

    # @param opts [Hash]
    # @option opts [String] :branch Base branch name
    # @option opts [String] :title pull-request title
    # @option opts [String] :token GitHub access token
    # @option opts [String] :repo GitHub repository name
    def initialize opts = {}
      @branch = opts.fetch(:branch) { ENV.fetch("BUPR_BRANCH") { "master" } }
      @title  = opts.fetch(:title)  { ENV.fetch("BUPR_TITLE")  { default_title } }

      @token  = opts.fetch(:token) { ENV["BUPR_TOKEN"] }
      @repo   = opts.fetch(:repo)  { ENV["BUPR_REPO"] }
    end

    # @return [Boolean]
    def valid?
      token? && branch? && title? && repo?
    end

    private

    ATTRS.each do |attr|
      # @private
      define_method "#{attr}?" do
        v = public_send(attr)
        !v.nil? && v != ""
      end
    end

    # @private
    # @return [String]
    def default_title
      "Bundle update #{Time.now.strftime('%F')}"
    end
  end
end
