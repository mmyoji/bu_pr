namespace :bu_pr do
  desc "Run `bundle update` and create pull-request"
  task all: :environment do
    BuPr::Runner.call
  end
end
