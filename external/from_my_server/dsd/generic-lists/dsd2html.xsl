<?xml version="1.0"?> 

<!-- 

This XSLT 1.0 style sheet pretty-prints a DSD through a rather
involved transformation to HTML/CSS formatting objects.  Tested with
IBM/Lotus Java-based XSLT processor, but should work with any
conforming processor.  Output should make sense to Netscape 4,
Mozilla, and IE 5.  BriefDoc is rendered as a "title" attribute, which
is not handled by Netscape 4 and handled erroneously in IE 5.
Doc elements are ignored.  

Author: Nils Klarlund, AT&T Labs-Research, 1999.

-->

<!DOCTYPE xsl:stylesheet [ 

<!ENTITY br '<xsl:text  disable-output-escaping="yes">&lt;br&gt;</xsl:text>' >
<!ENTITY hr '<xsl:text  disable-output-escaping="yes">&lt;hr&gt;</xsl:text>' >

<!ENTITY user 'font-family: Arial, Helvetica, Sans-serif; font-style:normal;
	  font-weight:normal; color: black;'>

<!ENTITY space '<xsl:text> </xsl:text>'>
<!ENTITY spacing '.8ex'>

<!ENTITY  block-indentation-level '2.7'>
<!ENTITY  block-indentation-level-less-one-spaces '&space;' >

<!ENTITY  block-indentation ' font-family: Courier; font-weight:bold;
  margin-left: &block-indentation-level;ex;
                text-indent: -&block-indentation-level;ex; ' >

<!ENTITY  block-indentation-extra-minus-one ' font-family: Courier; font-weight:bold;
  margin-left: {&block-indentation-level; * ($extra-indent-level)}ex;  text-indent: -&block-indentation-level;ex; ' >

<!ENTITY  block-indentation-extra ' font-family: Courier; font-weight:bold;
  margin-left: {&block-indentation-level; * ($extra-indent-level + 1)}ex;  text-indent: -&block-indentation-level;ex; ' >

<!ENTITY deep-expression '
  */*[not(self::Label or self::BriefDoc or self::Doc)][(not(parent::Context or parent::ZeroOrMore 
           or parent::OneOrMore or parent::Optional)
       and not(self::String or AnyChar))
      or 
        *[not(self::Label or self::BriefDoc or self::Doc)][not(self::String or AnyChar)]] 
  or descendant::AttributeDecl 
  or (not(ancestor-or-self::Context) and descendant-or-self::Element)' >

<!ENTITY stringtypeexp-elements '
    (Sequence |
    Optional | 
    ZeroOrMore |
    OneOrMore | 
    Union | 
    Intersection | 
    Complement | 
    Empty |
    String |
    CharSet |
    CharRange |
    AnyChar |
    StringType)'>

]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/XSL/Transform/1.0">

 
  <xsl:output method="html" indent="no" encoding="UTF-8"/> 
  <xsl:strip-space elements="*"/>

  <xsl:preserve-space elements="DefaultContent/*"/>

  <xsl:key name="IDkey" match="*[@ID or @RenewID]" use="@ID | @RenewID"/>

  <!-- ROOT TEMPLATE -->

  <xsl:template match="/DSD">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
        <meta http-equiv="Expires" content="0"/>
    	<title><xsl:value-of select="Title"></xsl:value-of></title>
        <style type="text/css">
	  div {margin-bottom:0em; margin-top:0em; margin-left:0em;
	       font-weight:bold; font-family:  Courier; }
	  span {color: black;}
	  div.rootchild {margin-bottom:2ex; margin-top:&spacing;; 
              border-style: solid; border-width: 2px;  border-color:pink; }
	  .key, .special-key {font-weight:bold; color: purple;}
	  .doc {font-family: Arial, Helvetica, Sans-serif; font-style:normal; font-weight: normal; color: brown;}
	  .user {&user;}
	  .user-bold {&user; font-weight:bold;}
	  .user:link {&user;}
	  .user:visited {&user;}
	  .concrete, .string {font-family: Courier; color: blue; font-weight:bold; }
	  .tt {font-family: Courier; color: blue; font-weight:bold; }
	  .comment {font-family: Arial, Helvetica, Sans-serif; font-style:normal;
	  font-weight:normal; color: brown;}
	  h1.header {font-size:18pt;  color: purple; font-family: Arial, Helvetica, Sans-serif;}
	  body {font-size:10pt; background-color:beige;}
	</style>
      </head>
 
      <body>

	<h1 class="header">
	  <xsl:value-of select="Title"/> 
	  <div style="font-weight:bold; font-size:14pt">
            <xsl:if test="@IDRef">Root Element: 
	      <span style="font-size:12pt;">
		<xsl:call-template name="render-ref"/>
		&br;
	      </span>
	    </xsl:if> 
	    DSD version: 
	    <span style="font-size:12pt;">
	      <xsl:value-of select="@DSDVersion"/>
	    </span>
	  </div>
	</h1>
	<table style="border-width:0pt;">
	  <xsl:apply-templates select="(Title|Author|Version)" mode="header"/>
	</table>
        &hr;
	&br;

	<xsl:for-each select="node()">
	  <xsl:choose>
	    <xsl:when test="self::*">
	      <xsl:if test="self::Doc">
		<xsl:apply-templates select="."/>
	      </xsl:if>
	      <xsl:if test="not(self::Label or self::BriefDoc or self::Doc 
		      or self::Author or self::Title or self::Version)">
		<div style="margin-bottom:2ex; margin-top:&spacing;;
		     border-style: solid; border-width: 2px;  border-color:pink;">
		  <xsl:call-template name="do-doc"/>
		  <div style="&block-indentation;">
		    <xsl:apply-templates select="."/>
		  </div>
		</div>
	      </xsl:if>
	    </xsl:when>
	    <xsl:when test="self::processing-instruction()">
	      <xsl:apply-templates select="."/>
	    </xsl:when>
	    <xsl:when test="self::comment()">
	      <xsl:apply-templates select="."/>
	    </xsl:when>
	  </xsl:choose>
	</xsl:for-each>  
      </body> 
    </html> 
  </xsl:template>
  
  <xsl:template match="DSD//processing-instruction()">
    <DIV class="user" STYLE="margin-bottom:&spacing;;"><span class="user">&lt;?<xsl:value-of select="name(.)"/>
	<span>&space;</span>
	<xsl:choose>   
	  <xsl:when test="starts-with(., 'URI=&quot;')">
	    <xsl:variable name="uri" select="substring-before(substring-after(., 'URI=&quot;'), '&quot;')"/>
	    <a href="{substring-before($uri,'.dsd')}.html">"<xsl:value-of select="$uri"/>"</a>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="."/>
	  </xsl:otherwise>
	</xsl:choose>
	?&gt;</span></DIV>
  </xsl:template>
  
  <xsl:template match="DSD//comment()">
    <DIV class="comment" style="margin-top:&spacing;; margin-bottom:&spacing;">
      <SPAN>&lt;!--</SPAN>
	    <SPAN><xsl:value-of select="."/></SPAN><SPAN> </SPAN><SPAN>--&gt;</SPAN></DIV>
  </xsl:template>

  <xsl:template match="Doc"> 
    <div class="doc"><xsl:copy-of select="node()"/></div>
  </xsl:template>

  <!-- TITLE, AUTHOR AND VERSION -->

  <xsl:template match="Title|Author|Version" mode="header">
    <tr>
      <th align="left">		
	<span class="special-key" style="width:8em;height:1.5ex;"><xsl:value-of select="local-name(.)"/>:</span>
      </th>
      <td>
	<span class="user;" style="font-weight:bold;height:1.5ex;">
	  <xsl:value-of select="."/> 
	</span>
      </td>
    </tr>
  </xsl:template>

  <!-- DOCUMENTATION -->

  <xsl:template name="do-doc">
    <xsl:variable name="preceding-BriefDoc" select="
		  preceding-sibling::*[1][self::BriefDoc] |
		  preceding-sibling::*[1][self::Doc] / 
		  preceding-sibling::*[1][self::BriefDoc]"/>
    <xsl:if test="$preceding-BriefDoc">
      <xsl:attribute name="title">
	<xsl:value-of select="$preceding-BriefDoc"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:variable name="preceding-label" select="
		  preceding-sibling::*[1][self::Label] |
		  preceding-sibling::*[1][self::BriefDoc or self::Doc] / 
		  preceding-sibling::*[1][self::Label] |
		  preceding-sibling::*[1][self::Doc] / 
		  preceding-sibling::*[1][self::BriefDoc] / 
		  preceding-sibling::*[1][self::Label] "/>
    <xsl:if test="$preceding-label">
      <span style="float:right;">
	<span class="key">[</span>
	<span style="font-weight:bold;" class="user">
	  <xsl:value-of select="$preceding-label"/>
	</span>
	<span class="key">]</span>
      </span>
    </xsl:if>
  </xsl:template>

  <!-- STRUCTURAL DEFINITIONS  -->
  

  <xsl:template name="render-attribute">
    <span class="tt"><xsl:value-of select="@Name"/></span>
    <xsl:variable name="stringtypeexp-children" 
		  select="&stringtypeexp-elements;"/>
    <xsl:choose>	
      <xsl:when test="$stringtypeexp-children or @Value">
	<span>=</span>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="@Value">
      <span>"<xsl:value-of select="@Value"/>"</span>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="Default">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-normal">
      <xsl:with-param name="left-parentheses" select="''"/>
      <xsl:with-param name="right-parentheses" select="'}'"/>
      <xsl:with-param name="trailing">
	<xsl:copy-of select="$trailing"/>
      </xsl:with-param>
      <xsl:with-param name="header">
	<span class="key"><xsl:value-of select="local-name(.)"/>
	    &space;
	</span> 
	<xsl:for-each select="*[not(self::Label or self::BriefDoc or self::Doc)][1]">
	  <xsl:call-template name="do-Boolean">
	    <xsl:with-param name="extra-indent-level" select="0"/>
	    <xsl:with-param name="trailing">
	      <span> {</span>
	    </xsl:with-param>
	  </xsl:call-template>
	  <xsl:param name="element-name-or-stuff-on-line-already" select="true()"/>
	</xsl:for-each>
      </xsl:with-param>
      <xsl:with-param name="footer"/>
      <xsl:with-param name="separator" select="';'"/>
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="true"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="Context[parent::Default] | Or[parent::Default] | And[parent::Default]| Not[parent::Default] | OneOf[parent::Default] | Equiv[parent::Default]">
  </xsl:template>

  <xsl:template match="Context[not(parent::Default)]" name="do-Boolean">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:choose>
      <xsl:when test="self::Context">
	<xsl:call-template name="recurse-normal">
	  <xsl:with-param name="left-parentheses" select="''"/>
	  <xsl:with-param name="right-parentheses" select="''"/>
	  <xsl:with-param name="header"/>
      <xsl:with-param name="separator" select="''"/>
	  <xsl:with-param name="do-not-single-child-inline" select="false()"/> 
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="self::Or">
	<xsl:call-template name="recurse-normal">
	  <xsl:with-param name="left-parentheses" select="''"/>
	  <xsl:with-param name="right-parentheses" select="''"/>
	  <xsl:with-param name="header"/>
	  <xsl:with-param name="separator" select="','"/>
	  <xsl:with-param name="do-not-single-child-inline" select="false()"/> 
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="true()">
	<xsl:apply-templates select="."/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  

  <xsl:template match="DefaultAttribute">
    <xsl:param name="trailing"/>	
    <xsl:call-template name="recurse-normal">
	 
      <xsl:with-param name="header">   
	<span class="concrete"><xsl:value-of select="@Name"/></span>
	<span>:"</span>
	<span class="concrete"><xsl:value-of select="@Value"/>"</span>
      </xsl:with-param>
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="DefaultContent">
   <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:choose>
      <xsl:when test="* | text()">
	<xsl:call-template name="recurse-normal">
	  <xsl:with-param name="left-parentheses" select="''"/>
	  <xsl:with-param name="right-parentheses" select="''"/>
	  <xsl:with-param name="header"/>
	  <xsl:with-param name="footer"/>
	  <xsl:with-param name="separator" select="''"/>
	  <xsl:with-param name="do-not-single-child-inline" select="false()"/> 
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="false()"/>
	</xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="DefaultContent//*/@*">
    <span class="concrete">&space;<xsl:value-of select="local-name(.)"/>="<xsl:value-of select="."/>"</span>
  </xsl:template>


  <xsl:template match="DefaultContent//*"> 

    <!-- <xsl:template match="DefaultContent//*/* | DefaultContent/* "> -->
   
    <!-- ERROR: should be equivalent to ... -->
    <!-- <xsl:template match="DefaultContent//*">, but is not  -->
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:choose>
      <xsl:when test="* | text()">
	<xsl:call-template name="recurse-normal">
	  <xsl:with-param name="left-parentheses" select="''"/>
	  <xsl:with-param name="right-parentheses" select="''"/>
	  <xsl:with-param name="header">
	    <span class="concrete">&lt;<xsl:value-of select="local-name(.)"/><xsl:apply-templates select="@*"/>></span>
	  </xsl:with-param>
	  <xsl:with-param name="footer">
	    <span class="concrete">&lt;/<xsl:value-of select="local-name(.)"/>&gt;</span>
	  </xsl:with-param>
	  <xsl:with-param name="separator" select="''"/>
	  <xsl:with-param name="do-not-single-child-inline" select="true()"/> 
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing">
	    <xsl:copy-of select="$trailing"/>
	  </xsl:with-param>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="false()"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="recurse-normal">
	  <xsl:with-param name="left-parentheses" select="''"/>
	  <xsl:with-param name="right-parentheses" select="''"/>
	  <xsl:with-param name="header">
	    <span class="concrete">&lt;<xsl:value-of select="local-name(.)"/><xsl:apply-templates select="@*"/>/></span>
	  </xsl:with-param>
	  <xsl:with-param name="footer">
	  </xsl:with-param>
	  <xsl:with-param name="separator" select="';'"/>
	  <xsl:with-param name="do-not-single-child-inline" select="true()"/> 
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing">
	    <xsl:copy-of select="$trailing"/>
	  </xsl:with-param>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" 
			  select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  

  <xsl:template match="PointsTo">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-normal">
      <xsl:with-param name="left-parentheses" select="''"/>
      <xsl:with-param name="right-parentheses" select="''"/>
      <xsl:with-param name="separator" select="''"/>
      <xsl:with-param name="do-not-single-child-inline" select="false()"/> 
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="DefaultContent//text()">	
    <xsl:param name="trailing"/>
    <span class="concrete"><xsl:value-of select="."/></span>
    <xsl:copy-of select="$trailing"/>
  </xsl:template>

  <xsl:template match="ElementDef">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-normal">
      <xsl:with-param name="left-parentheses" select="''"/>
      <xsl:with-param name="right-parentheses" select="''"/>
      <xsl:with-param name="header">
	<xsl:call-template name="render-start-tag"/><span>&space;</span>
	<!--	<span class="key"><xsl:value-of select="local-name(.)"/>&space;</span> -->
	<xsl:call-template name="render-def"/>
	  <xsl:if test="@Defaultable ='yes' or @Defaultable ='Yes'">
	  <span class="key">[<span class="special-key">Defaultable</span>]</span>
	</xsl:if>
	<span>:&space;</span>
      </xsl:with-param>
      <xsl:with-param name="footer">
	<xsl:call-template name="render-end-tag"/>
      </xsl:with-param>
      <xsl:with-param name="separator" select="';'"/>
      <xsl:with-param name="do-not-single-child-inline" select="true()"/> 
      <xsl:with-param name="do-not-inline" select="true()"/> 
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="ConstraintDef | ContentDef | BoolDef | ContextDef | StringTypeDef">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-normal">
      <xsl:with-param name="left-parentheses" select="''"/>
      <xsl:with-param name="right-parentheses" select="''"/>
      <xsl:with-param name="header">
	<span class="key"><xsl:value-of select="local-name(.)"/> &space;</span>
	<xsl:call-template name="render-def"/>
	<span>:&space;</span>
      </xsl:with-param>
      <xsl:with-param name="footer"/>
      <xsl:with-param name="separator" select="';'"/>
      <xsl:with-param name="do-not-single-child-inline" select="true()"/> 
      <xsl:with-param name="do-not-inline" select="true()"/> 
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="AttributeDeclDef">
    <span class="key"><xsl:value-of select="local-name(.)"/> </span>
    <xsl:call-template name="render-def"/>
    <div style="&block-indentation;"> 
      <xsl:call-template name="attributedecl"/>
    </div>  
  </xsl:template>

  <xsl:template match="Context//Element">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    
    <xsl:param name="header">
      <span class="tt"><xsl:call-template name="render-element-name"/></span>
      <xsl:if test="@IDRef">
	<span class="key">[IDRef:</span>
	<xsl:call-template name="render-ref"/>
	<span class="key">]</span>
      </xsl:if>
      <xsl:choose>
	<xsl:when test="following-sibling::*[1][self::Element]">
	  <span> ></span>
	</xsl:when>
      </xsl:choose>
    </xsl:param>
     
    <xsl:choose>
      <xsl:when test="*">
	<xsl:call-template name="recurse-normal">
	  <xsl:with-param name="left-parentheses" select="'['"/>
	  <xsl:with-param name="right-parentheses" select="']'"/>
	  <xsl:with-param name="header">
	    <xsl:copy-of select="$header"/>
	  </xsl:with-param>
	  <xsl:with-param name="separator" select="';'"/>
	  <xsl:with-param name="do-not-single-child-inline" select="false()"/> 
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="not(*)">
	<xsl:call-template name="recurse-normal">
	  <xsl:with-param name="left-parentheses" select="''"/>
	  <xsl:with-param name="right-parentheses" select="''"/>
	  <xsl:with-param name="header">
	    <xsl:copy-of select="$header"/>
	  </xsl:with-param>
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="Context//SomeElements">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-normal">
      <xsl:with-param name="header">
	<xsl:choose>	      
	  <xsl:when test="not(following-sibling::*) 
		    and preceding-sibling::Element">
		<span>*</span>
	      </xsl:when>
	</xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="Element">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:choose>
      <xsl:when test="*">
	<xsl:call-template name="recurse-normal">
	  <xsl:with-param name="left-parentheses" select="''"/>
	  <xsl:with-param name="right-parentheses" select="''"/>
	  <xsl:with-param name="header">
	    <xsl:call-template name="render-start-tag"/>
	    <xsl:call-template name="render-ref"/>
	  </xsl:with-param>
	  <xsl:with-param name="footer">
	    <xsl:call-template name="render-end-tag"/>
	    <xsl:if test="@Defaultable ='yes' or @Defaultable ='Yes'">
	      <span class="key">[<span class="special-key">Defaultable</span>]</span>
	    </xsl:if>
	  </xsl:with-param>
	  <xsl:with-param name="separator" select="';'"/>
	  <xsl:with-param name="do-not-single-child-inline" select="true()"/> 
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="not(*) and (@IDRef or @CurrIDRef)">
	<xsl:call-template name="recurse-normal">
	  <xsl:with-param name="left-parentheses" select="''"/>
	  <xsl:with-param name="right-parentheses" select="''"/>
	  <xsl:with-param name="header">
	    <span class="key">Element </span>
	    <xsl:call-template name="render-ref"/>
	  </xsl:with-param>
	  <xsl:with-param name="footer">
	    <xsl:call-template name="render-end-tag"/>
	    <xsl:if test="@Defaultable ='yes' or @Defaultable ='Yes'">
	      <span class="key">[<span class="special-key">Defaultable</span>]</span>
	    </xsl:if>
	  </xsl:with-param>
	  <xsl:with-param name="separator" select="';'"/>
	  <xsl:with-param name="do-not-single-child-inline" select="true()"/> 
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="not(*) and not(@IDRef or @CurrIDRef)">
		<xsl:call-template name="recurse-normal">
	  <xsl:with-param name="left-parentheses" select="''"/>
	  <xsl:with-param name="right-parentheses" select="''"/>
	  <xsl:with-param name="header">
	    <xsl:call-template name="render-empty-tag"/>
	    <xsl:call-template name="render-ref"/> 
	    <xsl:if test="@Defaultable ='yes' or @Defaultable ='Yes'">
	      <span class="key">[<span class="special-key">Defaultable</span>]</span>
	    </xsl:if>
	  </xsl:with-param>
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

 <xsl:template match="If">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-normal">
      <xsl:with-param name="left-parentheses" select="''"/>
      <xsl:with-param name="right-parentheses" select="''"/>
      <xsl:with-param name="header">
	<span class="key">If </span>
      </xsl:with-param>
      <xsl:with-param name="footer"/>
      <xsl:with-param name="separator" select="''"/>
      <xsl:with-param name="first-child-inline" select="true()"/>
      <xsl:with-param name="do-not-single-child-inline" select="true()"/> 
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>


 <xsl:template match="Not[count(*[not(self::Label or self::BriefDoc or self::Doc)])=1]">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-normal">
      <xsl:with-param name="left-parentheses" select="''"/>
      <xsl:with-param name="right-parentheses" select="''"/>
      <xsl:with-param name="do-not-single-child-inline" select="false()"/> 
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>

 <xsl:template match="Not[count(*[not(self::Label or self::BriefDoc or self::Doc)])>1] | OneOf | Equiv">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-normal">
      <xsl:with-param name="separator" select="','"/>
      <xsl:with-param name="do-not-single-child-inline" select="false()"/> 
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="And | Or">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="parenthesized-infix">
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
      <xsl:with-param name="operator" select=" local-name(.)"/>
    </xsl:call-template>
  </xsl:template>


 <xsl:template match="Attribute">
   <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-normal">
      <xsl:with-param name="left-parentheses" select="''"/>
      <xsl:with-param name="right-parentheses" select="''"/>
      <xsl:with-param name="header">
	<xsl:if test="not(ancestor::Context)">
	  <span class="key"><xsl:value-of select="local-name(.)"/>
	  </span> 
	  <span>&space;</span>
	</xsl:if>
	<xsl:call-template name="render-attribute"/>
      </xsl:with-param>
      <xsl:with-param name="footer"/>
      <xsl:with-param name="separator" select="';'"/>
      <xsl:with-param name="do-not-single-child-inline" select="true()"/> 
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>

  
  <xsl:template match="AttributeDecl" name="attributedecl">

    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    
    <xsl:variable name="optionality">
      <xsl:choose>
	<xsl:when test="@Optional='yes' or @Optional='Yes'">
	  <span class="key">[<span class="special-key">Optional</span>]</span>
	</xsl:when>
	<xsl:otherwise>
	  <span class="key">[<span class="special-key">Required</span>]</span>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="@IDRef or @CurrIDRef">
	<xsl:call-template name="recurse-normal">
	  <xsl:with-param name="left-parentheses" select="''"/>
	  <xsl:with-param name="right-parentheses" select="''"/>
	  <xsl:with-param name="header">
	    <span class="key">AttributeDecl </span>
	    <xsl:call-template name="render-ref"/>
	  </xsl:with-param>
	  <xsl:with-param name="footer"/>
	  <xsl:with-param name="do-not-single-child-inline" select="true()"/> 
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="&stringtypeexp-elements;">
	<xsl:call-template name="recurse-normal">
	  <xsl:with-param name="left-parentheses">
	    <span class="concrete">"</span>
	  </xsl:with-param>
	  <xsl:with-param name="right-parentheses">
	    <span class="concrete">"</span>
	  </xsl:with-param>
	  <xsl:with-param name="header">
	    <span class="concrete"><xsl:value-of select="@Name"/>=</span>
	  </xsl:with-param>
	  <xsl:with-param name="footer"/>
	  <xsl:with-param name="stuff-after-first-child">
	    <span>&space;</span>
	    <xsl:copy-of select="$optionality"/>
	  </xsl:with-param>
	  <xsl:with-param name="separator" select="''"/>
	  <xsl:with-param name="do-not-single-child-inline" select="false()"/> 
	  <xsl:with-param name="first-child-inline" select="true()"/> 
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="PointsTo">
	<!--there is no string type, but a PointsTo child -->
	<xsl:call-template name="recurse-normal">
	  <xsl:with-param name="left-parentheses" select="''"/>
	  <xsl:with-param name="right-parentheses" select="''"/>
	  <xsl:with-param name="header">
	    <span class="concrete"><xsl:value-of select="@Name"/>=</span>
	    <span>?</span>
	    <span>&space;</span>
	    <xsl:copy-of select="$optionality"/><span>&space;</span>
	  </xsl:with-param>
	  <xsl:with-param name="footer"/>
	  <xsl:with-param name="separator" select="''"/>
	  <xsl:with-param name="do-not-single-child-inline" select="false()"/> 
	  <xsl:with-param name="first-child-inline" select="true()"/> 
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<!--there are no children at all -->
	<xsl:call-template name="recurse-normal">
	  <xsl:with-param name="left-parentheses" select="''"/>
	  <xsl:with-param name="right-parentheses" select="''"/>
	  <xsl:with-param name="header">	
	    <span class="concrete"><xsl:value-of select="@Name"/></span>
	    <span>=?</span>
	    <span>&space;</span>
	    <xsl:copy-of select="$optionality"/>
	  </xsl:with-param>
	  <xsl:with-param name="footer"/>
	  <xsl:with-param name="separator" select="''"/>
	  <xsl:with-param name="do-not-single-child-inline" select="false()"/> 
	  <xsl:with-param name="first-child-inline" select="true()"/> 
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>	

  <xsl:template match="String">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-normal">
      <xsl:with-param name="header">
	<xsl:choose> 
	  <xsl:when test="parent::AttributeDecl">
	    <span class="concrete"><xsl:value-of select="@Value"/></span>
	  </xsl:when>
	  <xsl:when test="ancestor::AttributeDecl">
	    <span>'</span>
	    <span class="concrete"><xsl:value-of select="@Value"/></span>
	    <span>'</span>
	  </xsl:when>
	  <xsl:when test="not(ancestor::AttributeDecl)">
	    <span>"</span>
	    <span class="tt"><xsl:value-of select="@Value"/></span>
	    <span>"</span>
	  </xsl:when>	
	</xsl:choose>	
      </xsl:with-param>
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="CharRange">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-normal">
      <xsl:with-param name="header">
	<span>[</span><span class="string"><xsl:value-of select="@Start"/></span>
	<span>-</span><span class="string"><xsl:value-of select="@End"/></span>
	<span>]</span>
      </xsl:with-param>
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="CharSet">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-normal">
      <xsl:with-param name="header">
	<span>[</span><span class="string"><xsl:value-of select="@Value "/></span><span>]</span>
      </xsl:with-param>
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="Sequence">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-indented-match-first-child-inline">
      <xsl:with-param name="separator" select="','"/>
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="StringType">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-normal">
      <xsl:with-param  name="header">
	<xsl:if test="not(*) and not(@IDRef or @CurrIDRef)">
	  <span class="key"><xsl:value-of select="local-name(.)"/> &space;
	  </span>
	</xsl:if>
	<xsl:call-template name="render-ref"/>
      </xsl:with-param>
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="Sequence[ancestor::Attribute or ancestor::AttributeDecl or ancestor::StringType or ancestor::StringTypeDef]">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-normal">
      <xsl:with-param name="left-parentheses" select="''"/>
      <xsl:with-param name="right-parentheses" select="''"/>
      <xsl:with-param name="header"></xsl:with-param>
      <xsl:with-param name="footer"/>
      <xsl:with-param name="separator" select="''"/>
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="Union">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="recurse-indented-match-first-child-inline">
      <xsl:with-param name="separator" select="' |'"/>
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="parenthesized-postfix">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:param name="operator"/>
    <xsl:choose>
      <xsl:when test="count(*[not(self::Label or self::BriefDoc or self::Doc)])=1">
	<xsl:call-template name="recurse-indented-match-first-child-inline">
	  <!-- don't make parentheses -->
	  <xsl:with-param name="trailing">
	    <span><xsl:copy-of select="$operator"/></span>
	    <xsl:copy-of select="$trailing"/>
	  </xsl:with-param>
	  <xsl:with-param name="left-parentheses" select="''"/>
	  <xsl:with-param name="right-parentheses"  select="''"/>
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="not(count(*[not(self::Label or self::BriefDoc or self::Doc)])=1)">
	<!-- make parentheses -->
	<xsl:call-template name="recurse-indented-match-first-child-inline">
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="trailing">
	    <span><xsl:copy-of select="$operator"/></span>
	    <xsl:copy-of select="$trailing"/>
	  </xsl:with-param>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="parenthesized-infix">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:param name="operator"/>
    <xsl:choose>
      <xsl:when test="count(*[not(self::Label or self::BriefDoc or self::Doc)])=1">
	<xsl:call-template name="recurse-indented-match-first-child-inline">
	  <xsl:with-param name="trailing">
	    <span><xsl:copy-of select="$operator"/></span>
	    <xsl:copy-of select="$trailing"/>
	  </xsl:with-param>
	  <xsl:with-param name="left-parentheses" select="'{'"/>
	  <xsl:with-param name="right-parentheses"  select="'}'"/>
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:when test="not(count(*[not(self::Label or self::BriefDoc or self::Doc)])=1)">
	<xsl:call-template name="recurse-indented-match-first-child-inline">
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="left-parentheses" select="'{'"/>
	  <xsl:with-param name="right-parentheses" select="'}'"/>
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="separator">
	    <span class="key">&space;<xsl:copy-of select="$operator"/></span>
	  </xsl:with-param>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
	</xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="Optional">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="parenthesized-postfix">
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
      <xsl:with-param name="operator" select="'?'"/>
    </xsl:call-template>
  </xsl:template>

 <xsl:template match="Repeat">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="parenthesized-postfix">
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
      <xsl:with-param name="operator">
	<sup><xsl:value-of select="@Value"/></sup>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="ZeroOrMore">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="parenthesized-postfix">
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
      <xsl:with-param name="operator" select="'*'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="OneOrMore">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:call-template name="parenthesized-postfix">
      <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
      <xsl:with-param name="trailing" select="$trailing"/>
      <xsl:with-param name="element-name-or-stuff-on-line-already" select="$element-name-or-stuff-on-line-already"/>
      <xsl:with-param name="operator" select="'+'"/>
    </xsl:call-template>
  </xsl:template>

<!-- COMMON RECURSIVE TEMPLATE -->

  <xsl:template match="text()">	
    <xsl:param name="trailing"/>
    <span class="concrete"><xsl:value-of select="."/></span>
    <xsl:copy-of select="$trailing"/>
  </xsl:template>


  <xsl:template name="recurse-normal" match="*">

    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:param name="stuff-after-first-child"/>  

    <xsl:param name="left-parentheses" select="'{'"/>
    <xsl:param name="right-parentheses" select="'}'"/>
    <xsl:param name="separator" select="';'"/>
    <xsl:param name="do-not-inline" select="false()"/>
    <xsl:param name="do-not-single-child-inline" select="false()"/>
    <xsl:param name="render-parentheses-for-empty-elements" select="false()"/>

    <!-- for things like "If"s, we may want to inline the first child
    (for "If"s that would amount to the Boolean condition) -->
    
    <xsl:param name="first-child-inline" select="false()"/>

    <xsl:param name="header">
      <span class="key"><xsl:value-of select="local-name(.)"/>
      </span> 
      <xsl:if test="* or @ID or @RenewID or @IDRef or @CurrIDRef">
	<span>&space;</span>
      </xsl:if> 
      <xsl:call-template name="render-ref"/>
      <xsl:call-template name="render-def"/>
    </xsl:param>

    <xsl:param name="footer"/>

    <xsl:variable name="shallow" select="not(&deep-expression;)"/>

    <xsl:copy-of select="$header"/>

    <xsl:choose>
      <xsl:when test="(* or text()) and (not($shallow) or $do-not-inline)">
	<xsl:copy-of select="$left-parentheses"/>
	<xsl:call-template name="recurse-prepare-children">
	  <xsl:with-param name="trailing">
	    <xsl:if test="not($footer)">
	      <xsl:copy-of select="$trailing"/>
	    </xsl:if>
	  </xsl:with-param>
	  <xsl:with-param name="right-parentheses" select="$right-parentheses"/>
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
	  <xsl:with-param name="stuff-after-first-child" select="$stuff-after-first-child"/>  
	  <xsl:with-param name="separator">
	    <xsl:copy-of select="$separator"/>
	  </xsl:with-param>
	  <xsl:with-param name="set-indented-to-match-first-child" select="false()"/>
	  <xsl:with-param name="inline" select="false()"/>
	  <xsl:with-param name="first-child-inline" 
			  select="not($do-not-inline) and 
			  ($first-child-inline or
			  (count(*[not(self::Label or self::BriefDoc or self::Doc)])=1 and not ($do-not-single-child-inline)))"/>
	  <xsl:with-param name="header" select="$header"/>
	</xsl:call-template>
	<xsl:if test="$footer">
	  <div style="&block-indentation-extra-minus-one;">
	    <xsl:copy-of select="$footer"/>
	    <xsl:copy-of select="$trailing"/>
	  </div>
	</xsl:if>
      </xsl:when>

      <xsl:when test="(* or text()) and $shallow">
	<xsl:copy-of select="$left-parentheses"/>
	<xsl:call-template name="recurse-prepare-children">
	  <xsl:with-param name="trailing">
	    <xsl:copy-of select="$footer"/>
	    <xsl:copy-of select="$trailing"/>
	  </xsl:with-param>
	  <xsl:with-param name="right-parentheses" select="$right-parentheses"/>
	  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>

	  <xsl:with-param name="separator" select="$separator"/>
	  <xsl:with-param name="set-indented-to-match-first-child" select="false()"/>
	  <xsl:with-param name="inline" select="true()"/>
	  <xsl:with-param name="header" select="$header"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" 
			  select="true()"/>
	  <xsl:with-param name="stuff-after-first-child" select="$stuff-after-first-child"/>  
	</xsl:call-template>
      </xsl:when>
      
      <xsl:when test="not((* or text()))">
	<!-- even when there are no children, we call recurse-prepare-children 
	to typeset trailing stuff  -->
	<xsl:copy-of select="$stuff-after-first-child"/>  
	<xsl:call-template name="recurse-prepare-children">
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="render-parentheses-for-empty-elements"
			  select="$render-parentheses-for-empty-elements"/>
	  <xsl:with-param name="left-parentheses" select="$left-parentheses"/>
	  <xsl:with-param name="right-parentheses" select="$right-parentheses"/>
	</xsl:call-template>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="recurse-indented-match-first-child-inline">
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="trailing"/>
    <xsl:param name="element-name-or-stuff-on-line-already"/>
    <xsl:param name="left-parentheses" select="'('"/>
    <xsl:param name="right-parentheses" select="')'"/>
    <xsl:param name="separator"/>
    <xsl:variable name="shallow" select="not(&deep-expression;)"/>
    
    <xsl:choose>

      <xsl:when test="$shallow or ((count(*[not(self::Label or self::BriefDoc or self::Doc)])=1) and not((Element and $left-parentheses)))">

	<!-- we would like left parentheses to cling together when
	things are typeset inline or with when there is only one
	child, like in

	{{ A | 
           B}}+

        but an exception to this is a single Element

        { <X>
            xxx
          </X>}
   
        in parentheses
     
         -->

	<xsl:call-template name="recurse-prepare-children">
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="left-parentheses" select="$left-parentheses"/>	
	  <xsl:with-param name="right-parentheses" select="$right-parentheses"/>
	  <xsl:with-param name="extra-indent-level" 
			  select="$extra-indent-level"/>
	  <xsl:with-param name="separator" select="$separator"/>
	  <xsl:with-param name="set-indented-to-match-first-child" 
			  select="false()"/>
	  <xsl:with-param name="inline" select="true()"/>
	  <xsl:with-param name="element-name-or-stuff-on-line-already" 
			  select="false()"/>
	</xsl:call-template>
      </xsl:when>
      
      <xsl:when test="$element-name-or-stuff-on-line-already and not($shallow)">
	<!-- we don't proceed on current line but make a new one
	so as to avoid too much indentation -->
	<div style="&block-indentation-extra;">
	  <xsl:call-template name="recurse-prepare-children">
	    <xsl:with-param name="trailing" select="$trailing"/>
	    <xsl:with-param name="left-parentheses" select="$left-parentheses"/>	
	    <xsl:with-param name="right-parentheses" 
			    select="$right-parentheses"/>
	    <xsl:with-param name="extra-indent-level" 
			    select="0"/>
	    <xsl:with-param name="separator" select="$separator"/>
	    <xsl:with-param name="set-indented-to-match-first-child" 
			    select="true()"/>
	  </xsl:call-template>
	</div>
      </xsl:when>
      
      <xsl:when test="not($element-name-or-stuff-on-line-already) and not($shallow)">
	<xsl:call-template name="recurse-prepare-children">
	  <xsl:with-param name="trailing" select="$trailing"/>
	  <xsl:with-param name="left-parentheses" select="$left-parentheses"/>	
	  <xsl:with-param name="right-parentheses" select="$right-parentheses"/>
	  <xsl:with-param name="extra-indent-level" 
			  select="$extra-indent-level"/>
	  <xsl:with-param name="separator" select="$separator"/>
	  <xsl:with-param name="set-indented-to-match-first-child" 
			  select="true()"/>
	</xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="recurse-prepare-children">

    <xsl:param name="trailing"/>
    <xsl:param name="left-parentheses"/> 
    <xsl:param name="right-parentheses"/> 
    <xsl:param name="extra-indent-level" select="0"/>
    <xsl:param name="separator"/>
    <xsl:param name="set-indented-to-match-first-child"/>
    <xsl:param name="header"/>
    <xsl:param name="element-name-or-stuff-on-line-already" select="true()"/>
    <xsl:param name="inline"/>
    <xsl:param name="first-child-inline"/>
    <xsl:param name="render-parentheses-for-empty-elements"
	       select="true()"/>  
    <xsl:param name="stuff-after-first-child"/>  

    <xsl:choose>
      <xsl:when test="* or count(text()[not(.='')]) > 0 or comment()">
	
	<!--there are element children or at least one
	text node that does not contain the empty string  -->
	<!-- there are some children to process -->
	<xsl:for-each select="*[not(self::Label or self::BriefDoc or self::Doc)] | text() | comment()">
	  <xsl:if test="self::comment()">
	    <xsl:apply-templates select="."/>
	  </xsl:if>
	  <xsl:if test="not(self::comment())">
	    <xsl:if test="not(self::text() and .='')">
	      <xsl:variable name="trailing-stuff">
		<xsl:choose>
		  <xsl:when test="not(following-sibling::*) and
			    not(following-sibling::text()[not(.='')])">
		    <!-- last child -->
		    <xsl:copy-of select="$right-parentheses"/>
		    <xsl:if test="$stuff-after-first-child and 
			    not(preceding-sibling::*[not(self::Label 
			    or self::BriefDoc or self::Doc)])">
		      <xsl:copy-of select="$stuff-after-first-child"/>
		    </xsl:if>
		    <xsl:copy-of select="$trailing"/>
		  </xsl:when>
		  <xsl:when test="true()">
		    <!-- self::* and  -->
		    <xsl:if test="$stuff-after-first-child and 
			    not(preceding-sibling::*[not(self::Label or self::BriefDoc or self::Doc)])">
		      <xsl:copy-of select="$stuff-after-first-child"/>
		    </xsl:if>
		    <xsl:copy-of select="$separator"/>&space;
		  </xsl:when>
		    <xsl:otherwise>
		      <!-- not last child  -->
		    </xsl:otherwise>
		</xsl:choose>
	      </xsl:variable>
	      
	      <xsl:choose>
		
		<xsl:when test="(self::* or self::text()) and not(preceding-sibling::*[not(self::Label or self::BriefDoc or self::Doc)] or preceding-sibling::text()[not(.='')])">
		  <!-- first element child -->
		  <span>  		    
		    <xsl:call-template name="do-doc"/>
		    <xsl:choose>

		      <xsl:when test="$set-indented-to-match-first-child">

			<span><xsl:copy-of select="$left-parentheses"/></span>
			<span>&block-indentation-level-less-one-spaces;</span>
			<xsl:apply-templates select=".">
			  <xsl:with-param name="trailing" 
					  select="$trailing-stuff"/>
			  <xsl:with-param name="extra-indent-level" 
					  select="$extra-indent-level + 1"/>
			  <xsl:with-param name="element-name-or-stuff-on-line-already" 
					  select="false()"/>
			</xsl:apply-templates>
		      </xsl:when>
		      
		      <xsl:when test="$inline or $first-child-inline">
			<span><xsl:copy-of select="$left-parentheses"/></span>

			<xsl:apply-templates select=".">
			  <xsl:with-param name="trailing" select="$trailing-stuff"/>
			  <xsl:with-param name="element-name-or-stuff-on-line-already" 
					  select="element-name-or-stuff-on-line-already"/>

			  <xsl:with-param name="extra-indent-level" select="$extra-indent-level"/>
			</xsl:apply-templates>
		      </xsl:when>
		      
		      <xsl:otherwise>
			<span><xsl:copy-of select="$left-parentheses"/></span>
			<div style="&block-indentation-extra;">
			  <xsl:apply-templates select=".">
			    <xsl:with-param name="trailing" select="$trailing-stuff"/>

			    <xsl:with-param name="set-indented-to-match-first-child"
					    select="$set-indented-to-match-first-child"/>
			    <xsl:with-param name="element-name-or-stuff-on-line-already" 
					    select="false"/>
			    <xsl:with-param name="extra-indent-level" select="0"/>
			  </xsl:apply-templates>
			</div>
		      </xsl:otherwise>
		    </xsl:choose>
		  </span>
		</xsl:when>

		<!-- an element child that is not the first -->
		<xsl:when test ="(self::*  or self::text()) and (preceding-sibling::*[not(self::Label or self::BriefDoc or self::Doc)] or preceding-sibling::text()[not(.='')])">
		  
		  <xsl:choose>
		    
		    <xsl:when test="$inline">
		      <span>
			<xsl:call-template name="do-doc"/>
			<xsl:apply-templates  select=".">
			  <xsl:with-param name="trailing" select="$trailing-stuff"/>
			  <xsl:with-param name="element-name-or-stuff-on-line-already" 
					  select="$element-name-or-stuff-on-line-already"/>
			</xsl:apply-templates>
		      </span>
		    </xsl:when>
		    
		    <xsl:otherwise>
		      
		      <div style="&block-indentation-extra;">
			<xsl:call-template name="do-doc"/>
			<xsl:apply-templates  select=".">
			  <xsl:with-param name="trailing" select="$trailing-stuff"/>

			  <xsl:with-param name="element-name-or-stuff-on-line-already" 
					  select="false()"/>
			  <xsl:with-param name="extra-indent-level" select="0"/>
			</xsl:apply-templates>
		      </div>
		    </xsl:otherwise>
		  </xsl:choose>
		</xsl:when>
	      </xsl:choose>
	    </xsl:if>
	  </xsl:if>
	</xsl:for-each>
      </xsl:when>
      
      <!-- typesetting an empty element -->
      <xsl:when test="not(* or text()) and 
		not($render-parentheses-for-empty-elements)">
	<xsl:copy-of select="$trailing"/>
      </xsl:when>
      <xsl:when test="not(* or text()) and 
		$render-parentheses-for-empty-elements">
	<xsl:copy-of select="$left-parentheses"/><xsl:copy-of select="$left-parentheses"/><xsl:copy-of select="$trailing"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!-- REFERENCES -->

  <xsl:template name="render-attr-IDRef-CurrIDRef">
   
   <xsl:choose>
      <xsl:when test="@IDRef">
	<xsl:param name="last-definition-id" 
		   select="generate-id(
		   key('IDkey', @IDRef)[last()])"/>
	<a class="user"><xsl:attribute name="href">#<xsl:value-of select="$last-definition-id"/></xsl:attribute><xsl:value-of select="@IDRef"/></a>
      </xsl:when>
      <xsl:when test="@CurrIDRef">
	<xsl:param name="last-definition-id" 
		   select="generate-id(
		   preceding::*[@ID = current()/@CurrIDRef
		   or @RenewID = current()/@CurrIDRef])"/>
	<a class="user"><xsl:attribute name="href">#<xsl:value-of select="$last-definition-id"/></xsl:attribute><xsl:value-of select="@CurrIDRef"/><span class="key">[Current]</span> 
	</a>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="render-ref">
   <xsl:if test="@IDRef or @CurrIDRef">
      <xsl:call-template name="render-attr-IDRef-CurrIDRef"/>
    </xsl:if> 
  </xsl:template>

  <!-- DEFINITIONS -->

  <xsl:template name="render-attr-ID-RenewID">
    <xsl:choose>
      <xsl:when test="@ID">
	<a class="user-bold"><xsl:attribute name="Name"><xsl:value-of select="generate-id(.)"/></xsl:attribute><xsl:value-of select="@ID"/></a>
      </xsl:when>
      <xsl:when test="@RenewID">
	<a class="user-bold"><xsl:attribute name="Name"><xsl:value-of select="generate-id(.)"/></xsl:attribute><xsl:value-of select="@RenewID"/></a>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="render-def">
   <xsl:if test="@ID">
      <span class="special-key">ID=</span>
      <xsl:call-template name="render-attr-ID-RenewID"/>
    </xsl:if> 
    <xsl:if  test="@RenewID">
      <span class="special-key">RenewID=</span>
      <xsl:call-template name="render-attr-ID-RenewID"/>
    </xsl:if> 
  </xsl:template>

  <!-- TAGS -->

  <xsl:template name="render-element-name">
      <xsl:choose>
	<xsl:when test="not(@Name) and @ID">
	  <xsl:value-of select="@ID"/>
	</xsl:when> 
	<xsl:when test="not(@Name) and @IDRef and key('IDkey',@IDRef)/@Name">
	  <xsl:value-of select="key('IDkey',@IDRef)/@Name"/>
      </xsl:when>
      <xsl:when test="not(@Name) and @IDRef and key('IDkey',@IDRef)/@ID">
	<xsl:value-of select="key('IDkey',@IDRef)/@ID"/>
      </xsl:when>
      <xsl:otherwise> 
	<xsl:value-of select="@Name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="render-start-tag">
    <span class="concrete">&lt;<xsl:call-template name="render-element-name"/>&gt;</span>
  </xsl:template>

  <xsl:template name="render-end-tag">
    <span class="concrete">&lt;/<xsl:call-template name="render-element-name"/>&gt;</span>
  </xsl:template>


  <xsl:template name="render-empty-tag">
    <span class="concrete">&lt;<xsl:call-template name="render-element-name"/>/&gt;</span>
  </xsl:template>
  
</xsl:stylesheet> 
