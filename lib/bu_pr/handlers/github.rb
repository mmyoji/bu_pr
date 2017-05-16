# frozen_string_literal: true

require "octokit"
require "compare_linker"

module BuPr
  module Handlers
    class Github
      attr_reader :base           # @return [String] base branch name
      attr_reader :current_branch # @return [String]
      attr_reader :repo           # @return [String]
      attr_reader :title          # @return [String]
      attr_reader :token          # @return [String]
      attr_reader :linker         # @return [CompareLinker]

      # @param attrs [Hash]
      def initialize attrs = {}
        config          = attrs[:config]

        @current_branch = attrs[:current_branch]

        @base  = config.branch
        @repo  = config.repo
        @title = config.title
        @token = config.token
      end

      def call
        number = create_pull_request
        diff_comment(number)
      end

      # @return [Integer] pull-request ID
      def create_pull_request
        res = client.create_pull_request \
          repo,
          base,
          current_branch,
          title

        res[:number]
      end

      # @param pr_number [Integer]
      def diff_comment pr_number
        load_linker(pr_number)
        linker.add_comment repo, pr_number, comment_content
      end

      private

      # @private
      # @return [Octokit::Client]
      def client
        @client ||= ::Octokit::Client.new(
          access_token: token,
        )
      end

      # @private
      # @return [String]
      def comment_content
        "#{linker.make_compare_links.to_a.join("\n")}"
      end

      # @private
      # @return [CompareLinker]
      def load_linker pr_number
        ENV['OCTOKIT_ACCESS_TOKEN'] = token

        @linker           = ::CompareLinker.new repo, pr_number
        @linker.formatter = ::CompareLinker::Formatter::Markdown.new
        @linker
      end
    end
  end
end
