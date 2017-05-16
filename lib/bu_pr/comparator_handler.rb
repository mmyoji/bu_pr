# frozen_string_literal: true

module BuPr
  # TODO:
  class ComparatorHandler
    attr_accessor :old_comparator
    attr_accessor :new_comparator

    def initialize old_comparator
      @old_comparator = old_comparator
    end

    def compare!
      diff = old_comparator.diff new_comparator

      # TODO:
      #   - fetch owner by RubyGems API
      #   - Detect GitHub repository
      diff.each do |hash|
        if hash[:owner].nil?
          RepositoryURIDetector.find(hash[:gem])
        end
      end
    end
  end
end
