# trange_frange #

[![Gem Version](https://badge.fury.io/rb/trange_frange.svg)](http://badge.fury.io/rb/trange_frange)
[![Build Status](https://travis-ci.org/rubyengineer/trange_frange.svg?branch=master)](https://travis-ci.org/rubyengineer/trange_frange)
[![Code Climate](https://codeclimate.com/github/rubyengineer/trange_frange/badges/gpa.svg)](https://codeclimate.com/github/rubyengineer/trange_frange)
[![Dependency Status](https://gemnasium.com/rubyengineer/trange_frange.svg)](https://gemnasium.com/rubyengineer/trange_frange)

The tool spells out numbers (amounts) in words. It supports serbian language and amounts up to 999 bilions.
> 12345.67 => 'dvanaest hiljada tri stotine četrdeset pet i 67/100'

## Install ##
```bash
$ gem install trange_frange
```

## Examples ##
```ruby
require 'trange_frange'
amount = TrangeFrange::Amount.new(16345.67)
amount.spell!
=> "šesnaest hiljada tri stotine četrdeset pet"
```
including a fraction
```ruby
amount.spell! show_fraction: true
=> 'šesnaest hiljada tri stotine četrdeset pet i 67/100'
```
disabling spacing between words
```ruby
amount.spell! squeeze: true
=> 'šesnaesthiljadatristotinečetrdesetpet'
```
disabling accented lating characters
```ruby
amount.spell! bald: true
=> 'sesnaest hiljada tri stotine cetrdeset pet'
```
combined options
```ruby
amount.spell! show_fraction: true, squeeze: true, bald: true
=> 'sesnaesthiljadatristotinecetrdesetpet i 67/100'
```

### Copyright ###
Copyright (c) 2014 Nino Milenovic

See LICENSE.txt for details.
