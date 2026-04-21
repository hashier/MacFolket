<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- <xsl:output method="xml" encoding="utf-8" indent="yes || no"/> -->
	<xsl:output method="xml" encoding="utf-8"/>

	<xsl:param name="version" select="'1.3'"/>
	<xsl:param name="buildDate" select="'2017-04-09'"/>

	<!-- Maps a single class code to its Swedish label -->
	<xsl:template name="class-code">
		<xsl:param name="code"/>
		<xsl:choose>
			<xsl:when test="$code = 'ab'">adverb</xsl:when>
			<xsl:when test="$code = 'abbrev'">förkortning</xsl:when>
			<xsl:when test="$code = 'article'">artikel</xsl:when>
			<xsl:when test="$code = 'hjälpverb'">hjälpverb</xsl:when>
			<xsl:when test="$code = 'hp'">fråge-/relativpronomen</xsl:when>
			<xsl:when test="$code = 'ie'">infinitivmärke</xsl:when>
			<xsl:when test="$code = 'in'">interjektion</xsl:when>
			<xsl:when test="$code = 'jj'">adjektiv</xsl:when>
			<xsl:when test="$code = 'kn'">konjunktion</xsl:when>
			<xsl:when test="$code = 'latin'">latin</xsl:when>
			<xsl:when test="$code = 'nn'">substantiv</xsl:when>
			<xsl:when test="$code = 'pc'">particip</xsl:when>
			<xsl:when test="$code = 'pm'">egennamn</xsl:when>
			<xsl:when test="$code = 'pn'">pronomen</xsl:when>
			<xsl:when test="$code = 'pp'">preposition</xsl:when>
			<xsl:when test="$code = 'prefix'">prefix</xsl:when>
			<xsl:when test="$code = 'ps'">possessivt pronomen</xsl:when>
			<xsl:when test="$code = 'rg'">grundtal</xsl:when>
			<xsl:when test="$code = 'ro'">ordningstal</xsl:when>
			<xsl:when test="$code = 'sn'">subjunktion</xsl:when>
			<xsl:when test="$code = 'suffix'">suffix</xsl:when>
			<xsl:when test="$code = 'vb'">verb</xsl:when>
			<xsl:otherwise><xsl:value-of select="$code"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Renders a comma-separated list of class codes, e.g. "ab, jj" → "adverb, adjektiv" -->
	<xsl:template name="class-list">
		<xsl:param name="text"/>
		<xsl:variable name="first" select="substring-before(concat($text, ', '), ', ')"/>
		<xsl:variable name="rest" select="substring-after($text, ', ')"/>
		<xsl:call-template name="class-code">
			<xsl:with-param name="code" select="$first"/>
		</xsl:call-template>
		<xsl:if test="$rest != ''">
			<xsl:text>, </xsl:text>
			<xsl:call-template name="class-list">
				<xsl:with-param name="text" select="$rest"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="/">

		<d:dictionary xmlns="http://www.w3.org/1999/xhtml" xmlns:d="http://www.apple.com/DTDs/DictionaryService-1.0.rng">
<xsl:text>
</xsl:text>

<!-- Documentation -->
<!--
https://developer.apple.com/library/mac/documentation/UserExperience/Conceptual/DictionaryServicesProgGuide/Introduction/Introduction.html
-->

			<!-- HEADER -->
<!--
			<d:entry id="dictionary_application" d:title="Dictionary application">
				<d:index d:value="Dictionary application"/>
				<h1>Dictionary application </h1>
				<p>
					An application to look up dictionary on Mac OS X.<br/>
				</p>
				<span class="column">
					The Dictionary application first appeared in Tiger.
				</span>
				<span class="picture">
					It's application icon looks like below.<br/>
					<img src="Images/_internal_dictionary.png" alt="Dictionary.app Icon"/>
				</span>
			</d:entry>
<xsl:text>
</xsl:text>
 -->
			<!-- END OF HEADER -->


			<xsl:for-each select="dictionary/word">

				<d:entry>

					<!-- Needed META DATA information -->
					<!-- id should be unique -> running number -->
					<!-- Never figured out what this d:title is actually for -->
					<xsl:attribute name="id">id_<xsl:number value="position()"/></xsl:attribute>
					<xsl:attribute name="d:title"><xsl:value-of select="@value"/></xsl:attribute>

