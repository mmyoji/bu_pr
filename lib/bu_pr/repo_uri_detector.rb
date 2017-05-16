# frozen_string_literal: true

require "uri"
require "net/http"
require "json"

module BuPr
  class RepoURIDetector
    def self.detect(name)
      d = new(name)
      d.detect!
      d
    end

    attr_reader :name         # @return [String] gem name
    attr_reader :uri          # @return [String] gem's GitHub repository URL
    attr_reader :fallback_uri # @return [String] gem's rubygems URL

    # @param name [String]
    def initialize name
      @name = name
    end

    #
    def detect!
      @uri = data["homepage_uri"] || data["source_code_uri"]

      @fallback_uri = data["project_uri"] # rubygems URL
    end

    private

    # @example
    #   {
    #     "name"=>"bu_pr",
    #     "downloads"=>3777,
    #     "version"=>"0.6.0",
    #     "version_downloads"=>31,
    #     "platform"=>"ruby",
    #     "authors"=>"Masaya Myojin",
    #     "info"=>"BuPr is simple pull request creator for the daily bundle update.",
    #     "licenses"=>["MIT"],
    #     "metadata"=>{},
    #     "sha"=>"2267bfe6890d6df638d0de500e9bc712c2de979e9f4f1a1d22ab0d5d29b870f7",
    #     "project_uri"=>"https://rubygems.org/gems/bu_pr",
    #     "gem_uri"=>"https://rubygems.org/gems/bu_pr-0.6.0.gem",
    #     "homepage_uri"=>"https://github.com/mmyoji/bu_pr",
    #     "wiki_uri"=>nil,
    #     "documentation_uri"=>"http://www.rubydoc.info/gems/bu_pr/0.6.0",
    #     "mailing_list_uri"=>nil,
    #     "source_code_uri"=>nil,
    #     "bug_tracker_uri"=>nil,
    #     "changelog_uri"=>nil,
    #     "dependencies"=>{
    #       "development"=>[
    #         {"name"=>"bundler","requirements"=>"~> 1.13"},
    #         {"name"=>"rake", "requirements"=>"~> 10.0"},
    #         {"name"=>"rspec", "requirements"=>"~> 3.0"}
    #       ],
    #       "runtime"=>[
    #         {"name"=>"compare_linker", "requirements"=>"~> 1.1.0"}
    #       ]
    #     }
    #   }
    def data
      @data ||=
        begin
          res = Net::HTTP.get request_uri
          JSON.parse res
        end
    end

    def request_uri
      ::URI.parse "https://rubygems.org/api/v1/gems/#{name}.json"
    end
  end
end
