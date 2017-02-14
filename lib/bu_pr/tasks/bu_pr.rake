desc "Run bu_pr all tasks"
task bu_pr: :environment do
  BuPr::Runner.call
end
