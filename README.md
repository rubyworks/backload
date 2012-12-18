[![Build Status](https://secure.travis-ci.org/rubyworks/loaded.png)](http://travis-ci.org/rubyworks/loaded) ::
[Homepage](http://rubygems.org/gems/loaded) /
[Development](http://github.com/rubyworks/loaded) /
[Report Issue](http://github.com/rubyworks/loaded/issues)


# Loaded

## Description

Shouldn't loading have a callback?

Note the change in API from v. 0.0 to 0.1. Now ther is only one callback method, namely `#loaded`,
that both `#load` and `#require` call. Which was used can be determined by the `options[:load]` argument.


## Installation

Using RubyGems type on a command line:

    $ gem install loaded


## Instruction

To use the loaded callback simply override `Kernel.loaded` method.

```ruby
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

Unfortunately `#require_relative` doesn't work with the callback at this time due to
an implemention difficulty.


## Feedback

Please report issues or suggestions to
[GitHub Issues](http://github.com/rubyworks/required/issues).
Or if you wish to discuss in real-time try [IRC #rubyworks](irc://chat.us.freenet.org/rubyworks) on freenode.net.


## Copying

Copyright 2012 Rubyworks.

Made available under the **BSD-2-Clause** license.

See LICENSE.txt for details.

