# MacFolket

A Swedish–English dictionary for macOS, integrated into Dictionary.app and system-wide look-up.

## Installation

The dictionary can live in one of two places:

| Location | Scope | Requires admin |
|----------|-------|----------------|
| `~/Library/Dictionaries` | Current user only | No |
| `/Library/Dictionaries` | All users on the Mac | Yes |

### Homebrew (recommended)

```sh
brew tap hashier/macfolket
brew install --cask macfolket
```

Installs to `~/Library/Dictionaries` (current user). Updatable via `brew upgrade`.

### Installer package

Download the latest `.pkg` from the [Releases](https://github.com/hashier/MacFolket/releases) page and open it.

> **Note:** The pkg installer places the dictionary in `/Library/Dictionaries` (system-wide, all users, requires root). If you only need it for yourself, use Homebrew or the manual zip instead.

If macOS blocks the installer because it's from an unidentified developer, right-click (or Ctrl-click) the `.pkg` file and choose **Open** from the context menu.

### Manual (zip)

Download the `.zip` from the [Releases](https://github.com/hashier/MacFolket/releases) page, unzip it, and copy the `Svensk-English.dictionary` bundle into either location above.

### After installing

Open **Dictionary.app** → **Settings** (Cmd+,) and enable the **Svensk-English** dictionary.

## Usage

- Three-finger tap on a word on your trackpad
- Select a word and press Cmd+Ctrl+D
- Open Dictionary.app and search directly

## Screenshot

![Screenshot](https://github.com/hashier/MacFolket/raw/master/images/svendict.jpg)

## Video

[![Video](https://img.youtube.com/vi/gWR_BvioaVw/0.jpg)](https://youtu.be/gWR_BvioaVw "This video shows the installation")

## Building from source

```sh
git clone https://github.com/hashier/MacFolket.git
cd MacFolket
make            # fetches dictionary data, converts, and builds
make install    # copies to ~/Library/Dictionaries
```

Other useful targets:

| Target | Description |
|--------|-------------|
| `make pkg` | Build a `.pkg` installer (requires Xcode CLI tools) |
| `make zip` | Build a `.zip` archive of the dictionary bundle |
| `make release` | Clean build, create pkg + zip, push a GitHub release, and update the Homebrew tap |
| `make validate` | Validate the XML against Apple's schema (requires [jing](https://relaxng.org/jclark/jing.html)) |
| `make clean` | Remove build artifacts |
| `make pristine` | Remove build artifacts and downloaded dictionary data |

## Caveats

- Only the first entry is displayed in pop-up mode instead of all (e.g. "boken" shows only "beech") but you will see all of them in dictionary.app.

## Thanks to

Philipp Brauner who build an English <-> German dictionary which I have used now for a couple of years. His plugin gave me the idea to build an English <-> Swedish one.
You can find his English <-> German one [here](https://lipflip.org/articles/dictcc-dictionary-plugin).
