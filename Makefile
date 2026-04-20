#
# Makefile for creating a Swedish - English dictionary based on data acquired
# from folkets lexikon http://folkets-lexikon.csc.kth.se/
#

DICT_NAME        = Svensk-English

# Single source of truth for version — flows to xsl and plist at build time
VERSION          = 2026.1
BUILD_DATE       = $(shell date +%Y-%m-%d)
PKG_NAME         = MacFolket-$(VERSION).pkg
ZIP_NAME         = MacFolket-$(VERSION).zip

DICT_SRC_PATH    = MacFolket.xml
CSS_PATH         = MacFolket.css
PLIST_PATH       = MacFolket.plist

DICT_BUILD_TOOL_DIR = "./Dictionary Development Kit"
DICT_BUILD_TOOL_BIN = "$(DICT_BUILD_TOOL_DIR)/bin"

DICT_DEV_KIT_OBJ_DIR = ./objects
export DICT_DEV_KIT_OBJ_DIR
DICT_BUNDLE          = $(DICT_DEV_KIT_OBJ_DIR)/$(DICT_NAME).dictionary

DESTINATION_FOLDER_USER   = ~/Library/Dictionaries
DESTINATION_FOLDER_SYSTEM = /Library/Dictionaries

JING = tools/jing-20091111/bin/jing.jar

# Post-process xsltproc output to fix ampersand encoding
define fix_ampersands
	sed 's/\&amp;/\&/g' MacFolket.xml > out.xml
	sed 's/\&\([, ]\)/\&amp;\1/g' out.xml > MacFolket.xml
	rm -f out.xml
endef

.PHONY: all fetch build plist release install uninstall clean pristine convert_all reinstall reinstallsmall small devuninstall validate test-cask

all: fetch convert_all build
	@printf "\n\nDone building the dictionary.\nTo install the dictionary run make install\n\n"

fetch:
	@echo "Fetching needed files"
	sh get_files.sh

build: plist
	@echo "Building dictionary"
	"$(DICT_BUILD_TOOL_BIN)/build_dict.sh" $(DICT_NAME) $(DICT_SRC_PATH) $(CSS_PATH) $(PLIST_PATH)

plist:
	@echo "Updating plist version to $(VERSION)"
	sed -i '' '/<key>CFBundleShortVersionString<\/key>/{n;s/<string>[^<]*<\/string>/<string>$(VERSION)<\/string>/;}' $(PLIST_PATH)
	sed -i '' 's/MacFolket Version: [0-9.]*</MacFolket Version: $(VERSION)</' $(PLIST_PATH)
	sed -i '' 's/Build on: [0-9-]*<\//Build on: $(BUILD_DATE)<\//' $(PLIST_PATH)

pkg: $(DICT_BUNDLE)
	@echo "Building installer package $(PKG_NAME)"
	pkgbuild --component $(DICT_BUNDLE) \
		--install-location $(DESTINATION_FOLDER_SYSTEM) \
		--identifier org.loessl.dictionary.sven \
		--version $(VERSION) \
		$(PKG_NAME)
	@echo "Created $(PKG_NAME)"

zip: $(DICT_BUNDLE)
	@echo "Building zip archive $(ZIP_NAME)"
	cd $(DICT_DEV_KIT_OBJ_DIR) && zip -r ../$(ZIP_NAME) $(DICT_NAME).dictionary
	@echo "Created $(ZIP_NAME)"

release:
	$(MAKE) clean
	$(MAKE) pkg
	$(MAKE) zip
	@echo "Creating GitHub release v$(VERSION)"
	gh release create v$(VERSION) $(PKG_NAME) $(ZIP_NAME) \
		--title "MacFolket $(VERSION)" \
		--notes "Swedish-English dictionary for macOS Dictionary.app"
	@echo "Updating Homebrew tap"
	@ZIP_SHA=$$(shasum -a 256 $(ZIP_NAME) | cut -d' ' -f1) && \
		TMPDIR=$$(mktemp -d) && \
		cd "$$TMPDIR" && \
		gh repo clone hashier/homebrew-tap -- --depth 1 && \
		cd homebrew-tap && \
		sed -i '' "s/version \"[^\"]*\"/version \"$(VERSION)\"/" Casks/macfolket.rb && \
		sed -i '' "s/sha256 \"[^\"]*\"/sha256 \"$$ZIP_SHA\"/" Casks/macfolket.rb && \
		git add Casks/macfolket.rb && \
		git commit -m "Update MacFolket to $(VERSION)" && \
		git push && \
		rm -rf "$$TMPDIR"
	@echo "Release v$(VERSION) complete"

