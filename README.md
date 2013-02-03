# trange_frange #
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
to include a fraction
```ruby
require 'trange_frange'
amount = TrangeFrange::Amount.new(16345.67)
amount.spell! show_fraction: true
=> 'šesnaest hiljada tri stotine četrdeset pet i 67/100'
```
to disable spacing between words
```ruby
require 'trange_frange'
amount = TrangeFrange::Amount.new(16345.67)
amount.spell! squeeze: true
=> 'šesnaesthiljadatristotinečetrdesetpet'
```
to avoid using accented lating characters
```ruby
require 'trange_frange'
amount = TrangeFrange::Amount.new(16345.67)
amount.spell! bald: true
=> 'sesnaest hiljada tri stotine cetrdeset pet'
```
or combine the options
```ruby
require 'trange_frange'
amount = TrangeFrange::Amount.new(16345.67)
amount.spell! show_fraction: true, squeeze: true, bald: true
=> 'sesnaesthiljadatristotinecetrdesetpet i 67/100'
```

### Copyright ###
Copyright (c) 2013 Ninoslav Milenovic

See LICENSE.txt for details.
