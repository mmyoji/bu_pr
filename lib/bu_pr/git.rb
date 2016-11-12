# frozen_string_literal: true

module BuPr
  class Git
    LOCKFILE = "Gemfile.lock"

    def current_branch
      @current_branch ||=
        begin
          branches.each_line do |line|
            matched = line.strip.match(/\*\s+(?<current_branch>.+)/)
            next unless matched

            break matched["current_branch"]
          end
        end
    end

    def diff?
      `git status`.include?(LOCKFILE)
    end

    def installed?
      system("git --help > /dev/null 2>&1")
    end

    def push
      add && commit && _push
    end

    private

    def add
      `git add #{LOCKFILE}`
    end

    def branches
      `git branch`.strip
    end

    def commit
      `git commit -m "bundle update"`
    end

    def _push
      `git push origin #{current_branch}`
    end
  end
end
