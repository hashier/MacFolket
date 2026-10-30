<?xml version="1.0" encoding="UTF-8"?>
<!--
	Render-time XSL for MacFolket dictionary preferences.

	The Apple Dictionary engine applies this XSL to each entry at display time,
	injecting pref values as XSL parameters (keyed by the input name attributes
	in MacFolket_prefs.html). Spans with matching CSS classes are shown or hidden
	based on the current pref values.

	Default values here must match DCSDictionaryDefaultPrefs in MacFolket.plist.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:d="http://www.apple.com/DTDs/DictionaryService-1.0.rng"
				version="1.0">
<xsl:output method="xml" encoding="UTF-8" indent="no"
	doctype-public="-//W3C//DTD XHTML 1.1//EN"
	doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" />

<xsl:param name="show-synonyms"    select="'1'" />
<xsl:param name="show-inflections" select="'1'" />
<xsl:param name="show-examples"    select="'1'" />
<xsl:param name="show-compounds"   select="'1'" />
<xsl:param name="show-grammar"     select="'0'" />

<xsl:template match="span[@class='show-synonyms']">
	<xsl:if test="$show-synonyms = '1'">
		<xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
	</xsl:if>
</xsl:template>

<xsl:template match="span[@class='show-inflections']">
	<xsl:if test="$show-inflections = '1'">
		<xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
	</xsl:if>
</xsl:template>

<xsl:template match="span[@class='show-examples']">
	<xsl:if test="$show-examples = '1'">
		<xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
	</xsl:if>
</xsl:template>

<xsl:template match="span[@class='show-compounds']">
	<xsl:if test="$show-compounds = '1'">
		<xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
	</xsl:if>
</xsl:template>

<xsl:template match="span[@class='show-grammar']">
	<xsl:if test="$show-grammar = '1'">
		<xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
	</xsl:if>
</xsl:template>

<!-- Default: copy everything else through unchanged -->
<xsl:template match="@*|node()">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

</xsl:stylesheet>
