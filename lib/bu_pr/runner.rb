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

    # @private
    # @return [BuPr::Git]
    attr_reader :git

    # @private
    # @return [BuPr::Configuration]
    attr_reader :config

    # @private
    # @param opts [Hash]
    # @see BuPr::Configuration#initialize
    def initialize opts = {}
      @git    = Git.new
      @config = Configuration.new(opts)
    end

    # @private
    def call
      if bundle_update && !git.diff?
        puts "no update"
        return
      end

      git.push

      handler = Handlers::Github.new config: config, current_branch: git.current_branch
      handler.call
    end

    # @private
    # @return [Boolean]
    def bundle_update
      valid? && _bundle_update
    end

    # @private
    # @return [Boolean]
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
