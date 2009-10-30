Growlr
======

Give your rails apps growl based notifications. Basically a rails plugin wrapper for Stan's excellent jGrowl library. This is a nice alternative to static flash messages, plus it integrates with all flash messages automatically, no need to output flash messages in your view!

Requirements
============

- Jquery 1.2.6
- Cookies should be enabled --it should be by default 

Installation
============

1. rake growlr:install:all
2. include the following snippet in your layout or view file, preferably in the
   head section of your layout file.

        <%= include_growlr %>

Usage 
======

Growlr will automatically detect flash messages and display them accordingly. You can explicitly call Growlr by writing the following in your action or controller:

     growl "hello peoples"

You can also pass the same options as the jgrowl plugin.

Todo's
======

* work on the yml processing for the config files - should have support for multiple configs in one yaml file
* write the functional specs


Copyright Stuff
===============

- jGrowl : http://stanlemon.net/projects/jgrowl.html