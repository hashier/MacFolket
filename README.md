MacFolket
=========

A Swedish - English dictionary for Mac OS X which is nicely integrated into the system.


Screenshot
----------

![Screenshot](http://loessl.org/projekte/macfolket/images/svendict.jpg)


Video
-----

[![Video](http://img.youtube.com/vi/gWR_BvioaVw/0.jpg)](http://youtu.be/gWR_BvioaVw "This video shows the installation")


Installation
------------

You can find ready to install .pkg file here: [Download](http://macfolket.googlecode.com/files/MacFolket-2013-03-06.pkg)

If you run into problems while opening the .pkg file like this:

![Undef](http://loessl.org/projekte/macfolket/images/undef.png)

You can work around this problem by right clicking or Ctrl+clicking on the .pkg file and select "Open" from the context menu. On [imore](http://www.imore.com/how-open-apps-unidentified-developer-os-x-mountain-lion) you can find pictures how to do it and even a second way.


Building
--------

- Clone this git repository
- Download Apples [Dictionary Development Kit](https://developer.apple.com/downloads/) (The packages is called "Auxiliary Tools for Xcode")
- Copy the "Dictionary Development Kit" somewhere and adjust the Makefile accordingly
- make
- Optional make validate (you need to install jing for that)
- make install


Caveats
-------

- Only the first entry is displayed in pop-up mode instead of all (e.g. "boken" shows only "beech") but you will see all of them in dictionary.app.


Thanks to
---------

Philipp Brauner who build an English <-> German dictionary which I have used now for a couple of years. His plugin gave me the idea to build an English <-> Swedish one.
Here you can find his English <-> German one: http://lipflip.org/articles/dictcc-dictionary-plugin.

