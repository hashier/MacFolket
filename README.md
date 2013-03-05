MacFolket
=========

A Swedish - English dictionary for Mac OS X which is integrated into the system.


Screenshot
----------

![screenshot](http://loessl.org/projekte/macfolket/images/svendict.jpg)


Building
--------

- Clone this git repository
- Download Apples [Dictionary Development Kit](https://developer.apple.com/downloads/) (The packages is called "Auxiliary Tools for Xcode")
- Copy the "Dictionary Development Kit" into the repo
- make sure you have $REPOSITORY/Dictionary\ Development\ Kit/bin in your $PATH
- make
- Optional make validate (you need to install jing for that)
- make install


Caveats
-------

- Only the first entry is displayed in pop-up mode instead of all (e.g. "boken" shows only "beech")


Thanks to
---------

Philipp Brauner who build an English <-> German dictionary which I have used now for a couple of years. His plugin gave me the idea to build an Engish <-> Swedish one.
Here you can find his English <-> German one: http://lipflip.org/articles/dictcc-dictionary-plugin

