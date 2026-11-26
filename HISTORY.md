# RELEASE HISTORY

## 0.3.0 / 2026-11-26

Backload is revived, for Ruby 3.1 and up.

Changes:

* Add `Kernel.backloading`, called before every load. Until now there
  were only callbacks for afterwards. (#4)
* Add the `:depth` option, which says how many loads a load is inside
  of, so that what required what can be shown as a tree. (#2)
* Add `backload/trace`, which prints that tree:
  `ruby -rbackload/trace script.rb`.
* The `require_relative` callback is always on. It no longer has to be
  asked for with `backload/require_relative`. That file, and
  `backload/require` and `backload/load`, now just load Backload.
* `Kernel.required_relative` is given the directory as a second
  argument. A callback that takes only the feature still works. (#5)
* The hooks are put in place with `Module#prepend` instead of aliases.
* The callbacks are no longer defined as empty methods, so defining one
  doesn't warn of a method redefined.
* Tests run on Spectrum.

Fixes:

* `require_relative` raised "Can't parse" on current Ruby, whose
  backtrace lines have changed. The directory now comes from
  `caller_locations`.


## 0.2.0 / 2012-12-22

Change the name of the project from Loaded to Backload, and
changed the main callback method from `#loaded` to `#backloaded`.
Then re-added `#loaded`, `#required` and `#required_relative` as
straight callbacks for their corresponding present-tense methods.
This makes the library backward compatible with v0.1.0.

Changes:

* Rename project to "backload".
* Add basic callbacks for load, require and require_relative.
* Master callback is renamed to `#backloaded`.


## 0.1.1 / 2012-12-19

Just a tweak to require_relative support, so that the `:relative`
option provides the relative path, not just `true` or `false`.

Changes:

* The :relative option provides the relative path.


## 0.1.0 / 2012-12-18

This release uses a single callback method `#loaded` instead
of the previous two (`#loaded` and `#required`). It also adds
optional support for `#require_relative`.

Changes:

* Use single callback method.
* Add support for #require_relative.


## 0.0.1 / 2012-04-29

Initial release of Loaded.

Changes:

* Created and implemented.

