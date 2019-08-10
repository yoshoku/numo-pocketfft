# Numo::Pocketfft

[![Build Status](https://travis-ci.org/yoshoku/numo-pocketfft.svg?branch=master)](https://travis-ci.org/yoshoku/numo-pocketfft)
[![Coverage Status](https://coveralls.io/repos/github/yoshoku/numo-pocketfft/badge.svg?branch=master)](https://coveralls.io/github/yoshoku/numo-pocketfft?branch=master)
[![BSD 3-Clause License](https://img.shields.io/badge/License-BSD%203--Clause-orange.svg)](https://github.com/yoshoku/numo-liblinear/blob/master/LICENSE.txt)

Numo::Pocketfft provides functions for descrete Fourier Transform based on [pocketfft](https://gitlab.mpcdf.mpg.de/mtr/pocketfft).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'numo-pocketfft'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install numo-pocketfft

## Usage

```ruby
require 'numo/narray'
require 'numo/pocketfft'

a = Numo::DFloat[1, 1, 1, 1]
b = Numo::Pocketfft.irftt(Numo::Pocketfft.rfft(a))
p (a - b).sum # print 0
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshoku/numo-pocketfft. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [BSD-3-Clause License](https://opensource.org/licenses/BSD-3-Clause).

## Code of Conduct

Everyone interacting in the Numo::Pocketfft project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yoshoku/numo-pocketfft/blob/master/CODE_OF_CONDUCT.md).
