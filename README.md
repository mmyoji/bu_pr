# BuPr

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

```rb
require 'bu_pr'

# Setup
BuPr.configure do |config|
  config.access_token = "xxx"              # Required: or check ENV["BUPR_TOKEN"]
  config.repo_name    = "mmyoji/bu_pr"     # Required: or check ENV["BUPR_REPO"]

  config.base_branch  = "develop"          # Optional: default is 'master'
  config.pr_title     = "My bundle update" # Optional: default is like 'Bundle update 2016-11-13'
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

then run the following command

```sh
$ bin/rake bu_pr:all
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mmyoji/bu_pr.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

