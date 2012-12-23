[Homepage](http://rubygems.org/gems/backload) |
[Report Issue](http://github.com/rubyworks/backload/issues) |
[Source Code](http://github.com/rubyworks/backload) 
( [![Build Status](https://secure.travis-ci.org/rubyworks/backload.png)](http://travis-ci.org/rubyworks/backload) )


# Backload

Shouldn't loading have a callback?


## Installation

Using RubyGems type on a command line:

    $ gem install backload


## Instruction

To use Backload simply override the `Kernel.backloaded` method.

```ruby
  require 'backload'
  require 'backload/require_relative'

  def Kernel.backloaded(feature, options={})
    if options[:require]
      if rel = options[:relative]
        puts "#{feature} has been required relative to #{rel}!"
      else
        puts "#{feature} has been required!"
      end
    else
      if wrap = options[:wrap]
        puts "#{feature} has been loaded with wrap, it's #{wrap}!"  
      else
        puts "#{feature} has been loaded!" 
      end
    end
  end
```

Becuase of implementation details, `#require_relative` has to be reimplemented completely 
to make the callback work. To be on the safe side, at least for now, it therefore has to
be required separately, as the example above demonstrates.

Backload also provides callbacks for each type of loading. Just use the past tense
of the term for any of `#load`, `#require` and `#require_relative`. For example, to
see all features as they have been required.

```ruby
  def Kernel.required(feature)
    puts "#{feature} required!"
  end
```

## Feedback

Please report issues or suggestions to
[GitHub Issues](http://github.com/rubyworks/backload/issues).
Or if you wish to discuss in real-time try [IRC #rubyworks](irc://chat.us.freenet.org/rubyworks) on freenode.net.


## Copying

Copyright 2012 Rubyworks.

Made available under the **BSD-2-Clause** license.

See LICENSE.txt for details.

