# MacFolket

A Swedish - English dictionary for Mac OS X which is nicely integrated into the system.

### **[Download Version v1.2](https://github.com/hashier/MacFolket/releases/download/v1.2/MacFolket-2014-03-23-v1.2.pkg.zip)**


## Installation guide

1. Download the zip file from above
2. Unzip the file
3. Install the .pkg file (Ctrl click on the .pkg file and chose "open")
4. Open the dictionary app and activate the Swedish - English dictionary in the settings

You can see a vieo of the installation process below.

**If you run into problems while opening the .pkg file like this:**

![Undef](https://github.com/hashier/MacFolket/raw/master/images/undef.png)

You can work around this problem by right clicking or Ctrl+clicking on the .pkg file and select "Open" from the context menu. On [imore](http://www.imore.com/how-open-apps-unidentified-developer-os-x-mountain-lion) you can find pictures how to do it and even a second way.


## Screenshot

![Screenshot](https://github.com/hashier/MacFolket/raw/master/images/svendict.jpg)


## Video

[![Video](http://img.youtube.com/vi/gWR_BvioaVw/0.jpg)](http://youtu.be/gWR_BvioaVw "This video shows the installation")


## Building

- Clone this git repository
- Download Apples [Dictionary Development Kit](https://developer.apple.com/downloads/) (The packages is called "Auxiliary Tools for Xcode")
- Copy the "Dictionary Development Kit" somewhere and adjust the Makefile accordingly
- make
- Optional make validate (you need to install jing for that)
- make install


## Caveats

- Only the first entry is displayed in pop-up mode instead of all (e.g. "boken" shows only "beech") but you will see all of them in dictionary.app.


## Thanks to

Philipp Brauner who build an English <-> German dictionary which I have used now for a couple of years. His plugin gave me the idea to build an English <-> Swedish one.
Here you can find his English <-> German one: http://lipflip.org/articles/dictcc-dictionary-plugin.

