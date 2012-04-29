# Loaded

[Homepage](http://rubygems.org/gems/loaded) /
[Development](http://github.com/rubyworks/loaded) /
[Report Issue](http://github.com/rubyworks/loaded/issues)

[![Build Status](https://secure.travis-ci.org/rubyworks/loaded.png)](http://travis-ci.org/rubyworks/loaded)


## Description

Shouldn't loading have a callback?


## Installation

    $ gem install loaded


## Instruction

    def Kernel.loaded(feature, mod=nil)
      puts "#{feature} has been loaded!"
    end

    def Kernel.required(feature)
      puts "#{feature} has been required!"
    end


## Feedback

Please report issues or suggestions to
[GitHub Issues](http://github.com/rubyworks/required/issues).
Or if you wish to discuss in real-time try [IRC #rubyworks](irc://chat.us.freenet.org/rubyworks) on freenode.net.


## Copying

Copyright 2012 Rubyworks.

Made available under the **BSD-2-Clause** license.

See LICENSE.txt for details.

