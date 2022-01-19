<?dsd URI="xpml-att.dsd"?>
<XPML>
  <head>
    <application name="HELLOWORLD"/>
    <maintainer address="karam@research.att.com" loglevel="2"/>
    <title>The Greeting Application</title>
  </head>
  <body>
    Welcome to greetings are us.
    <span nointerrupt="y"> <audio url="/audioclips/greeting.vox"/></span>
    <a name="repeat"/> 
    <menu name="feelings">
      <option dtmf="0">To end</option>
      <do><a href="#endit"/><comment>go to end point</comment></do>

      <option> If you are feeling energized. </option>
      <do> Hello world! </do> 

      <option> If you are feeling like a cowboy. </option>
      <do> Howdy world! </do> 

      <option> If you are feeling like a canadian. </option>
      <do> Gid'day world, how's it going eh? </do> 

      <option> If you are feeling depressed. </option>
      <do> The world sucks. </do> 
    </menu>
    <a href="#repeat"/> 
    <a name="endit"/> 
  </body>
</XPML>




