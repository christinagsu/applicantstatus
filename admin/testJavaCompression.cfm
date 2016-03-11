<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>

<!--- create an object based on the zipUtil class  --->
<!---cfset myObject = createObject( "java", "zipUtil" ) --->

<cfset myObject = createObject( "java", "ZipUtil" )>

<!--- call the compression method and store the result in a variable. --->
       
<cfsavecontent variable="cnn">
In many ways, the promises President Obama made in his 2009 speech to the Arab and Muslim world were doomed from the start. Obama might have sounded like an idealist, but he was thinking like a realist.
<br>The White House billed the Cairo speech as "A New Beginning," and the president made tantalizing promises not only to show progress in solving the Israeli-Palestinian conflict, but on encouraging democratic reform, and engaging authoritarian leaders hostile to the United States.
<br>And even with Obama's recently announced sanctions against Syria and Iran, it still may be too little to late.
<br>From the start it was always unlikely America was going to secure deals with countries like Iran and Syria by promising to help overthrow their leaders.
<br>Iran's Green Movement learned that all too well after the disputed election in 2009. Eager to engage the Iranian regime of President Mahmoud Ahmadinejad, the Obama administration remained on the sideline as the opposition was effectively, and violently, crushed, taking along with it a historic opportunity to win over the Iranian people.
<br>The dashed expectations Obama created hurt U.S. credibility in the region and had diplomats and Middle East experts scratching their heads about how the United States stumbled so quickly after raising hopes.
<br>Before the Arab Spring started, Obama's aides said the president had already begun weighing the risks of continuing to support unpopular and repressive regimes with a strong U.S. push for reform.
<br>An internal White House paper warned that "increased repression could threaten the political and economic stability of some of our allies, leave us with fewer capable, credible partners who can support our regional priorities, and further alienate citizens in the region," a U.S. official told CNN.
</cfsavecontent>

<cfset result = myObject.compress(cnn) >

<!--- Print the value of the variable.  --->
<cfoutput>The result is: #result#</cfoutput>

<!--- call the compression method and store the result in a variable. --->
<cfset result2 = myObject.decompress( result ) >
 
<!--- Print the value of the variable.  --->
<cfoutput>The result is: #result2#</cfoutput>

<br>
<br>
  <cfoutput>  
#len(result)#
#len(result2)#

%#len(result) / len(result2) * 100#

</cfoutput>
</body>
</html>
