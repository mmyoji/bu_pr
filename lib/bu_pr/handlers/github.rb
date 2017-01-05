# frozen_string_literal: true

require "octokit"
require "compare_linker"

module BuPr
  module Handlers
    class Github
      attr_reader :base
      attr_reader :current_branch
      attr_reader :repo
      attr_reader :title
      attr_reader :token
      attr_reader :linker

      def initialize attrs = {}
        config          = attrs[:config]

        @current_branch = attrs[:current_branch]

        @base  = config.branch
        @repo  = config.repo
        @title = config.title
        @token = config.access_token
      end

      def call
        number = create_pull_request
        diff_comment(number)
      end

      def create_pull_request
        res = client.create_pull_request \
          repo,
          base,
          current_branch,
          title

        res[:number]
      end

      def diff_comment pr_number
        load_linker(pr_number)
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

      def load_linker pr_number
        ENV['OCTOKIT_ACCESS_TOKEN'] = token

        @linker           = ::CompareLinker.new repo, pr_number
        @linker.formatter = ::CompareLinker::Formatter::Markdown.new
        @linker
      end
    end
  end
end
