# frozen_string_literal: true

module BuPr
  # Custom errors
  class RequirementUnfulfilled < StandardError; end
  class InvalidConfigurations < StandardError; end

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
      @config = Configuration.new opts
    end

    def call
      # oldc = Comparator.new
      # handler = ComparatorHandler.new(oldc)
      # 1. Get current Gemfile
      # 2. Run `bundle update`
      # 3. Compare ex and current Gemfiles
      # 4. Find diffs
      # 5. Find `compare` links from GitHub
      # 6. Create p-r with diff links

      if bundle_update && !git.diff?
        puts "no update"
        return
      end

      # newc = Comparator.new
      # handler.new_comparator = newc
      # handler.compare!
      # comparator.load_current!

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
    # @raise [BuPr::InvalidConfigurations]
    # @raise [BuPr::RequirementUnfulfilled]
    def valid?
      check_config! && check_git!
    end

    private

    # @private
    # @return [Boolean]
    # @raise RuntimeError
    def _bundle_update
      return true if system("bundle update")

      raise "Error(s) happened"
    end

    # @private
    # @return [Boolean]
    # @raise [BuPr::InvalidConfigurations]
    def check_config!
      return true if config.valid?

      raise InvalidConfigurations, "Invalid configuration"
    end

    # @private
    # @return [Boolean]
    # @raise [BuPr::RequirementUnfulfilled]
    def check_git!
      return true if git.installed?

      raise RequirementUnfulfilled, "Git is not installed"
    end
  end
end
