<?dsd URI="xpml.dsd"?>

<XPML xmlns:DSD="http://www.brics.dk/DSD">
  <head>


    <application name="HELLOWORLD"/>
    
    <maintainer address="karam@research.att.com" loglevel="2"/>


    <title>The Greeting Application</title>

  </head>

   <?include URI="my-defaults.dsd"?> 	


  <body>


    <DSD:Default>
     <DefaultAttribute Name="interdigittimeout" Value="1000ms"/>
    </DSD:Default>

    Welcome to greetings are us.
    <span nointerrupt="yes"> <audio url="/audioclips/greeting.vox"/></span>

    <a name="repeat"/> <comment>repeat point</comment>
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
    <a href="#repeat"/> <comment>go to repeat point</comment>
	  
    <a name="endit"/> <comment>end point</comment> 
    
  </body>

</XPML>




