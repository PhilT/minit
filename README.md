Minit!
====================================

Minify JS and CSS in all environments except development and test for Ruby on Rails 3 apps.

No frills, no configuration, opinionated packager. Use it, fork it or use something else.

This gem aims to fix two shortcomings in the main two asset packaging libraries, namely:

1. Jammit requires Java to package CSS
2. asset_packager requires a configuration file to specify every single CSS or JS file

It uses CSSMin and JSMin gems from rgrove. Thanks!

It will ignore files that don't exist. It will only include files once.

It's less than 50 lines of code (and no, it's not forced)

Usage
====================================

    gem install minit

In your layout file add the following to `<head>`:

    = include_stylesheets
    = include_javascripts

Then ensure this folder structure to get the correct load order:

    public/
      javascripts/
        lib/
          jquery.js (for example)
        plugins/
          jquery_ui/ (for example)
            jquery.menu.js (for example)
        application.js (your own JS for example)

      stylesheets/
        reset.css
        default.css
        lib/
          *
        *

Status / Todo
====================================

First alpha release

This was hacked together one afternoon as I was fed up seeing the error message that
Jammit couldn't compress because Java wasn't installed on our CentOS server. I wanted
to see if it was easy enough to put together a simpler solution.

So it needs some tests which will follow shortly.

Feel free to report bugs in Issues.

Development
====================================

Minit uses MiniSpec, FakeFS, Watchr, RVM

