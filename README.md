# Numo::Pocketfft

[![Gem Version](https://badge.fury.io/rb/numo-pocketfft.svg)](https://badge.fury.io/rb/numo-pocketfft)
[![Build Status](https://travis-ci.org/yoshoku/numo-pocketfft.svg?branch=master)](https://travis-ci.org/yoshoku/numo-pocketfft)
[![Coverage Status](https://coveralls.io/repos/github/yoshoku/numo-pocketfft/badge.svg?branch=master)](https://coveralls.io/github/yoshoku/numo-pocketfft?branch=master)
[![BSD 3-Clause License](https://img.shields.io/badge/License-BSD%203--Clause-orange.svg)](https://github.com/yoshoku/numo-pocketfft/blob/master/LICENSE.txt)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](https://yoshoku.github.io/numo-pocketfft/doc/)

Numo::Pocketfft provides functions for performing descrete Fourier Transform with
[Numo::NArray](https://github.com/ruby-numo/numo-narray) by using
[pocketfft](https://gitlab.mpcdf.mpg.de/mtr/pocketfft) as backgroud library.

Note: There are other useful Ruby gems perform descrete Fourier Transform with Numo::NArray:
[Numo::FFTW](https://github.com/ruby-numo/numo-fftw) and [Numo::FFTE](https://github.com/ruby-numo/numo-ffte) by Masahiro Tanaka.

## Installation

Numo::Pocketfft bundles pocketfft codes, so there is no need to install another external library in advance.
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
# => Numo::DFloat#shape=[4]
# [1, 1, 1, 1]

b = Numo::Pocketfft.rfft(a)
# => Numo::DComplex#shape=[3]
# [4+0i, 0+0i, 0+0i]

Numo::Pocketfft.irfft(b)
# => Numo::DFloat#shape=[4]
# [1, 1, 1, 1]

c = Numo::DFloat.new(2, 2).rand + Complex::I * Numo::DFloat.new(2, 2).rand
# => Numo::DComplex#shape=[2,2]
# [[0.0617545+0.116041i, 0.373067+0.344032i],
#  [0.794815+0.539948i, 0.201042+0.737815i]]

Numo::Pocketfft.ifft2(Numo::Pocketfft.fft2(c))
#=> Numo::DComplex#shape=[2,2]
#[[0.0617545+0.116041i, 0.373067+0.344032i],
# [0.794815+0.539948i, 0.201042+0.737815i]]
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
