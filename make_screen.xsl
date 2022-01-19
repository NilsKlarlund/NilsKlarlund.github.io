<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xlst [
  <!ENTITY spacer '&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;'>
  <!ENTITY import_general SYSTEM 'general.xsl'>
]>

  <xsl:stylesheet
		  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		  version="1.0"
		  >

    <xsl:output method='html' indent='yes'

		encoding="UTF-8" />
     
  
    <xsl:param name="homepath"/>

    <xsl:param name="previous"/>

    <xsl:param name="next"/>

    <xsl:param name="printable_version"/>

    <xsl:param name="ads"/>

    <!-- is either "no", "yes", or "only-headlines" -->	

    <xsl:variable name="ads_declared"
		  select="string(
		  (/html/body/tab/@ads |
		  /html/body/@ads)
                  [position()=last()])"/>
    <!-- is either "no", "yes", or "only-headlines" -->	


    <xsl:variable name="column_format"
	     select="string(
		  (/html/body/tab/@column_format |
	           /html/body/@column_format)
                  [position()=last()])"/>
    <!-- is either "" (default: two) or "one" or "two" -->

    <xsl:variable name="horizontal_contents"
	     select="string(
		  (/html/body/tab/@horizontal_contents |
	           /html/body/@horizontal_contents)
                  [position()=last()])"/>



    &import_general;

    <xsl:template match="html">
      <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en"
	    lang="en">
	<xsl:apply-templates select="*"/>
      </html>
    </xsl:template>

    <xsl:template match="related"/>

    <xsl:template match="printable"/>

    <xsl:template match="head/*">
      <xsl:if test="not (local-name(.)= 'related' or
	      local-name(.)='contents' or local-name(.)='ads')">
	<xsl:copy-of select="."/>
      </xsl:if>
    </xsl:template>

    <xsl:template match="body">
      <body>

	<xsl:choose>
	  <xsl:when test="$column_format='two' or $column_format=''"> 
	    <xsl:if test="$horizontal_contents='yes'">
	      <xsl:call-template name="horizontal_contents"/>
	    </xsl:if>
	    <table class="columntwo">
	      <tr>
		<!-- index and related column -->
		<td valign="top" class="firstcolumn">
		  <xsl:if test="count(/html/head/contents/*) > 1
			  and not($horizontal_contents='yes')">
		    <div class="contents" >
		    <h2>Contents</h2>
		    <ul>
		      <xsl:for-each select="/html/head/contents/*">
			<li>
			  <h3>
			    <xsl:copy-of select="."/>
			  </h3>
			</li>
		      </xsl:for-each>
		    </ul>
		  </div>
		  </xsl:if>
	          <xsl:if test="/html/head/ads/item | 
			  /html/body/tab/ads/item and (($ads = 'yes' and
			    (not($ads_declared='no')))
			  or $ads_declared='yes')">
		  <div class="ads">
		    <h2>Other stuff</h2>
		      <xsl:for-each select="/html/head/ads/item |
                            /html/body/tab/ads/item">
		      <h3><a href="{@href}"><xsl:value-of select="@title"/></a>
		      </h3>
			<div>
			  <xsl:apply-templates select="* |text()"/>
			  </div>
		      </xsl:for-each>
		  </div>
		  </xsl:if>

		  <xsl:if test="/html/head/ads/item |
	                 /html/body/tab/ads/item  and
			  ($ads = 'only-headlines' and
			    (not ($ads_declared='no')) 
                           or $ads_declared='only-headlines')" >
		  <div class="ads">
		    <h2>Other stuff</h2>
		
		      <xsl:for-each select="/html/head/ads/item |
                            /html/body/tab/ads/item">
		      <h3><a href="{@href}"><xsl:value-of select="@title"/></a>
		      </h3>
		      </xsl:for-each>
		    </div>
		  </xsl:if>
		  
		  <xsl:if test="/html/head/related/item">
		    <div class="related">
		      <h2>Related</h2>
		      <xsl:for-each select="/html/head/related/item">
			<h3><a href="{@href}"><xsl:value-of select="@title"/></a>
			</h3>
			<div>
			  <xsl:apply-templates select="* |text()"/>
			</div>
		      </xsl:for-each>
		    </div>
		  </xsl:if>
		  
		  <xsl:if test="/html/body/tab/related/item">
		    <div class="related">
		      <h2>Related
			<xsl:if test="/html/head/related/item">
			  (more)
			</xsl:if>
		      </h2>
		      <xsl:for-each
