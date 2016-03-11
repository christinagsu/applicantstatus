<cfapplication name="applicantstatusApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<cfinvoke component="applicantStatus" method="addZeros" panther_id="#Session.student_id#" returnvariable="panther_no" />
<cfquery name="insertLogin" datasource="eAcceptance">
    insert into student_clicks (click_id, panther_id, click_event, click_date, user_agent) values (studentclicks_seq.NEXTVAL, '#panther_no#', 7, #NOW()#, '#Left(CGI.HTTP_USER_AGENT, 499)#')
</cfquery>


<cfquery name="getLetter" datasource="eAcceptance">
select letter_text, student_id, student_type from sent_letters where letter_id=#letter_id#
</cfquery>

<cfif getLetter.student_id neq Session.student_id><p>Sorry, you do not have access to this letter.</p><cfexit></cfif>

<cfheader name="Content-Disposition" value="inline; filename=myAdmissionsLetter.pdf">
<cfcontent type="application/pdf">

<cfdocument format="pdf"  marginBottom="0" marginTop="0.25" marginLeft=".25" marginRight=".2" pagewidth="8.5" pageheight="11.75" pageType="custom">

<cfif getLetter.student_type eq 101 or getLetter.student_type eq 106>
		<cfset margininch=1>
<cfelse>
		<cfset margininch=0>
</cfif>

<style type="text/css"> 
<cfoutput>body{font-family:"Times New Roman", Times, serif; margin: 0in #margininch#in 0in #margininch#in; padding: 0px 10px; font-size: 12pt;}</cfoutput>
#letter p {margin-bottom: 9px; margin-top:0px; font-size: 11pt; line-height:19px;}
#letter ul {font-size: 9pt; line-height:13px;}
#letter li {font-size: 9pt; line-height:13px;}
#letter br {margin-bottom:0px; margin-top:0px; line-height:10px; }
#letter {margin-top:0px;margin-bottom:0px;}
</style>

<cfif getLetter.student_type eq 41>
	<cfset header_image="HonorsLetterhead.png">
<cfelse>
	<cfset header_image="header2.png">
</cfif>

<cfoutput>
<cfif cgi.server_name eq "glacierqa.gsu.edu" or cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "app.gsu.edu">
    	<!---doesn't work anymore?1/5/2015, worked yesterday!  <img src="admin/images/#header_image#"/>--->
	<img src="file:///d:\inetpub\applicantstatus\admin\images\#header_image#" width="600" />
    <cfelseif cgi.server_name eq "istcfqa.gsu.edu" or cgi.server_name eq "istcfdev.gsu.edu">
    	<img src="file:///d:\inetpub\cf-qa\applicantstatus\admin\images\#header_image#" width="600" />
    </cfif>
</cfoutput>


<cfset myObject = createObject( "java", "ZipUtil" )>
<cfset decompressed_letter = myObject.decompress( getLetter.letter_text ) >
<cfif cgi.server_name eq "app.gsu.edu">
    <!---doesn't work anymore?1/5/2015, worked yesterday!  <cfset decompressed_letter=Replace('#decompressed_letter#', 'file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', 'admin/images/scott_sig.gif" />', 'ALL')>--->
    <cfset decompressed_letter=Replace('#decompressed_letter#', 'file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" ', 'file:///d:\inetpub\applicantstatus\admin\images\scott_sig.gif"', 'ALL')>
    <cfset decompressed_letter=Replace('#decompressed_letter#', '/applicantstatus/admin/images/dean_berman_sig.jpg" ', 'file:///d:\inetpub\applicantstatus\admin\images\dean_berman_sig.jpg"', 'ALL')>
<cfelseif cgi.server_name eq "webdb.gsu.edu">
    <cfset decompressed_letter=Replace('#decompressed_letter#', '<img src="/applicantstatus/admin/images/scott_sig.gif" />', '<img src="file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', 'ALL')>
    <cfset decompressed_letter=Replace('#decompressed_letter#', '/applicantstatus/admin/images/scott_sig.gif', 'file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif', 'ALL')>
<cfelseif cgi.server_name eq "istcfqa.gsu.edu">
    <cfset decompressed_letter=Replace('#decompressed_letter#', '<img src="/applicantstatus/admin/images/scott_sig.gif" />', '<img src="file:///D:\inetpub\cf-qa\applicantstatus\admin\images\scott_sig.gif" />', 'ALL')>
    <cfset decompressed_letter=Replace('#decompressed_letter#', '<img src="/applicantstatus/admin/images/dean_berman_sig.jpg" />', '<img src="file:///D:\inetpub\cf-qa\applicantstatus\admin\images\dean_berman_sig.jpg" />', 'ALL')>
    <cfset decompressed_letter=Replace('#decompressed_letter#', '/applicantstatus/admin/images/scott_sig.gif', 'file:///D:\inetpub\cf-qa\applicantstatus\admin\images\scott_sig.gif', 'ALL')>
    <cfset decompressed_letter=Replace('#decompressed_letter#', 'file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif', 'file:///D:\inetpub\cf-qa\applicantstatus\admin\images\scott_sig.gif', 'ALL')>
</cfif>
<cfset decompressed_letter=Replace('#decompressed_letter#', '</span><a', '</span>&nbsp;<a', 'ALL')>
<cfset decompressed_letter=Replace('#decompressed_letter#', '</a><span ', '</a>&nbsp;<span', 'ALL')>
<cfset decompressed_letter=Replace('#decompressed_letter#', ' <a', ' &nbsp;<a', 'ALL')>


<div id="letter">
<cfoutput>#decompressed_letter#</cfoutput>
</div>
</cfdocument>