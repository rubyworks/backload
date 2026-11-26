# Backload

[Source Code](https://github.com/rubyworks/backload) /
[Report Issue](https://github.com/rubyworks/backload/issues) &nbsp; &nbsp;
[![CI](https://github.com/rubyworks/backload/actions/workflows/ci.yml/badge.svg)](https://github.com/rubyworks/backload/actions/workflows/ci.yml)

**Shouldn't loading have a callback?**

Backload gives Ruby's `require`, `require_relative` and `load` callbacks,
before and after, so a program can see what is loaded, when, and from
inside what. It needs Ruby 3.1 or newer.

    $ gem install backload


## Seeing what a program loads

To print every load as a tree, without writing anything:

    $ ruby -rbackload/trace script.rb

    require json
      require json/common
        require json/version
    require_relative lib/thing
      require set

The tree goes to standard error. Each line is printed as the load starts,
and is indented by how many loads it is inside of. A feature that was
already loaded is still listed, since it was asked for.


## The callbacks

For anything else, require `backload` and define the callbacks you want
as methods of `Kernel`. None of them exists until you define it.

```ruby
require 'backload'

def Kernel.backloading(feature, options={})
  puts "#{'  ' * options[:depth]}loading #{feature}"
end

def Kernel.backloaded(feature, options={})
  if options[:require]
    if dir = options[:relative]
      puts "#{feature} has been required relative to #{dir}"
    else
      puts "#{feature} has been required"
    end
  else
    puts "#{feature} has been loaded"
  end
end
```

`Kernel.backloading` is called before every `require`, `require_relative`
and `load`. `Kernel.backloaded` is called after each one that loaded
something: not when `require` returns false because the feature was
loaded before, and not when the load raises.

The options say what happened:

| Option      | Value                                                        |
|-------------|--------------------------------------------------------------|
| `:require`  | true for `require` and `require_relative`                    |
| `:load`     | true for `load`                                              |
| `:relative` | for `require_relative`, the directory it is relative to      |
| `:wrap`     | for `load`, its second argument                              |
| `:depth`    | how many loads this one is inside of; 0 at the top           |

There is also a plain callback for each method, called after it, named by
its past tense:

```ruby
def Kernel.required(feature)
  puts "#{feature} required"
end

def Kernel.loaded(path, wrap)
  puts "#{path} loaded"
end

def Kernel.required_relative(feature, directory)
  puts "#{feature} required relative to #{directory}"
end
```


## Notes

* An `autoload` is seen as the `require` it makes when the constant is
  first used.
* `require_relative` can't be wrapped like the others, because Ruby works
  out the directory from the file that called it. Backload finds the
  directory itself and requires the file by its full path, which is what
  `require_relative` does. Before 0.3 this had to be asked for with
  `require 'backload/require_relative'`; it is now always on.
* The hooks are put in front of Kernel's methods with `Module#prepend`,
  so they work alongside RubyGems, Bundler and others that redefine
  `require`.
* The nesting depth is counted for each thread.


## Copying

Copyright (c) 2012 Rubyworks

Backload is distributed under the terms of the **BSD-2-Clause** license.
See LICENSE.txt for details.