<xsl:text>
	</xsl:text>
					<!-- Make sure that the actual word has an index entry -->
					<xsl:if test="string-length(@value) &lt; 64">
						<d:index d:value="{@value}"></d:index>
					</xsl:if>

					<!-- Add all inflections to the search index so we will be able to find bil even so we search for bilen -->
					<xsl:for-each select="paradigm/inflection">
<xsl:text>
	</xsl:text>
						<xsl:if test="string-length(@value) &lt; 64">
							<d:index d:value="{@value}"></d:index>
						</xsl:if>
					</xsl:for-each>

					<!-- Add all the translations to the search index as well -->
					<xsl:for-each select="translation[@value!='']">
<xsl:text>
	</xsl:text>
						<xsl:if test="string-length(@value) &lt; 64">
							<d:index d:value="{@value}"></d:index>
						</xsl:if>
					</xsl:for-each>

					<!-- Add variants to the search index -->
					<xsl:for-each select="variant[@value!='']">
<xsl:text>
	</xsl:text>
						<xsl:if test="string-length(@value) &lt; 64">
							<d:index d:value="{@value}"></d:index>
						</xsl:if>
					</xsl:for-each>

<xsl:text>
	</xsl:text>
					<!-- Headword (with optional usage comment inline, e.g. "härav (formellt)") -->
					<h1><xsl:value-of select="@value"/><xsl:if test="@comment"> <span class="word-comment">(<xsl:value-of select="@comment"/>)</span></xsl:if></h1>

					<!-- Translations (primary content) -->
					<xsl:if test="translation/@value">
						<ol>
							<xsl:for-each select="translation">
								<li><xsl:value-of select="@value"/><xsl:if test="@comment"> [<xsl:value-of select="@comment"/>]</xsl:if></li>
							</xsl:for-each>
						</ol>
					</xsl:if>

					<!--
						Secondary fields use two patterns depending on structure:

						COLLECTED — multiple values joined on one line, no translation children:
							<xsl:if test="el/@value">
								<span d:priority="2">Label: <xsl:for-each select="el"><xsl:value-of select="@value"/><xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each><br/></span>
							</xsl:if>

						PER-ITEM — one span per occurrence, optional translation child:
							<xsl:for-each select="el">
								<span d:priority="2">Label: <xsl:value-of select="@value"/><xsl:if test="translation/@value"> (<xsl:value-of select="translation/@value"/>)</xsl:if><br/></span>
							</xsl:for-each>

						definition and example are primary (no d:priority="2") and always per-item.
					-->

					<!-- COLLECTED -->

					<!-- Pronunciation -->
					<xsl:if test="phonetic/@value">
						<span d:priority="2">Pronunciation: <xsl:for-each select="phonetic">|<xsl:value-of select="@value"/>|<xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each><br/></span>
					</xsl:if>

					<!-- Word class (word-level attribute, may be comma-separated e.g. "ab, jj") -->
					<xsl:if test="@class != ''">
						<span d:priority="2">Word class: <xsl:call-template name="class-list">
							<xsl:with-param name="text" select="@class"/>
						</xsl:call-template><br/></span>
					</xsl:if>

					<!-- Synonyms -->
					<xsl:if test="synonym/@value">
						<span d:priority="2">Synonyms: <xsl:for-each select="synonym"><xsl:value-of select="@value"/><xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each><br/></span>
					</xsl:if>

					<!-- Inflections -->
					<xsl:if test="paradigm/inflection/@value">
						<span d:priority="2">Inflections: <xsl:for-each select="paradigm/inflection"><xsl:value-of select="@value"/><xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each><br/></span>
					</xsl:if>

					<!-- Grammar -->
					<xsl:if test="grammar/@value">
						<span d:priority="2">Grammar: <xsl:for-each select="grammar"><xsl:value-of select="@value"/><xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each><br/></span>
					</xsl:if>

					<!-- Use -->
					<xsl:if test="use/@value">
						<span d:priority="2">Use: <xsl:for-each select="use"><xsl:value-of select="@value"/><xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each><br/></span>
					</xsl:if>

					<!-- Variants (alternative spellings) -->
					<xsl:if test="variant/@value">
						<span d:priority="2">Variant: <xsl:for-each select="variant"><xsl:value-of select="@value"/><xsl:if test="not(position()=last())">, </xsl:if></xsl:for-each><br/></span>
					</xsl:if>

					<!-- PER-ITEM (primary — no d:priority) -->

					<!-- Definitions -->
					<xsl:for-each select="definition">
						<span>Definition: <xsl:value-of select="@value"/><xsl:if test="translation/@value"> (<xsl:value-of select="translation/@value"/>)</xsl:if><br/></span>
					</xsl:for-each>

					<!-- Examples -->
					<xsl:for-each select="example">
						<span>Example: <xsl:value-of select="@value"/><xsl:if test="translation/@value"> (<xsl:value-of select="translation/@value"/>)</xsl:if><br/></span>
					</xsl:for-each>

					<!-- PER-ITEM (secondary — d:priority="2") -->

					<!-- Idioms -->
					<xsl:for-each select="idiom">
						<span d:priority="2">Idiom: <xsl:value-of select="@value"/><xsl:if test="translation/@value"> (<xsl:value-of select="translation/@value"/>)</xsl:if><br/></span>
					</xsl:for-each>

					<!-- Derivations -->
					<xsl:for-each select="derivation">
						<span d:priority="2">Derivation: <xsl:value-of select="@value"/><xsl:if test="translation/@value"> (<xsl:value-of select="translation/@value"/>)</xsl:if><br/></span>
					</xsl:for-each>

					<!-- Compounds -->
					<xsl:for-each select="compound">
						<span d:priority="2">Compound: <xsl:value-of select="@value"/><xsl:if test="translation/@value"> (<xsl:value-of select="translation/@value"/>)</xsl:if><br/></span>
					</xsl:for-each>

					<!-- Explanations -->
					<xsl:for-each select="explanation">
						<span d:priority="2">Explanation: <xsl:value-of select="@value"/><xsl:if test="translation/@value"> (<xsl:value-of select="translation/@value"/>)</xsl:if><br/></span>
					</xsl:for-each>

					<!-- See also / Compare — skip saldo, animation, phonetic (internal/dead references) -->
					<xsl:for-each select="see[@type='also' or @type='compare' or not(@type)]">
						<span d:priority="2"><xsl:choose><xsl:when test="@type='compare'">Compare: </xsl:when><xsl:otherwise>See also: </xsl:otherwise></xsl:choose><xsl:value-of select="@value"/><br/></span>
					</xsl:for-each>

					<!-- Antonyms -->
					<xsl:for-each select="related">
						<span d:priority="2">Antonym: <xsl:value-of select="@value"/><xsl:if test="translation/@value"> (<xsl:value-of select="translation/@value"/>)</xsl:if><br/></span>
					</xsl:for-each>

