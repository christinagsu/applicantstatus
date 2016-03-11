<cfif isDefined("URL.panid")>
    <cfset appname="returningStudentsScholStatus">
<cfelse>
    <cfset appname="applicantstatusApp">
</cfif>
<cfapplication name="#appname#" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<cfif isDefined("URL.letter_id")><cfset Session.scholarship_letter_id=URL.letter_id></cfif>

<cfif not isDefined("Session.student_id")><p>Sorry, you have been timed out.  Please <a href="index.cfm">login again</a>.<br><br><br><br></p><cfabort></cfif>
<cfinvoke component="applicantStatus" method="addZeros" panther_id="#Session.student_id#" returnvariable="panther_no" />
<cfquery name="insertLogin" datasource="eAcceptance">
    insert into student_clicks (click_id, panther_id, click_event, click_date, user_agent) values (studentclicks_seq.NEXTVAL, '#panther_no#', 8, #NOW()#, '#Left(CGI.HTTP_USER_AGENT, 499)#')
</cfquery>

<cfheader name="Content-Disposition" value="inline; filename=myScholarshipLetter.pdf">
<cfcontent type="application/pdf">
<cfif not isDefined("Session.mobile")><cfset Session.mobile="false"></cfif>
<cfsavecontent variable="scholarshipLetterPage">
 <cfif Session.mobile eq "true">
 	<link href="/applicantstatus/mobilestyles.css" rel="stylesheet" type="text/css" />
    <meta name="HandheldFriendly" content="true" />
	<meta name="viewport" content="width=device-width, height=device-height, user-scalable=no, initial-scale=1" />
    <cfinvoke component="applicantStatus" method="showBanner">
 </cfif>
<!---<style type="text/css"> 
body{font-family:"Times New Roman", Times, serif; margin: 0px; padding: 0px 10px;}
</style>--->
<!---<img src="admin/images/header2.png" width="600" />
<img src="file:///c:\inetpub\wwwroot\applicantstatus\admin\images\header2.png" width="600" />--->
<cfif cgi.server_name eq "glacierqa.gsu.edu" or cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "istcfdev.gsu.edu" or cgi.server_name eq "istcfqa.gsu.edu">
    	<!---also doesn't work anymore because of change on server 1/7/2015: <img src="admin/images/header2.png" width="600" />--->
	<img src="file:///d:\inetpub\cf-qa\applicantstatus\admin\images\header2.png" width="600" />
    <cfelseif  cgi.server_name eq "app.gsu.edu">
	<img src="file:///d:\inetpub\applicantstatus\admin\images\header2.png" width="600" />
    <cfelse>
    	<img src="file:///c:\inetpub\wwwroot\applicantstatus\admin\images\header2.png" width="600" />
    </cfif>
    <cfif isDefined("URL.letter_id")>
	<cfquery name="getLetter" datasource="eAcceptance">
	select student_id, appterm from sent_letters where letter_id=#URL.letter_id#
	</cfquery>
	<cfset curstudid=getLetter.student_id>
    <cfelse>
	<cfset curstudid=Decrypt(URL.panid, "#Session.campusid##Session.enc_key#")>
    </cfif>
    <cfloop from="1" to="5" index="i">
    	<cfif len(curstudid) lt 9><cfset curstudid="0"&curstudid></cfif>
    </cfloop>
    <!---<cfoutput>11 #curstudid# aa -> bb#Session.student_id#22</cfoutput>--->
    <!---<cfoutput>#getLetter.student_id# #Session.student_id#</cfoutput>--->
    <cfif (isDefined("getLetter.student_id") and (getLetter.student_id neq Session.student_id or getLetter.RecordCount eq 0)) or (isDefined("URL.panid") and curstudid neq Session.student_id)>
    	<p>Sorry, you do not have access to this letter.</p>
	<cfelse>
	    <cfif isDefined("getLetter.appterm")>
		<cfset specterm=getLetter.appterm>
	    <cfelse>
		<cfset specterm="#Session.curterm#">
	    </cfif>
	    <cfinvoke component="applicantstatus" method="showScholarshipLetter" apptermcode="#specterm#" />   
	</cfif>
</cfsavecontent>

<cfif Session.mobile eq "false">
	<cfdocument format="pdf"  marginBottom="0" marginTop=".25" marginLeft=".2" marginRight=".2" pagewidth="8.5" pageheight="11.75" pageType="custom">
		<cfoutput>#scholarshipLetterPage#</cfoutput>
	</cfdocument>
<cfelse>
	<cfoutput>#scholarshipLetterPage#</cfoutput>
</cfif>
<cfinvoke component="counselor/hsguidance" method="showPageFooter" />
</body>
</html>
                