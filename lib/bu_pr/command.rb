# frozen_string_literal: true

require "optparse"

module BuPr
  class Command
    # Entry Point
    #
    # @note for backward compatibility
    def self.start args
      Runner.call \
        new(args).parse
    end

    attr_reader :args
    attr_reader :opts

    # @param args [Array<String>]
    def initialize args
      @args = args
      @opts = {}
    end

    # @return [Hash<Symbol, String>]
    def parse
      parser.parse! args
      opts
    end

    private

    def parser
      ::OptionParser.new do |o|
        o.banner = "Usage: bu_pr [options]"

        o.on("-b", "--branch [NAME]",  String, "Base branch name")   { |v| opts[:branch] = v }
        o.on("-t", "--title  [TITLE]", String, "pull-request title") { |v| opts[:title]  = v }
        o.on("-k", "--token  [TOKEN]", String, "GitHub Token")       { |v| opts[:token]  = v }
        o.on("-r", "--repo   [NAME]",  String, "GitHub repo name")   { |v| opts[:repo]   = v }
      end
    end
  end
end
