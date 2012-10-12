#
# Makefile for creating a Swedish - English dictionary based on data acquired
# from folket lexikon http://folkets-lexikon.csc.kth.se/
#
#

###########################

DICT_NAME			=	"Swedish -> English dictionary"
DICT_SRC_PATH		=	MyDictionary.xml
CSS_PATH			=	MyDictionary.css
PLIST_PATH			=	MyInfo.plist

DICT_BUILD_OPTS		=
# Suppress adding supplementary key.
# DICT_BUILD_OPTS		=	-s 0	# Suppress adding supplementary key.

###########################

# The DICT_BUILD_TOOL_DIR value was used also in "build_dict.sh" script.
# So if you use an old version or modified version of "build_dict.sh" you might
# need to set it here.
# I just assume that build_dict.sh is in your $PATH

DICT_BUILD_TOOL_DIR	=	"/DevTools/Utilities/Dictionary Development Kit/"
DICT_BUILD_TOOL_BIN	=	"$(DICT_BUILD_TOOL_DIR)bin"
DICT_BUILD_TOOL_BIN	=	""

###########################

DICT_DEV_KIT_OBJ_DIR	=	./objects
export	DICT_DEV_KIT_OBJ_DIR

DESTINATION_FOLDER	=	~/Library/Dictionaries
RM					=	/bin/rm

###########################


all: fetch convert build
	echo -e "\n\nDone building the dictionary.\nTo install the dictionary run make install\n"

build:
	"$(DICT_BUILD_TOOL_BIN)build_dict.sh" $(DICT_BUILD_OPTS) $(DICT_NAME) $(DICT_SRC_PATH) $(CSS_PATH) $(PLIST_PATH)

install:
	echo "Installing into $(DESTINATION_FOLDER)".
	mkdir -p $(DESTINATION_FOLDER)
	ditto --noextattr --norsrc $(DICT_DEV_KIT_OBJ_DIR)/$(DICT_NAME).dictionary  $(DESTINATION_FOLDER)/$(DICT_NAME).dictionary
	touch $(DESTINATION_FOLDER)
	echo "Done."
	echo "To test the new dictionary, try Dictionary.app."

uninstall:
	$(RM) -rf $(DESTINATION_FOLDER)/$(DICT_NAME).dictionary
	touch $(DESTINATION_FOLDER)

clean:
	$(RM) -rf $(DICT_DEV_KIT_OBJ_DIR)

pristine: clean
	$(RM) -rf folket_en_sv_public.xml
	$(RM) -rf folket_sv_en_public.xml

fetch:
	sh get_files.sh

# for me to quickly test builds
reinstall: clean small build install

reinstallsmall: clean small build install

convert:
	xsltproc -o MyDictionary.xml folkets_sv_en_to_dic.xslt folkets_sv_en_public.xml

small:
	xsltproc -o MyDictionary.xml folkets_sv_en_to_dic.xslt small.xml

# http://www.thaiopensource.com/relaxng/jing.html
# http://code.google.com/p/jing-trang/downloads/list
# you MUST download and unzip the apple Dictionary Development Kit in the same folder as the make file
# AND 
# you MUST download and unzip jing here as well
validate:
	java -jar jing-20091111/bin/jing.jar Dictionary\ Development\ Kit/documents/DictionarySchema/AppleDictionarySchema.rng MyDictionary.xml

