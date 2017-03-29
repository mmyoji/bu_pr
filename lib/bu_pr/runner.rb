# frozen_string_literal: true

module BuPr
  class Runner
    class << self
      def call opts = {}
        new(opts).call
      end
    end

    attr_reader :git
    attr_reader :config

    def initialize opts = {}
      @git    = Git.new
      @config = Configuration.new(opts)
    end

    def call
      if bundle_update && !git.diff?
        puts "no update"
        return
      end

      git.push

      handler = Handlers::Github.new config: config, current_branch: git.current_branch
      handler.call
    end

    def bundle_update
      valid? && _bundle_update
    end

    def valid?
      unless config.valid?
        raise "Invalid configuration"
      end

      unless git.installed?
        raise "Git is not installed"
      end

      true
    end

    private

    def _bundle_update
      return true if system("bundle update")

      raise "Error(s) happened"
    end
  end
end