<!--
					<span class="footer"><a href="http://folkets-lexikon.csc.kth.se/folkets/#lookup&amp;XXXX&amp;0">lookup online</a> | <a href="x-dictionary:r:front_back_matter">About</a></span>
 -->
<xsl:text>
</xsl:text>
				</d:entry>
<xsl:text>
</xsl:text>
			</xsl:for-each>

			<!-- FOOTER -->
			<d:entry id="front_back_matter" d:title="Front/Back Matter">
				<h1><b>Svensk &lt;-&gt; English</b></h1>
				<p>
					Dictionary from Swedish to English and English to Swedish. With the dataset from <a href="http://folkets-lexikon.csc.kth.se/folkets/">Folkets lexikon</a>. Written by <a href="http://loessl.org">Christopher Loessl</a>
				</p>
				<p>
				<b>Usage:</b>
					<ul>
						<li>Force-click (deep press) a word on the trackpad</li>
						<li>Select a word and press ⌃⌘D (Control+Command+D)</li>
						<li>Open Dictionary.app and search directly</li>
					</ul>
				</p>
				<p>
					<b>MacFolket Version: <xsl:value-of select="$version"/></b><br/>
					Build on: <xsl:value-of select="$buildDate"/>
				</p>
				<p>
					<b>License:</b><br/>
					The People's dictionary is free. Both the whole <a href="folkets_en_sv_public.xml">English-Swedish dictionary</a> and the <a href="folkets_sv_en_public.xml">Swedish-English dictionary</a> can be downloaded for use under the <a href="http://creativecommons.org/licenses/by-sa/2.5/">Distributed Creative Commons Attribution-Share Alike 2.5 Generic license</a>.
				</p>
				<p>
					The source code to build this dictionary can be found <a href="http://hashier.github.com/MacFolket/">here</a>.
				</p>
				<p>
					Christopher Loessl's homepage can be found under <a href="http://loessl.org">http://loessl.org</a>.
				</p>
<xsl:text>
</xsl:text>
			</d:entry>
<xsl:text>
</xsl:text>
			<!-- END OF FOOTER -->

		</d:dictionary>

	</xsl:template>

</xsl:stylesheet>
