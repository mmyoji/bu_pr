# frozen_string_literal: true

module BuPr
  class Runner
    class << self
      # @param opts [Hash]
      # @see BuPr::Configuration#initialize
      def call opts = {}
        new(opts).call
      end
    end

    attr_reader :git    # @return [BuPr::Git]
    attr_reader :config # @return [BuPr::Configuration]

    # @param opts [Hash]
    # @see BuPr::Configuration#initialize
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

      Handlers::Github.call \
        config:         config,
        current_branch: git.current_branch
    end

    # @return [Boolean]
    def bundle_update
      valid? && _bundle_update
    end

    # @return [Boolean]
    # @raise RuntimeError
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

    # @private
    # @return [Boolean]
    # @raise RuntimeError
    def _bundle_update
      return true if system("bundle update")

      raise "Error(s) happened"
    end
  end
end
