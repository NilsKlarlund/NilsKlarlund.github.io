<?xml version="1.0"?>

<!DOCTYPE xsl:stylesheet [ 

<!ENTITY space '<xsl:text
xmlns:xsl="http://www.w3.org/XSL/Transform/1.0"><![CDATA[ ]]></xsl:text>'>

<!ENTITY spacing '.8ex'>
<!ENTITY user 'font-family: Arial, Helvetica, Sans-serif; font-style:normal;
	  font-weight:normal; color: black;'>

<!ENTITY mystyle '
font-family: Arial, helvetica,
	    sans-serif; font-weight: normal;'>
]
>

<xsl:stylesheet  
	xmlns:myxml="xxx"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">  

  <xsl:output method="html"  encoding="UTF-8" indent="no"/> 
  <xsl:strip-space elements="*"/>
  <xsl:preserve-space elements="span"/>

  <xsl:template match="/myhtml">
    <html>  
      <head>
	<title><xsl:value-of select="head/title"></xsl:value-of></title>
        <style type="text/css">

BODY { 
  link: black; 
  vlink: black; 
  background: white; 
  margin-left: 2%;
  margin-right: 2%;
}


p, ul, body { 
	  &mystyle; font-size: 10pt;
}
	


H1, H2, H3, .section {   &mystyle;
  color: #900;
}



h1 {font-size: 180%;}
h2 {font-size: 160%;}
h3 {font-size: 120%;}

HR { 
  size: 1pt;
}

TABLE,TD,TR { 
  font-family: sans-serif; 
  font-size: 100%;
}

SPAN.FOOTER { 
  font-family: sans-serif; 
  font-style: italic; 
  font-size: 100%; 
  text-align: center; 
}

A:link { 
  color: #c00 
}
A:visited { 
  color: #800;
}
A:active { 
  color: #f00; 
}
A.navigation:link { 
  color: gray; font-size:50%;
}
A.navigation:visited { 
  color:gray; font-size:50%;
}
A.navigation:active { 
  color:gray; font-size:50%;
}
.hide { 
  display: none; 
  color: white;
}

DIV.map {
  padding-top: 70px;
  margin-left: 0%;
  margin-right: 0%;
  margin-bottom: 0;
  margin-top: 0;
}
 
#p1 {
  color: #DDD; 
  font: 85px/1 "Impact", sans-serif;
  text-align: left;  
  margin: -70px 0 30px 5%;
}     
#p2 {
  color: #008; 
  font: bold 35px/1 "Verdana", sans-serif;
  text-align: left;   
  margin: -50px 0 30px 12%;
} 
#p3 { 
  margin-top: 0%;
  margin-bottom: 10px;
  margin-left: -1%;
  color: #900;
  clear: both;
  font-size: 20pt;
}
#p5 { 
  margin-left: 3%;
}

