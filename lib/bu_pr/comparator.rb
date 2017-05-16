# frozen_string_literal: true

require "bundler"

module BuPr

  class Comparator
    # TODO
    LOCKFILE = "Gemfile.lock"

    attr_reader :parser # @return [Bundler::LockfileParser]

    def initialize
      @parser = load_file
    end

    # @param another [BuPr::Comparator]
    #
    # @return [Hash<String, Hash>]
    # @example
    #   {
    #     "draper" => {
    #       owner:        "draper",
    #       gem:          "draper",
    #       new_revision: "xxxx",
    #       old_revision: "xxxxxx",
    #     },
    #     "devise" => {
    #       owner:       nil,
    #       gem:         nil,
    #       new_version: "x.x.x",
    #       old_version: "y.y.y",
    #     },
    #   }
    def diff another
      acc = {}

      specs.each do |s1|
        another.specs.each do |s2|
          next if s1.name != s2.name

          acc[s1.name] = SpecComparator.diff(s1, s2)
        end
      end

      acc.select { |_, v| !v.nil? }
    end

    protected

    def specs
      parser.specs
    end

    private

    # @return [Pathname]
    def file_path
      @file_path ||= ::Bundler.root + LOCKFILE
    end

    def load_file
      ::Bundler::LockfileParser.new \
        ::File.read(file_path)
    end
  end
end
