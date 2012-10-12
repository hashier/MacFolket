<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<xsl:template match="/">

		<xsl:for-each select="dictionary/word">

			<xsl:text disable-output-escaping="yes">&lt;d:entry id="id_</xsl:text>
			<xsl:number value="position()"/>
			<xsl:text disable-output-escaping="yes">" d:title="</xsl:text>
			<xsl:value-of select="@value"/>
			
			<xsl:text disable-output-escaping="yes">"&gt;
	&lt;d:index d:value="</xsl:text>
			<xsl:value-of select="@value"/>
			<xsl:text disable-output-escaping="yes">"/&gt;
</xsl:text>
			
			<xsl:for-each select="paradigm/inflection">
				<xsl:text disable-output-escaping="yes">	&lt;d:index d:value="</xsl:text>
				<xsl:value-of select="@value"/>
				<xsl:text disable-output-escaping="yes">"/&gt;
</xsl:text>
			</xsl:for-each>
			<xsl:text disable-output-escaping="yes">	&lt;h1&gt;</xsl:text>
			<xsl:value-of select="@value"/>
			<xsl:text disable-output-escaping="yes">&lt;/h1&gt;
	&lt;ol&gt;
</xsl:text>
			<xsl:for-each select="translation">
			<xsl:text disable-output-escaping="yes">		&lt;li&gt;
				</xsl:text>
			<xsl:value-of select="@value"/>
			<xsl:text disable-output-escaping="yes">
		&lt;/li&gt;
</xsl:text>
			</xsl:for-each>
			<xsl:text disable-output-escaping="yes">	&lt;/ol&gt;
&lt;/d:entry&gt;
</xsl:text>



<!-- 
	<div d:priority="2"><h1>make</h1></div>
	<div>
		<ol>
			<li>
				Form by putting parts together or combining substances; construct; create; produce 
				<span d:priority="2"> : <i>Mother made her a beautiful dress</i>
				</span>
				.
			</li>
			<li>
				Cause to be or become
				<span d:priority="2"> : <i>The news made me happy</i>
				</span>
				.
			</li>
		</ol>
	</div>
	<div d:priority="2">
		<h3>PHRASES</h3>
		<div id="make_it"><b>make it</b> : succeed in something; survive.</div>
		<h4><a href="x-dictionary:r:make_up_ones_mind"><b>make up one's mind</b></a></h4>
	</div>
</d:entry>
 -->
		</xsl:for-each>


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



<d:entry id="make_1" d:title="make">
	<d:index d:value="make"/>
	<d:index d:value="makes"/>
	<d:index d:value="made" d:title="made (make)"/>
	<d:index d:value="making" d:priority="2"/>
	<d:index d:value="make it" d:anchor="xpointer(//*[@id='make_it'])"/>
	<div d:priority="2"><h1>make</h1></div>
	<div>
		<ol>
			<li>
				Form by putting parts together or combining substances; construct; create; produce 
				<span d:priority="2"> : <i>Mother made her a beautiful dress</i>
				</span>
				.
			</li>
			<li>
				Cause to be or become
				<span d:priority="2"> : <i>The news made me happy</i>
				</span>
				.
			</li>
		</ol>
	</div>
	<div d:priority="2">
		<h3>PHRASES</h3>
		<div id="make_it"><b>make it</b> : succeed in something; survive.</div>
		<h4><a href="x-dictionary:r:make_up_ones_mind"><b>make up one's mind</b></a></h4>
	</div>
</d:entry>


<d:entry id="midi" d:value"midi">
    <d:index d:value="MIDI" d:title="MIDI"/>
    <h1>MIDI</h1>
    <p>Musical Instrument Digital Interface</p>
</d:entry>


-->