TT { 
  font-family: monospace; 
  font-weight: bold;
}
EM { 
  font-weight: normal;
  font-style: italic;
  color: red;
}
	  <!-- element container -->
	  .e  {margin-left:1em; text-indent:-1em; margin-right:1em}
	  <!-- comment or cdata -->
	  .k  {color:green; margin-left:1em;}
	  <!-- tag -->
	  .t  {font-size:90%; font:Courier; color:#990000}
	  <!-- tag in xsl namespace -->
	  .xt {color:#990099}
	  <!-- attribute in xml or xmlns namespace -->
	  .ns {color:red}
	  <!-- attribute in dt namespace -->
	  .dt {color:green;}
	  <!-- markup characters -->
	  .m  {color:blue}
	  <!-- text node -->
	  .tx {font-weight:bold}
	  <!-- multi-line (block) cdata -->
	  .db {text-indent:0px; margin-left:1em; margin-top:0px; margin-bottom:0px;
	  padding-left:.3em; border-left:1px solid #CCCCCC; font:small Courier}
	  <!-- single-line (inline) cdata -->
	  .di {font:small Courier}
	  <!-- DOCTYPE declaration -->
	  .d  {color:blue}
	  <!-- pi -->
	  .pi {color:blue}
	  <!-- multi-line (block) comment -->
	  .cb {text-indent:0px; margin-left:1em; margin-top:0px; margin-bottom:0px;
	  padding-left:.3em; font:small Courier; color:#888888}
	  <!-- single-line (inline) comment -->
	  pre {margin-left:0ex; display:inline}  
	  .key {font-weight:bold; color: purple}
	  <!-- element container -->
	  .e  {margin-left:1em; text-indent:-1em;}
	  .enoindent  {margin-left:1em;}
	  .noindent  {margin-left:0em; text-indent: 0em;}
	  .h {font-weight:bold; color: red}
	  .user {&user;}
	  .user:link {&user;}
	  .user:visited {&user;color: purple;}
	  .tt {font-family:Prestige, MS Courier New, Courier; color:blue; font-weight:bold; }
	  .cd {font: Courier; color:#888888; font-weight:bold;}




div.dsdpretty {margin-bottom:0em; margin-top:0em; margin-left:0em; font-size: 90%;}

	  div.dsdpretty div {margin-bottom:0em; margin-top:0em; margin-left:1em;
	       font-weight:bold; font-family:  Courier; }

	  .example   {margin-bottom:1em; margin-top:1em; margin-left:2em; margin-right:2em; font-size:90%; background-color:beige;  padding-left:1em;}
<!-- border-style: solid; border-width: 2px;  border-color:black; breaks Navigator 4.0 -->


	  div.dsdpretty span {color: black;}
	  div.dsdpretty div.rootchild {margin-bottom:2ex; margin-top:1ex; 
              border-style: solid; border-width: 2px;  border-color:pink; }
	  div.dsdpretty .key, div.dsdpretty .special-key {font-weight:bold; color: purple;}
	  div.dsdpretty .doc {font-family: Arial, Helvetica, Sans-serif; font-style:normal; font-weight: normal; color: grey;}
	  div.dsdpretty .user {font-family: Arial, Helvetica, Sans-serif; font-style:normal;
	  font-weight:normal; color: black;}
	  div.dsdpretty .user-bold {font-family: Arial, Helvetica, Sans-serif; font-style:normal;
	  font-weight:normal; color: black; font-weight:bold;}
	  div.dsdpretty .user:link {font-family: Arial, Helvetica, Sans-serif; font-style:normal;
	  font-weight:normal; color: black;}
	  div.dsdpretty .user:visited {font-family: Arial, Helvetica, Sans-serif; font-style:normal;
	  font-weight:normal; color: black;}
	  div.dsdpretty .concrete, .string {font-family: Courier; color: blue; font-weight:bold; }
	  div.dsdpretty .tt {font-family: Courier; color: blue; font-weight:bold; }
	  div.dsdpretty .comment {font-family: Arial, Helvetica, Sans-serif; font-style:normal;
	  div.dsdpretty font-weight:normal; color: brown;}
	  div.dsdpretty *.header {font-size:140%;  color: purple; font-family: Arial, Helvetica, Sans-serif;}
	  
	</style>
	<xsl:apply-templates select="head/*[not(self::title or self::author or self::note)]"/>
      </head>
      <body>
<!--	<div class="map">
	  <p ID="p1">DSD</p>
	  <p ID="p2"><xsl:apply-templates select="head/title"/></p>
	</div> -->
	<h1  style="font-weight:bold;"><xsl:apply-templates
select="head/title"/></h1>
	..  <!-- Netscape hack -->
	<h2><xsl:apply-templates select="head/author"/></h2>
	 ..	<!-- Netscape hack -->
	<p style="font-size:120%;"><xsl:apply-templates select="head/note"/></p>
	<h3  style="font-weight:bold;">Index</h3>
	 <ul>
	  <xsl:for-each select="body/sub">
	    <li><a href="#{generate-id(.)}"><xsl:value-of select="."/></a></li>
	  </xsl:for-each>
	</ul>
	<p> 
	<xsl:apply-templates select="/*/body/node()"/>
        </p>
      </body> 
    </html> 
  </xsl:template>
    
<xsl:template match="title | note | author"><xsl:apply-templates select="@* | node()"/></xsl:template>

  <xsl:template match="* | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
 
   <xsl:template match="ul">
    <ul>	
      <xsl:apply-templates/>
    </ul>
    <xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="ul/li">
    <li style="color:red;">
      <span  style="color:black;"><xsl:apply-templates/>
      </span>
    </li>
  </xsl:template>

   <xsl:template match="example">
    <div class="example" style="padding:.5ex;">
      <div class="{@class}">
	<xsl:apply-templates/>	
      </div>
    </div>
    <xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
  </xsl:template>
  
  <xsl:template match="/*/body//editor">
    <div style="font-weight:normal; font-family: times; color:
	red; margin:.5ex"><xsl:apply-templates/>
    </div></xsl:template>

  <xsl:template match="/*/body//math">
    <span style="font-weight:normal; font-family: times; font-style:italic; color:brown;"><xsl:apply-templates/></span></xsl:template>

  <xsl:template match="/*/body//ref">
<xsl:choose>
   <xsl:when test="@name"><a><xsl:attribute name="href">#<xsl:value-of select="@name"/></xsl:attribute><xsl:value-of select="."/></a></xsl:when>
 <xsl:when test="not(@name)"><a><xsl:attribute name="href">#<xsl:value-of select="."/></xsl:attribute></a></xsl:when>
</xsl:choose>
</xsl:template>

  <xsl:template match="/*/body//def">
    <xsl:choose>
      <xsl:when test="@name"><a><xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute><em><xsl:value-of select="."/></em></a></xsl:when>
      <xsl:when test="not(@name)"><a><xsl:attribute name="name"><xsl:value-of select="."/></xsl:attribute><em><xsl:value-of select="."/></em></a></xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="/*/body//VoiceXML">
    <span style="font-weight:bold; font-family: courier; color:purple">VoiceXML</span></xsl:template>

  <xsl:template match="/*/body//subsubsub">
    <xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
    <span class="section" style="font-weight:bold;">
     <xsl:apply-templates select="node()"/>
    </span>
 
  </xsl:template>

  <xsl:template match="/*/body//subsub">
    <div style="&mystyle;">
      <h3>
	<span style="font-weight:bold;">
	  <xsl:apply-templates select="* | comment() | processing-instruction() | text()"/>
	</span>
      </h3>
    </div>
   <xsl:text  disable-output-escaping="yes">&lt;p&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="/*/body//sub">
    <div style="&mystyle;">
      <h2><a name="{generate-id(.)}">
	<span style="font-weight:bold;">
	  <xsl:apply-templates select="* | comment() | processing-instruction() | text()"/>
	</span></a>
      </h2>
   </div>
<xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>		
  </xsl:template>

  <xsl:template match="/*/body//sect">
    <h1>
      <span style="font-weight:bold;">
	<xsl:apply-templates select="* | comment() | processing-instruction() | text()"/>
      </span>
    </h1>
  </xsl:template>

  <xsl:template match="/*/body//renegate">
     <span style="font-weight:bold; font-size: 70%; color:red;">
	<xsl:apply-templates select="* | comment() | processing-instruction() | text()"/>
    </span>
  </xsl:template>

 <xsl:template match="lxml">
	<xsl:apply-templates select="* | comment() | processing-instruction() | text()"/>
  </xsl:template>

 <xsl:template match="lxml//*">
    <xsl:if test="*| comment() | processing-instruction() | text()">
      <span class="tt">&lt;<xsl:value-of select="name(.)"/><xsl:for-each select="@*">
	  <span> </span>
	  <xsl:value-of select="name(.)"/>="<xsl:value-of select="."/>"</xsl:for-each>&gt;</span>
      <xsl:apply-templates/>
      <span class="tt">&lt;/<xsl:value-of select="name(.)"/>&gt;</span>
    </xsl:if>
    <xsl:if test="not(*| comment() | processing-instruction() | text())"><span class="tt">&lt;<xsl:value-of select="name(.)"/>
	<xsl:for-each select="@*">
	  <span> </span>
	  <xsl:value-of select="name(.)"/>="<xsl:value-of select="."/>"
	</xsl:for-each>
	/&gt;</span>
    </xsl:if>
  </xsl:template>
    

  <xsl:template match="lxml//@*">
    <xsl:copy-of select="."/>
  </xsl:template>


  <xsl:template match="VoiceXML-PI">
    <p><div style="margin-left:3ex;" class="t">&lt;?VoiceXML
	<pre class="t"><xsl:apply-templates select="@* | * | comment() | processing-instruction() | text()"/>?&gt;</pre>
      </div></p>
  </xsl:template>
 
  <xsl:template match="rule" mode="grammar">
    <TR>
      <xsl:value-of select="name(.)"/><xsl:apply-templates select="@*"/>/&gt;
    </TR>
  </xsl:template>

  <xsl:template match="grammar">
    <div><br/></div>
    <div style="margin-left:1ex;" class="t">
      <table cellpadding="" set="3">
	<xsl:apply-templates select="* | comment() | processing-instruction() | text()" mode="grammar">	
	  
	</xsl:apply-templates>
      </table>
    </div>
  </xsl:template>
  
  <!-- MODE=myxml -->


  <xsl:template match="*[node() and @myxml:bil]" mode="myxml">
          <DIV  class="tt" STYLE="margin-left:1em;  margin-bottom:&spacing;">
            <div style="margin-left:2em; text-indent:-2em;"><SPAN class="tt">&lt;<xsl:value-of select="name(.)"/><xsl:apply-templates select="@*" mode="myxml"/>&gt;</SPAN></div><div style="margin-left:1em;"><xsl:apply-templates select="node()" mode="myxml"/></div><div><SPAN  class="tt">&lt;/<xsl:value-of select="name(.)"/>&gt;</SPAN></div>
          </DIV>
        </xsl:template>

  <xsl:template match="*[not(node()) and (not(ancestor-or-self::*[@myxml:il or self::myxml:il]) or @myxml:bil)]" mode="myxml">
    <DIV class="tt" STYLE="margin-left:1em;  margin-bottom:&spacing;">
            &lt;<xsl:value-of select="name(.)"/><xsl:apply-templates select="@*" mode="myxml"/>/&gt;
          </DIV>
  </xsl:template>
  
        <xsl:template match="*[not(node()) and ancestor-or-self::*[@myxml:il or @myxml:sil or @myxml:bil]]" mode="myxml"><SPAN  class="tt">&lt;<xsl:value-of select="name(.)"/><xsl:apply-templates select="@*" mode="myxml"/>/&gt;</SPAN></xsl:template>

        <xsl:template match="*[node() and not(ancestor-or-self::*[@myxml:il or @myxml:sil or @myxml:bil])]" mode="myxml">
          <DIV  class="tt" STYLE="margin-left:1em;  margin-bottom:&spacing;">
            <div style="margin-left:2em;  margin-bottom:&spacing;; text-indent:-2em;"><SPAN class="tt">&lt;<xsl:value-of select="name(.)"/>
	  <xsl:apply-templates select="@*" mode="myxml"/>&gt;</SPAN></div>
      <xsl:apply-templates select="child::node()" mode="myxml"/>
      <div style=""><SPAN  class="tt">&lt;/<xsl:value-of select="name(.)"/>&gt;</SPAN></div>
    </DIV>
  </xsl:template>

  <xsl:template match="*[node() and @myxml:il]" mode="myxml">
    <DIV  class="tt" STYLE="margin-left:1em; margin-bottom:&spacing;">	
      <SPAN class="tt">&lt;<xsl:value-of select="name(.)"/><xsl:apply-templates select="@*"  mode="myxml"/>&gt;</SPAN>
      <xsl:apply-templates select="node()" mode="myxml"/>
      <SPAN  class="tt">&lt;/<xsl:value-of select="name(.)"/>&gt;</SPAN></DIV>
  </xsl:template>

  <xsl:template match="*[node() and ancestor::*[@myxml:il or @myxml:bil]]" mode="myxml">
            <SPAN class="tt">&lt;<xsl:value-of select="name(.)"/><xsl:apply-templates select="@*"  mode="myxml"/>&gt;</SPAN><xsl:apply-templates select="node()"  mode="myxml"/><SPAN  class="tt">&lt;/<xsl:value-of select="name(.)"/>&gt;</SPAN>
        </xsl:template>

  <xsl:template match="text()" mode="myxml">
    <xsl:choose>
      <xsl:when test="ancestor::*[@myxml:il or @myxml:bil or self::myxml:il]">
	<span class="cd"><xsl:value-of select="."/></span></xsl:when>
      <xsl:otherwise>
	<div class="cd" STYLE="margin-left:1em;  margin-bottom:&spacing;"><xsl:value-of select="."/></div></xsl:otherwise></xsl:choose></xsl:template> 
  
  <xsl:template match="@myxml:il" mode="myxml">
  </xsl:template>

  <xsl:template match="@myxml:sil" mode="myxml">
  </xsl:template>
 
  <xsl:template match="@myxml:bil" mode="myxml">
  </xsl:template>
  
  <xsl:template match="myxml:il" mode="myxml">
    <div STYLE="margin-left:1em;  margin-bottom:&spacing;">
      <xsl:apply-templates  select="node()"  mode="myxml"/>	
    </div>	 
  </xsl:template>

  <xsl:template match="myxml:br" mode="myxml">
    <div></div>	 
  </xsl:template>
   
  <xsl:template match="myxml:linespace" mode="myxml">
    <div style="font:6pt; color:beige;">.</div>	
  </xsl:template>

  <xsl:template match="@*" mode="myxml">
<xsl:if test="not(name(.)='myxml:il' or name(.)='self::myxml:sil' or 
name(.)='myxml:bil')">
    <SPAN>&space;<xsl:value-of select="name(.)"/>="<SPAN><xsl:value-of select="."/></SPAN>"</SPAN>
    </xsl:if>
</xsl:template>
  
  <xsl:template match="processing-instruction()" mode="myxml">
    <DIV class="tt" STYLE="margin-left:1em; margin-bottom:&spacing;; color:maroon">&lt;?<xsl:value-of select="name(.)"/>&space;<xsl:value-of select="."/>?&gt;</DIV>
  </xsl:template>
  
  <xsl:template match="comment()" mode="myxml">
    <DIV class="k" style="margin-bottom:&spacing;">
      <SPAN>&lt;!--</SPAN>
	    <SPAN><xsl:value-of select="."/></SPAN><SPAN class="b"> </SPAN><SPAN>--&gt;</SPAN></DIV>
  </xsl:template>


  <xsl:template match="myxml">
    <div style="font-size: 90%;">
      <xsl:apply-templates select="node()" mode="myxml"/>
    </div>
  </xsl:template>
 
  <xsl:template match="slide">
    <div style="margin-bottom: 3ex;" >
      <a name="{generate-id(.)}">
	<div> 
	  <a class="navigation" href="#{generate-id(preceding-sibling::slide[1])}">Previous</a>
	  <span style="font-size:50%;">........</span>
	  <a class="navigation" href="#{generate-id(following-sibling::slide[1])}">Next</a>
	</div>
      </a>
      <xsl:apply-templates select="node()"/>
      <div style="margin-top:120.0ex;"/> 
    </div>
  </xsl:template>

</xsl:stylesheet> 





