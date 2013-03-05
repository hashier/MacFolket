#
# Makefile for creating a Swedish - English dictionary based on data acquired
# from folket lexikon http://folkets-lexikon.csc.kth.se/
#
#

###########################

DICT_NAME			=	"Svensk-English dictionary"
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
MV					=	/bin/mv

JING				=	tools/jing-20091111/bin/jing.jar

###########################


all: fetch convert_all build
	@echo -e "\n\nDone building the dictionary.\nTo install the dictionary run make install\n"

fetch:
	@echo "Fetching needed files"
	sh get_files.sh

build:
	@echo "Building dictionary"
	"$(DICT_BUILD_TOOL_BIN)build_dict.sh" $(DICT_BUILD_OPTS) $(DICT_NAME) $(DICT_SRC_PATH) $(CSS_PATH) $(PLIST_PATH)

# install for current user
install:
	@echo "Installing into $(DESTINATION_FOLDER)".
	mkdir -p $(DESTINATION_FOLDER)
	ditto --noextattr --norsrc $(DICT_DEV_KIT_OBJ_DIR)/$(DICT_NAME).dictionary  $(DESTINATION_FOLDER)/$(DICT_NAME).dictionary
	touch $(DESTINATION_FOLDER)
	@echo "Done."
	@echo "To test the new dictionary, try Dictionary.app."

# uninstall for current user
uninstall:
	@echo "Uninstalling dictionary from system"
	$(RM) -rf $(DESTINATION_FOLDER)/$(DICT_NAME).dictionary
	touch $(DESTINATION_FOLDER)

clean:
	@echo "Clean up"
	$(RM) -rf $(DICT_DEV_KIT_OBJ_DIR)
	$(RM) -rf MyDictionary.xml

pristine: clean
	@echo "Thoroughly clean up"
	$(RM) -rf folkets_en_sv_public.xml
	$(RM) -rf folkets_sv_en_public.xml

convert_sven:
	@echo "Converting Folkets (SV -> EN) dictionary file into Apples DictionarySchema"
	xsltproc -o MyDictionary.xml transform.xsl folkets_sv_en_public.xml
	sed 's/amp;#/#/g' MyDictionary.xml > out.xml
	$(MV) out.xml MyDictionary.xml

convert_ensv:
	@echo "Converting Folkets (EN -> SV) dictionary file into Apples DictionarySchema"
	xsltproc -o MyDictionary.xml transform.xsl folkets_en_sv_public.xml
	sed 's/amp;#/#/g' MyDictionary.xml > out.xml
	$(MV) out.xml MyDictionary.xml

convert_all:
	@echo "Converting Folkets dictionary file into Apples DictionarySchema"
	@# WTF? In Makefiles you escape with $?
	sed '$$ d' folkets_sv_en_public.xml > start.xml
	tail -n +3 folkets_en_sv_public.xml > end.xml
	cat start.xml end.xml > all.xml
	$(RM) start.xml end.xml
	xsltproc -o MyDictionary.xml transform.xsl all.xml
	$(RM) all.xml
	sed 's/amp;#/#/g' MyDictionary.xml > out.xml
	$(MV) out.xml MyDictionary.xml


##
# Development stuff
##

# for testing/development
reinstall: clean convert_all build install

# for testing/development
reinstallsmall: clean small build install

# for testing/development
small:
	xsltproc -o MyDictionary.xml folkets_sv_en_to_dic.xsl small.xml
	sed 's/amp;#/#/g' MyDictionary.xml > out.xml
	$(MV) out.xml MyDictionary.xml

# http://www.thaiopensource.com/relaxng/jing.html
# http://code.google.com/p/jing-trang/downloads/list
# you MUST download and unzip the apple Dictionary Development Kit in the same folder as the make file
# AND
# you MUST download and unzip jing here as well
validate:
	java -jar $(JING) Dictionary\ Development\ Kit/documents/DictionarySchema/AppleDictionarySchema.rng MyDictionary.xml

