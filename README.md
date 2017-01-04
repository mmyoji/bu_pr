# BuPr

[![Build Status](https://travis-ci.org/mmyoji/bu_pr.svg?branch=master)](https://travis-ci.org/mmyoji/bu_pr)

Run `bundle update` and create its pull-request.


## Installation

```rb
gem 'bu_pr', group: :development
```

And then execute:

    $ bundle


Or install it yourself as:

    $ gem install bu_pr

## Usage

Get Github access token from [this page](https://github.com/settings/tokens/new) with `repo` scope.

```rb
require 'bu_pr'

# Setup
BuPr.configure do |config|
  config.access_token = "xxx"          # Required: or check ENV["BUPR_TOKEN"]
  config.repo_name    = "mmyoji/bu_pr" # Required: or check ENV["BUPR_REPO"]

  config.branch   = "develop"          # Optional: default is 'master'
  config.pr_title = "My bundle update" # Optional: default is like 'Bundle update 2016-11-13'
end

BuPr::Runner.call
```

or if you're using Rails,

```rb
# config/initializers/bu_pr.rb
BuPr.configure do |config|
  config.access_token = "xxx"
  config.repo_name    = "mmyoji/bu_pr"
end
```

then run the following commands

```sh
# Run all tasks
$ bin/rake bu_pr:all

# If you want to execute each task,

# Run `bundle update` only
$ bin/rake bu_pr:bu

# Create pull-request
$ bin/rake bu_pr:pr

# Add gem diff comment
$ bin/rake bu_pr:diff
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mmyoji/bu_pr.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

