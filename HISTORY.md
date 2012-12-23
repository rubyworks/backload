# RELEASE HISTORY

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

