#
# Makefile for creating a Swedish - English dictionary based on data acquired
# from folkets lexikon http://folkets-lexikon.csc.kth.se/
#
#

###########################

DICT_NAME			=	"Svensk-English"

DICT_SRC_PATH		=	MacFolket.xml
CSS_PATH			=	MacFolket.css
PLIST_PATH			=	MacFolket.plist

DICT_BUILD_OPTS		=
# Suppress adding supplementary key.
# DICT_BUILD_OPTS		=	-s 0	# Suppress adding supplementary key.

###########################

DICT_BUILD_TOOL_DIR	=	"./Dictionary Development Kit"

DICT_BUILD_TOOL_BIN	=	"$(DICT_BUILD_TOOL_DIR)/bin"

###########################

DICT_DEV_KIT_OBJ_DIR	=	./objects
export	DICT_DEV_KIT_OBJ_DIR

DESTINATION_FOLDER_USER 	=	~/Library/Dictionaries
DESTINATION_FOLDER_SYSTEM	=	/Library/Dictionaries
RM					=	/bin/rm
MV					=	/bin/mv

JING				=	tools/jing-20091111/bin/jing.jar

###########################

.PHONY: all fetch build install uninstall clean pristine convert_all reinstall reinstallsmall small devuninstall convert_all validate

all: fetch convert_all build
	@echo -e "\n\nDone building the dictionary.\nTo install the dictionary run make install\n"

fetch:
	@echo "Fetching needed files"
	sh get_files.sh

build:
	@echo "Building dictionary"
	"$(DICT_BUILD_TOOL_BIN)/build_dict.sh" $(DICT_BUILD_OPTS) $(DICT_NAME) $(DICT_SRC_PATH) $(CSS_PATH) $(PLIST_PATH)

install:
	@echo "Installing into $(DESTINATION_FOLDER_USER)".
	mkdir -p $(DESTINATION_FOLDER_USER)
	ditto --noextattr --norsrc $(DICT_DEV_KIT_OBJ_DIR)/$(DICT_NAME).dictionary  $(DESTINATION_FOLDER_USER)/$(DICT_NAME).dictionary
	touch $(DESTINATION_FOLDER_USER)
	@echo "Done."
	@echo "To test the new dictionary, try Dictionary.app."

uninstall:
	@echo "Uninstalling dictionary from system"
	$(RM) -rf $(DESTINATION_FOLDER_USER)/$(DICT_NAME).dictionary
	touch $(DESTINATION_FOLDER_USER)

clean:
	@echo "Clean up"
	$(RM) -rf $(DICT_DEV_KIT_OBJ_DIR)
	$(RM) -rf MacFolket.xml

pristine: clean
	@echo "Thoroughly clean up"
	$(RM) -rf folkets_en_sv_public.xml
	$(RM) -rf folkets_sv_en_public.xml

convert_all:
	@echo "Converting Folkets dictionary file into Apples DictionarySchema"
	@# WTF? In Makefiles you escape with $?
	sed '$$ d' folkets_sv_en_public.xml > start.xml
	tail -n +3 folkets_en_sv_public.xml > end.xml
	cat start.xml end.xml > all.xml
	$(RM) start.xml end.xml
	xsltproc -o MacFolket.xml MacFolket.xsl all.xml
	$(RM) all.xml
	sed 's/\&amp;/\&/g' MacFolket.xml > out.xml
	$(MV) out.xml MacFolket.xml

# for testing/development

reinstall: clean convert_all build install

reinstallsmall: clean small build install

small:
	@echo SMALL
	xsltproc -o MacFolket.xml MacFolket.xsl small.xml
	sed 's/\&amp;/\&/g' MacFolket.xml > out.xml
	$(MV) out.xml MacFolket.xml

devuninstall:
	@echo "DEVELOP Uninstalling dictionary from system and user"
	rm -rf $(DESTINATION_FOLDER_USER)/$(DICT_NAME).dictionary
	touch $(DESTINATION_FOLDER_USER)/
	sudo rm -rf $(DESTINATION_FOLDER_SYSTEM)/$(DICT_NAME).dictionary
	sudo touch $(DESTINATION_FOLDER_SYSTEM)/

# http://www.thaiopensource.com/relaxng/jing.html
# http://code.google.com/p/jing-trang/downloads/list
# you MUST download and unzip the apple Dictionary Development Kit in the same folder as the make file
# AND
# you MUST download and unzip jing here as well if you want to validate
validate:
	java -jar $(JING) $(DICT_BUILD_TOOL_DIR)/documents/DictionarySchema/AppleDictionarySchema.rng MacFolket.xml

# 3 places where the readme has to get fixed for new update
# 1. readme.rtf -> displayed in installer
# 2. MacFolket.xsl -> Back / Front matter
# 3. plist file -> showed in dictionary config pane

