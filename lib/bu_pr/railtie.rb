# frozen_string_literal: true

module BuPr
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load "bu_pr/tasks/bu_pr.rake"
    end
  end
end
