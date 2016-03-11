<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>cfdocument tag: how to use pagebreak (page break) as cfdocumentitem type in printable document</title>
</head>

<body>

<cftry>
	<cfstoredproc  procedure="wwokbapi.f_get_hs_students" datasource="hsguidanceoracle">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_hs_code" type="in" value="111998"> 
	<cfprocresult name="out_result_set">
	</cfstoredproc> 
	<cfdump var="#out_result_set#">
<cfcatch>
	<cfset query=QueryNew("")>
	error
</cfcatch>

</cftry>

<cfdocument format="pdf">
 <cfoutput>
       <!--- <cfdocumentitem type="header"> not using these 'czu they take more time--->
            This isPage Header <br />
            Total Page Count: #cfdocument.totalpagecount#
        <!---</cfdocumentitem>--->

        <!---<cfdocumentsection>--->
            <h3 style="color:Crimson; font-style:italic">
                cfdocument example: using page break
            </h3>
            <!---<cftable query="qParks" colheaders="yes" htmltable="no" border="no">
                <cfcol header="Park Name" text="#ParkName#">
                <cfcol header="City" text="#City#">
            </cftable>--->
			<cfloop from="1" to="364" index="i">
			<cfloop query="out_result_set">
	            <cfdocumentitem type="pagebreak">
	            </cfdocumentitem>
	            <h3 style="color:DimGray; font-style:italic">
	                This is another page
	            </h3>
				<p>#out_result_set.panther_no#</p>
			</cfloop>
			</cfloop>
        <!---</cfdocumentsection>--->
 </cfoutput>
</cfdocument>

</body>
</html>
