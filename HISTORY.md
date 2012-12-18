# RELEASE HISTORY

## 0.1.1 | 2012-12-19

Just a tweak to require_relative support, so that the `:relative`
option provides the relative path, not just `true` or `false`.

Changes:

* The :relative option provides the relative path.


## 0.1.0 | 2012-12-18

This release uses a single callback method `#loaded` instead
of the previous two (`#loaded` and `#required`). It also adds
optional support for `#require_relative`.

Changes:

* Use single callback method.
* Add support for #require_relative.


## 0.0.1 | 2012-04-29

Initial release of Loaded.

Changes:

* Created and implemented.