select="/html/body/tab/related/item">
			<h3><a href="{@href}"><xsl:value-of select="@title"/></a>
			</h3>
			<div>
			  <xsl:apply-templates select="* |text()"/>
			</div>
		      </xsl:for-each>
		    </div>
		  </xsl:if>
		</td>
		<!-- main content column -->
		<td valign="top" class="secondcolumn">
		  <xsl:for-each select="*|text()">
		    <xsl:if test="local-name(.)='tab'">
		      <h2 class="sectionheader">
			<xsl:choose>
			  <xsl:when test="title | @title">
			    <xsl:value-of select="title|@title"/>
			  </xsl:when>
			<xsl:otherwise><xsl:value-of select="@name"/>
			  </xsl:otherwise>
			</xsl:choose>
		      </h2>
		      <div/>
		      <xsl:apply-templates select='*|text()'/>
		    </xsl:if>
		    <xsl:apply-templates select='.'/>
		  </xsl:for-each>
		</td>
	      </tr>
	    </table>
	  </xsl:when>
	  <xsl:when test="$column_format='one'">
	    <xsl:for-each select="*|text()">
	      <xsl:if test="local-name(.)='tab'">
		<xsl:call-template name="horizontal_contents"/>
		<xsl:apply-templates select='*|text()'/>
	      </xsl:if>
	      <xsl:apply-templates select='.'/>
	    </xsl:for-each>
	  </xsl:when>
	  <xsl:otherwise>
	    ERROR column_format='<xsl:value-of select='$column_format'/>'
	  </xsl:otherwise>		    
	</xsl:choose>
	<div class="footer">
	  <hr/>
	  <br/>
	  <table width="100%">
	    <tr>
	      <td>
		<a href="{$printable_version}"><img align="top"
						    src="{$homepath}/photos/printsymbol.gif" alt="printer
						    symbol"/>printer-friendly version</a>
		<a href="{$homepath}"><img align="top"	
	            src="{$homepath}/photos/mailsymbol.gif" alt="mail
								symbol"/>e-mail Klarlund</a>

	      </td>
	      
	      <td class="prevnext" align="left">
		<xsl:choose>
		  <xsl:when test="$previous">
		    <a href="{$previous}" class="mylink">previous</a>
		  </xsl:when>
		  <xsl:otherwise>
		    <span class="inactive" style="width: 10ex;">previous</span>
		  </xsl:otherwise>
		</xsl:choose>
		<xsl:text>&spacer;</xsl:text>
		<xsl:choose>
		  <xsl:when test="$next">
		    <a href="{$next}" class="mylink">next</a>
		  </xsl:when>
		  <xsl:otherwise>
		    <span class="inactive" style="width:
			  10ex;">next</span>
		  </xsl:otherwise>
		</xsl:choose>
	      </td>

	      <td align="right">
		<a href="http://www.clairgrove.com">
		  <img align="top" 
		      
		       src="{$homepath}/photos/homesymbol.gif" alt="home symbol"/>Nils
		  Klarlund home</a>
	      </td>

	    </tr>
	  </table>
	  <br/>
	  <br/>
	  <hr/>
	  <xsl:call-template name="browser"/>
	</div>
      </body>
    </xsl:template>

    <xsl:template name="horizontal_contents">
      <div class="tabs">    
	<xsl:for-each select="/html/head/contents/*">
	  <xsl:copy-of select="."/>
	  <xsl:if test="not(position()=last())">
	    |
	  </xsl:if>
	</xsl:for-each>
      </div>
    </xsl:template>

  </xsl:stylesheet>


