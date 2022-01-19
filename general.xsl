<?xml version="1.0" encoding="UTF-8"?>

  <xsl:variable name="html-ns">http://www.w3.org/1999/xhtml</xsl:variable>
 
  <xsl:template match="/html/head">
   <head>
    <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
    <xsl:apply-templates/>
   </head>
  </xsl:template>

  <xsl:template name="author">
    <xsl:if test="/html/head/meta[@name='author']">
      <xsl:for-each select="/html/head/meta[@name='author']">
	By <xsl:value-of select="@content"/>.
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

<xsl:template name="copyright">
  <xsl:if test="/html/head/meta[@name='copyright']">
    <xsl:for-each select="/html/head/meta[@name='copyright']">
      Copyright  &#x00A9;<xsl:value-of select="@content"/>.
    </xsl:for-each>
  </xsl:if>
  <hr/>
</xsl:template>

<xsl:template name="browser">
  
  <table>
    <tr><td align="left" width="70%">	
	<xsl:call-template name="author"/> 
	<xsl:call-template name="copyright"/> 
	</td>
	<td align="right" width="30%" valign="top">
	  <a href="http://www.w3.org/Style/XSL" style="font-family:
	     sans-serif; font-size: 12pt; font-weight: bold; color:
	     black; text-decoration: none;">XSLT &amp;</a><a
	     href="http://www.python.org">
	    <img align="right" vspace="10"
		 src="{$homepath}/gifs/PythonPowered.gif" border="0" 
		 alt="PythonPowered"/>
	  </a>
	</td>
    </tr>
  </table>
</xsl:template>
  
<xsl:template match="quote">
  <table class="quotebox"> 
    <tr>
	<td/>
      <td class="quotebox">
	<blockquote><em>
	    <xsl:apply-templates/>
	  </em>
	</blockquote>
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:template match="quote/where">
  <div style="font-style: normal;"><xsl:apply-templates/>
  </div>
</xsl:template>

  <xsl:template match="*">
    <xsl:element name="{local-name(.)}" namespace="{$html-ns}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@* | processing-instruction()">
    <xsl:copy/>
  </xsl:template>
  
  <xsl:template match="tab/relation | tab/ads">
  </xsl:template>

  <xsl:template match="tab">
  </xsl:template>

  <xsl:template match="text()">	
    <xsl:call-template name="do-symbols">
      <xsl:with-param name="str" select="."/>
    </xsl:call-template>
  </xsl:template>  
  
  <xsl:template name="do-symbols">
    <xsl:param name="str"/>
    <xsl:choose>
      <xsl:when test="contains($str,'---')">
	<xsl:call-template name="do-symbols">
	  <xsl:with-param name="str"
			  select="concat(substring-before($str,
			                                  '---'), 
			                 '&#x2014;', 
			                  substring-after($str,
                                                          '---'))"/>
	</xsl:call-template>
      </xsl:when>

      <xsl:when test="contains($str,'``')">
	<xsl:call-template name="do-symbols">
	  <xsl:with-param name="str"
			  select="concat(substring-before($str,
			                                  '``'), 
			                 '&#x201C;', 
			                  substring-after($str,
                                                          '``'))"/>
	</xsl:call-template>
      </xsl:when>

      <xsl:when test='contains($str,"&apos;&apos;")'>
	<xsl:call-template name="do-symbols">
	  <xsl:with-param name="str"
			  select='concat(substring-before($str,
			                                  "&apos;&apos;"), 
			                  &quot;&#x201D;&quot;, 
			                  substring-after($str,
			                  "&apos;&apos;"))' />
	</xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
	<xsl:value-of select="$str"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
