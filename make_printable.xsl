<?xml version="1.0"?>
<!DOCTYPE xlst [
  <!ENTITY spacer '&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;'>
  <!ENTITY import_general SYSTEM 'general.xsl'>
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.0">

  <xsl:output method='xml' indent='yes'
	      doctype-public = "-//W3C//DTD XHTML 1.0 Transitional//EN"
	      doctype-system = "DTD/xhtml1-transitional.dtd"
	      encoding="UTF-8" />

  <xsl:param name="homepath"/>	

  &import_general;	

  <xsl:template match="html">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en"
	  lang="en">
      <xsl:apply-templates select="*"/>
    </html>
  </xsl:template>

  <xsl:template match="body">
    <xsl:apply-templates select="node() | processing-instruction()"/>
    <hr/>
    <xsl:call-template name="browser"/>
  </xsl:template>

  <xsl:template match="related|ads">
  </xsl:template>

  <xsl:template match="h1[printable]">
    <h1>	
      <xsl:apply-templates select="printable/node()|printable/@*"/>
    </h1>
  </xsl:template>

  <xsl:template match="h2[printable]">
    <h2>	
      <xsl:apply-templates select="printable/node()|printable/@*"/>
    </h2>
  </xsl:template>

  <xsl:template match="h3[printable]">
    <h3>	
      <xsl:apply-templates select="printable/node()|printable/@*"/>
    </h3>
  </xsl:template>

  <xsl:template match="h4[printable]|printable/@*">
    <h4>	
      <xsl:apply-templates select="printable/node()|printable/@*"/>
    </h4>
  </xsl:template>

  <xsl:template match="printable"/>

  <xsl:template match="tabs">
    <xsl:apply-templates select="tab"/>
  </xsl:template>

  <xsl:template match="tab">
    <h2>
      <xsl:choose>
	<xsl:when test="title">
          <xsl:copy-of select="title/node()"/>	
	</xsl:when>	
	<xsl:when test="@title">
	  <xsl:value-of select="@title"/>
	</xsl:when>
	<xsl:when test="@name">
	  <xsl:value-of select="@name"/>
	</xsl:when>
      </xsl:choose>
    </h2>
    <xsl:apply-templates select="*|text()"/>
  </xsl:template>

  <xsl:template match="tab/title"/>

</xsl:stylesheet>







