<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- <xsl:output method="xml" encoding="utf-8" indent="yes || no"/> -->
	<xsl:output method="xml" encoding="utf-8"/>

	<xsl:template match="/">

		<d:dictionary xmlns="http://www.w3.org/1999/xhtml" xmlns:d="http://www.apple.com/DTDs/DictionaryService-1.0.rng">

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

					<!-- id should be unique -> running number -->
					<!-- Never figured out what this d:title is actually for -->
					<xsl:attribute name="id">id_<xsl:number value="position()"/></xsl:attribute>
					<xsl:attribute name="d:title"><xsl:value-of select="@value"/></xsl:attribute>


<xsl:text>
	</xsl:text>
					<!-- Make sure that the actual word has an index entry -->
					<d:index d:value="{@value}"></d:index>

					<!-- Add all inflections to the search index so we will be able to find bil even so we search for bilen -->
					<xsl:for-each select="paradigm/inflection">
<xsl:text>
	</xsl:text>
						<d:index d:value="{@value}"></d:index>
					</xsl:for-each>

					<!-- Add all the translations to the search index as well -->

					<!-- Yeah! Sure! The syntax sucks -->
					<!-- 
					test <- Attribute
					cs   <- Element 
					-->
					<!-- <xsl:for-each select="catalog/cd[artist/@test='a']"> -->
					<xsl:for-each select="translation[@value!='']">
<xsl:text>
	</xsl:text>
						<d:index d:value="{@value}"></d:index>
					</xsl:for-each>


<xsl:text>
	</xsl:text>
					<!-- Heading -->
					<h1><xsl:value-of select="@value"/></h1>

					<!-- Comment -->
					<xsl:if test="@comment">
						<span>Comment: <xsl:value-of select="@comment"/></span><br/>
					</xsl:if>

					<!-- Phonetic -->
					<xsl:if test="phonetic/@value">
						<xsl:for-each select="phonetic">
							<span>Uttal: |<xsl:value-of select="@value"/>|</span><br/>
						</xsl:for-each>
					</xsl:if>

					<!-- What kind of word is it (word class) -->
					<xsl:if test="@class">
						<span>
							<xsl:choose>
								<xsl:when test="@class = 'nn'">Word class: substantiv</xsl:when>
								<xsl:when test="@class = 'jj'">Word class: adjektiv</xsl:when>
								<xsl:when test="@class = 'vb'">Word class: adverb</xsl:when>
								<xsl:when test="@class = 'in'">Word class: interjektion</xsl:when>
								<xsl:when test="@class = 'pp'">Word class: preposition</xsl:when>
								<xsl:when test="@class = 'pn'">Word class: pronomen</xsl:when>
								<xsl:when test="@class = 'abbrev'">Word class: förkortning</xsl:when>
								<xsl:when test="@class = 'ab'">Word class: adverb</xsl:when>
								<xsl:otherwise>Word class: DEBUG: <xsl:value-of select="@class"/></xsl:otherwise>
							</xsl:choose>
						</span><br/>
					</xsl:if>

					<!-- All synonyms -->
					<xsl:if test="synonym/@value">
						<span d:priority="2">Synonymer: <xsl:for-each select="synonym"><xsl:value-of select="@value"/>, </xsl:for-each><br/></span>
					</xsl:if>

					<!-- All inflections -->
					<xsl:if test="paradigm/inflection/@value">
						<span>Böjningar: <xsl:for-each select="paradigm/inflection"><xsl:value-of select="@value"/>, </xsl:for-each><br/></span>
					</xsl:if>

					<!-- Definitions -->
					<xsl:if test="definition/@value">
						<xsl:for-each select="definition">
							<span>Definition: <xsl:value-of select="@value"/></span>
							<xsl:if test="translation/@value">
								<span> (<xsl:value-of select="translation/@value"/>)</span>
							</xsl:if>
							<br/>
						</xsl:for-each>
					</xsl:if>

					<!-- Examples -->
					<xsl:if test="example/@value">
						<xsl:for-each select="example">
							<span>Example: <xsl:value-of select="@value"/></span>
							<xsl:if test="translation/@value">
								<span> (<xsl:value-of select="translation/@value"/>)</span>
							</xsl:if>
							<br/>
						</xsl:for-each>
					</xsl:if>

					<!-- Idioms -->
					<xsl:if test="idiom/@value">
						<xsl:for-each select="idiom">
							<span d:priority="2">Idiom: <xsl:value-of select="@value"/>
							<xsl:if test="translation/@value"> (<xsl:value-of select="translation/@value"/>)</xsl:if>
							<br/></span>
						</xsl:for-each>
					</xsl:if>

					<!-- Derivations -->
					<xsl:if test="derivation/@value">
						<xsl:for-each select="derivation">
							<span d:priority="2">Avledningar: <xsl:value-of select="@value"/>
							<xsl:if test="translation/@value"> (<xsl:value-of select="translation/@value"/>)</xsl:if>
							<br/></span>
						</xsl:for-each>
					</xsl:if>

					<!-- Compounds -->
					<xsl:if test="compound/@value">
						<xsl:for-each select="compound">
							<span d:priority="2">Sammansättningar: <xsl:value-of select="@value"/>
							<xsl:if test="translation/@value"> (<xsl:value-of select="translation/@value"/>)</xsl:if>
							<br/></span>
						</xsl:for-each>
					</xsl:if>

					<!-- Förklaring -->
					<xsl:if test="explanation/@value">
						<xsl:for-each select="explanation">
							<span d:priority="2">Förklaring: <xsl:value-of select="@value"/>
							<xsl:if test="translation/@value"> (<xsl:value-of select="translation/@value"/>)</xsl:if>
							<br/></span>
						</xsl:for-each>
					</xsl:if>

					<!-- Not really working yet because there are a lot of '&' inside here -->
					<!-- Grammar -->
					<!-- <xsl:if test="grammar/@value">
						<xsl:for-each select="grammar">
							<span d:priority="2">Grammatikkommentar: <xsl:value-of select="@value"/>
							<xsl:if test="translation/@value"> (<xsl:value-of select="translation/@value"/>)</xsl:if>
							<br/></span>
						</xsl:for-each>
					</xsl:if> -->

					<!-- These are actually the real stuff -->
					<!-- All translations here -->
					<xsl:if test="translation/@value">
						<ol>
							<xsl:for-each select="translation">
								<li>
									<xsl:value-of select="@value"/><xsl:if test="@comment"> [<xsl:value-of select="@comment"/>]</xsl:if>
								</li>
							</xsl:for-each>
						</ol>
					</xsl:if>