install: $(DICT_BUNDLE)
	@echo "Installing into $(DESTINATION_FOLDER_USER)"
	mkdir -p $(DESTINATION_FOLDER_USER)
	ditto --noextattr --norsrc $(DICT_BUNDLE) $(DESTINATION_FOLDER_USER)/$(DICT_NAME).dictionary
	touch $(DESTINATION_FOLDER_USER)
	@echo "Done. To test the new dictionary, try Dictionary.app."

uninstall:
	@echo "Uninstalling dictionary"
	rm -rf $(DESTINATION_FOLDER_USER)/$(DICT_NAME).dictionary
	touch $(DESTINATION_FOLDER_USER)

clean:
	@echo "Clean up"
	rm -rf $(DICT_DEV_KIT_OBJ_DIR) MacFolket.xml all.xml out.xml start.xml end.xml *.pkg *.zip

pristine: clean
	@echo "Thoroughly clean up"
	rm -rf folkets_en_sv_public.xml folkets_sv_en_public.xml

convert_all:
	@echo "Converting Folkets dictionary file into Apple DictionarySchema"
	sed '$$ d' folkets_sv_en_public.xml > start.xml
	tail -n +3 folkets_en_sv_public.xml > end.xml
	cat start.xml end.xml > all.xml
	rm -f start.xml end.xml
	xsltproc --stringparam version "$(VERSION)" --stringparam buildDate "$(BUILD_DATE)" -o MacFolket.xml MacFolket.xsl all.xml
	$(fix_ampersands)

# Development targets

reinstall: clean convert_all build install

reinstallsmall: clean small build install

small:
	@echo "Building with small.xml (development)"
	xsltproc --stringparam version "$(VERSION)" --stringparam buildDate "$(BUILD_DATE)" -o MacFolket.xml MacFolket.xsl small.xml
	$(fix_ampersands)

devuninstall:
	@echo "Uninstalling dictionary from system and user"
	rm -rf $(DESTINATION_FOLDER_USER)/$(DICT_NAME).dictionary
	touch $(DESTINATION_FOLDER_USER)/
	sudo rm -rf $(DESTINATION_FOLDER_SYSTEM)/$(DICT_NAME).dictionary
	sudo touch $(DESTINATION_FOLDER_SYSTEM)/

validate:
	java -jar $(JING) $(DICT_BUILD_TOOL_DIR)/documents/DictionarySchema/AppleDictionarySchema.rng MacFolket.xml

CASK_FILE = /opt/homebrew/Library/Taps/hashier/homebrew-tap/Casks/macfolket.rb

test-cask: zip
	@echo "Installing cask from local zip"
	@test -f $(CASK_FILE) || brew tap hashier/macfolket
	@ZIP_SHA=$$(shasum -a 256 $(ZIP_NAME) | cut -d' ' -f1) && \
		sed -i '' "s|url .*|url \"file://$(CURDIR)/$(ZIP_NAME)\"|" $(CASK_FILE) && \
		sed -i '' "s/version \"[^\"]*\"/version \"$(VERSION)\"/" $(CASK_FILE) && \
		sed -i '' "s/sha256 \"[^\"]*\"/sha256 \"$$ZIP_SHA\"/" $(CASK_FILE)
	brew install --cask macfolket
	@echo "Resetting tap"
	cd $(dir $(CASK_FILE)) && git checkout .
	@echo "Done — dictionary should be in ~/Library/Dictionaries"
