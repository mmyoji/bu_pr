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

Get GitHub access token from [this page](https://github.com/settings/tokens/new) with `repo` scope.

then run

```sh
$ bundle exec bu_pr --repo=mmyoji/bu_pr --token=<the token you got above>
```

or you can just set `repo` and `token` values in your `$HOME/.profile` file.

```sh
# .bash_profile / .profile / .zshrc / etc.

export BUPR_TOKEN="xxx"
export BUPR_REPO="mmyoji/bu_pr"

# If you wanna override them:
# export BUPR_BRANCH="develop"
# export BUPR_TITLE="My bundle update"
```

### Available options

* branch: base branch name for the pull-request. Default is `master`
* repo: your github repository name
* title: the pull-request title. Default is `Bundle update 2017-04-04`
* token: your GitHub access token

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mmyoji/bu_pr.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

