# frozen_string_literal: true

module BuPr
  class Runner
    class << self
      def configure
        @config = yield Configuration.instance
      end

      def config
        @config ||= Configuration.instance
      end

      def call
        new.call
      end
    end

    attr_reader :git

    def initialize
      @git = Git.new
    end

    def call
      if valid? && bundle_update && !git.diff?
        puts "no update"
        exit
      end

      git.push

      handler = Handlers::Github.new config: config, current_branch: git.current_branch
      handler.call
    end

    def config
      self.class.config
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

    def bundle_update
      return true if system("bundle update")

      raise "Error(s) happened"
    end
  end
end
