# frozen_string_literal: true

if defined?(Rails::Railtie)
  module BuPr
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load "bu_pr/tasks/bu_pr.rake"
      end
    end
  end
end
