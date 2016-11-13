# frozen_string_literal: true

require "octokit"
require "compare_linker"

module BuPr
  module Handlers
    class Github
      attr_reader :base, :current_branch, :repo, :title, :token

      def initialize(attrs = {})
        config          = attrs[:config]

        @current_branch = attrs[:current_branch]

        @base  = config.base_branch
        @repo  = config.repo_name
        @title = config.pr_title
        @token = config.access_token
      end

      def call
        linker.add_comment repo, pr_number, comment_content
      end

      private

      def client
        @client ||= ::Octokit::Client.new(
          access_token: token,
        )
      end

      def comment_content
        "#{linker.make_compare_links.to_a.join("\n")}"
      end

      def linker
        @linker ||=
          begin
            ENV['OCTOKIT_ACCESS_TOKEN'] = token

            l           = ::CompareLinker.new repo, pr_number
            l.formatter = ::CompareLinker::Formatter::Markdown.new

            l
          end
      end

      def pr_number
        @pr_number ||=
          begin
            res = client.create_pull_request \
              repo,
              base,
              current_branch,
              title

            res[:number]
          end
      end
    end
  end
end
