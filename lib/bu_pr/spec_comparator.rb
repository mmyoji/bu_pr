# frozen_string_literal: true

module BuPr
  class SpecComparator
    URI_PAT = %r{github\.com/(?<owner>(\S+))/(?<gem>(\S+))\.}

    attr_reader :olds
    attr_reader :news

    attr_reader :oldr # @return [String]
    attr_reader :newr # @return [String]

    attr_reader :oldv # @return [Gem::Version]
    attr_reader :newv # @return [Gem::Version]

    attr_reader :owner # @return [String]
    attr_reader :gem   # @return [String]

    # Entry Point
    # @return [Hash]
    def self.diff olds, news
      c = new olds, news

      return c.revision_diff if c.revision?

      c.version_diff
    end

    # @param olds [Bundler::LazySpecification]
    # @param news [Bundler::LazySpecification]
    def initialize olds, news
      @olds, @news = olds, news

      load_revisions
      load_versions
      load_owner_and_gem
    end

    def revision?
      !oldr.nil? && !newr.nil? && oldr != newr
    end

    # @return [Hash<Symbol, String>]
    def revision_diff
      return if oldr == newr

      {
        owner:        owner,
        gem:          gem,
        new_revision: newr,
        old_revision: oldr,
      }
    end

    # @return [Hash<Symbol, String>]
    def version_diff
      return if oldv == newv

      {
        owner:       owner,
        gem:         gem,
        new_version: newv.to_s,
        old_version: oldv.to_s,
      }
    end

    private

    # @private
    def load_owner_and_gem
      m = uri.match URI_PAT

      # If found :owner and :gem, it's a rare case.
      @owner = m&.[](:owner)
      @gem   = m&.[](:gem) || olds.name
    end

    # @private
    def load_revisions
      @oldr = olds.source.options["revision"]
      @newr = news.source.options["revision"]
    end

    # @private
    def load_versions
      @oldv = olds.version
      @newv = news.version
    end

    # @private
    # @return [String]
    def uri
      (s = olds.source).respond_to?(:uri) ? s.uri : ""
    end
  end
end
