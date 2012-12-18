[Homepage](http://rubygems.org/gems/loaded) |
[Report Issue](http://github.com/rubyworks/loaded/issues) |
[Source Code](http://github.com/rubyworks/loaded) 
( [![Build Status](https://secure.travis-ci.org/rubyworks/loaded.png)](http://travis-ci.org/rubyworks/loaded) )


# Loaded

Shouldn't loading have a callback?

Note the change in API from v. 0.0 to 0.1. Now there is only one callback method, namely `#loaded`,
that both `#load` and `#require` call. Which was used can be determined by the `options` argument.


## Installation

Using RubyGems type on a command line:

    $ gem install loaded


## Instruction

To use the loaded callback simply override `Kernel.loaded` method.

```ruby
  require 'loaded'
  require 'loaded/require_relative'

  def Kernel.loaded(feature, options={})
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


## Feedback

Please report issues or suggestions to
[GitHub Issues](http://github.com/rubyworks/required/issues).
Or if you wish to discuss in real-time try [IRC #rubyworks](irc://chat.us.freenet.org/rubyworks) on freenode.net.


## Copying

Copyright 2012 Rubyworks.

Made available under the **BSD-2-Clause** license.

See LICENSE.txt for details.

