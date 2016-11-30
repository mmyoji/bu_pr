namespace :bu_pr do
  desc "Run `bundle update`"
  task bu: :environment do
    puts "Running `bundle update`..."

    BuPr::Runner.new.bundle_update

    puts "Finished `bundle update`"
  end

  desc "Create pull-request"
  task pr: :environment do
    puts "Creating pull-request..."

    r       = BuPr::Runner.new
    handler = BuPr::Handlers::Github.new \
      config:         r.config,
      current_branch: r.git.current_branch

    pr_number = handler.create_pull_request

    puts "Finished: p-r number is `#{pr_number}`"
  end

  desc "Add gem diff comment"
  task diff: :environment do
    pr_number = ENV.fetch("PR_NUMBER")

    puts "Commenting..."

    r       = BuPr::Runner.new
    handler = BuPr::Handlers::Github.new \
      config:         r.config,
      current_branch: r.git.current_branch

    handler.diff_comment(pr_number)

    puts "Finished!"
  end

  desc "Run bu_pr all tasks"
  task all: :environment do
    BuPr::Runner.call
  end
end