<!-- 
					<span class="footer"><a href="http://folkets-lexikon.csc.kth.se/folkets/#lookup&amp;XXXX&amp;0">lookup online</a> | <a href="x-dictionary:r:front_back_matter">About</a></span>
 -->

				</d:entry>
<xsl:text>
</xsl:text>
			</xsl:for-each>


			<!-- FOOTER -->
			<d:entry id="front_back_matter" d:title="Front/Back Matter">
				<h1><b>Swedish -> English</b></h1>
				<p>
					Dictionary from Swedish to English with a dataset from <a href="http://folkets-lexikon.csc.kth.se/folkets/">Folkets lexikon</a>. Sourcecode from <a href="http://loessl.org">Christopher Loessl</a>
				</p>
				<div>
					<b>Usage</b>
						<ul>
							<li>Double tab a word with 3 fingers on your track-pad</li>
							<li>Select a word and press cmd-ctrl-d</li>
							<li>Use the dictionary application</li>
							<li>...</li>
						</ul>
					<b>License</b>
					<p>
						The People's dictionary is free. Both the whole <a href="folkets_en_sv_public.xml">English-Swedish dictionary</a> and the <a href="folkets_sv_en_public.xml">Swedish-English dictionary</a> can be downloaded for use under the <a href="http://creativecommons.org/licenses/by-sa/2.5/">Distributed Creative Commons Attribution-Share Alike 2.5 Generic license</a>.
					</p>
					<p>
						The source to create this dictionary can be found <a href="https://github.com/hashier/macfolket">here</a>.
					</p>
					<p>
						Christopher Loessl homepage can be found <a href="http://loessl.org">here</a>.
					</p>
				</div>
			</d:entry>
<xsl:text>
</xsl:text>
			<!-- END OF FOOTER -->

		</d:dictionary>

	</xsl:template>

</xsl:stylesheet>
