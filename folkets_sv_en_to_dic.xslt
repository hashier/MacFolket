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

					<xsl:attribute name="id">id_<xsl:number value="position()"/></xsl:attribute>
					<xsl:attribute name="d:title"><xsl:value-of select="@value"/></xsl:attribute>

<xsl:text>
	</xsl:text>
					<d:index d:value="{@value}"></d:index>

					<xsl:for-each select="paradigm/inflection">

<xsl:text>
	</xsl:text>
						<d:index d:value="{@value}"></d:index>

					</xsl:for-each>
<xsl:text>
	</xsl:text>
					<h1><xsl:value-of select="@value"/></h1>
					<xsl:if test="phonetic/@value">
						<span>Uttal: |<xsl:value-of select="phonetic/@value"/>|</span><br/>
					</xsl:if>
					<xsl:if test="@class">
						<span>
							<xsl:choose>
								<xsl:when test="@class = 'nn'">Word class: substantiv</xsl:when>
								<xsl:when test="@class = 'jj'">Word class: adjektiv</xsl:when>
								<xsl:when test="@class = 'vb'">Word class: adverb</xsl:when>
								<xsl:when test="@class = 'in'">Word class: interjektion</xsl:when>
								<xsl:when test="@class = 'pp'">Word class: preposition</xsl:when>
								<xsl:otherwise>Word class: not tracked yet</xsl:otherwise>
							</xsl:choose>
						</span><br/>
					</xsl:if>
					<xsl:if test="paradigm/inflection/@value">
						<span>Böjningar: <xsl:for-each select="paradigm/inflection"><xsl:value-of select="@value"/>, </xsl:for-each></span><br/>
					</xsl:if>
					<xsl:if test="definition/@value">
						<span>Definition: <xsl:value-of select="definition/@value"/></span><br/>
					</xsl:if>
					<xsl:if test="translation/@value">
						<ol>
							<xsl:for-each select="translation">
								<li>
									<xsl:value-of select="@value"/>
								</li>
							</xsl:for-each>
						</ol>
					</xsl:if>
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
				</div>
			</d:entry>
<xsl:text>
</xsl:text>
			<!-- END OF FOOTER -->

		</d:dictionary>

	</xsl:template>

</xsl:stylesheet>

<!-- 
<word value="slott" lang="sv" class="nn">
	<translation value="manor house" />
	<translation value="castle" />
	<translation value="palace" />
	<phonetic value="slåt:" soundFile="slott.swf" />
	<paradigm>
		<inflection value="slottet" />
		<inflection value="slott" />
		<inflection value="slotten" />
	</paradigm>

	<synonym value="palats" level="4.3" />
	<see value="slott||slott..1||slott..nn.1" type="saldo" />

	<compound value="slotts|byggnad">
		<translation value="palace building" />
	</compound>

	<definition value="pampigt bostadshus för kungliga eller adliga personer" />
</word>

 -->
