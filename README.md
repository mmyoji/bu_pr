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
  config.repo_name    = "mmyoji/bu_pr"
  config.access_token = "xxx"
end

BuPr::Runner.call
```

TODO: add rake task


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mmyoji/bu_pr.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

