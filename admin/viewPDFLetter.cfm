<cfapplication name="applicantstatusAppAdmin" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<cfif not isDefined("Session.admin_appstatus_user") or Session.admin_appstatus_user eq ""><p>Sorry, you do not have access to this letter.</p><cfexit></cfif>

<cfquery name="getLetter" datasource="eAcceptance">
select letter_text, student_type from sent_letters where letter_id=#letter_id#
</cfquery>

<cfif getLetter.RecordCount eq 0>
<p>Sorry, this letter does not exist.</p><cfexit>
</cfif>

<cfheader name="Content-Disposition" value="inline; filename=myAdmissionsLetter.pdf">
<cfcontent type="application/pdf">

<cfdocument format="pdf"  marginBottom="0" marginTop="0" marginLeft="0" marginRight="0" pagewidth="8.5" pageheight="11.75" pageType="custom">

<cfif getLetter.student_type eq 101 or getLetter.student_type eq 101>
    <cfset margininch=1>
<cfelse>
    <cfset margininch=.3>
</cfif>

<style type="text/css"> 
<cfoutput>body{font-family:"Times New Roman", Times, serif; margin: 0px #margininch#in 0px #margininch#in; padding: 0px; font-size:15px;}</cfoutput>
#letter p {margin-bottom: 9px; margin-top:0px; font-size: 12pt; line-height:20px; }
#letter br {margin-bottom:0px; margin-top:0px; line-height:13px; }
#letter {margin-top:145px;margin-bottom:0px;}
<!---had to be added 4/7/2015 because no space before links---> a {margin-left:4px;}
</style>

<cfset myObject = createObject( "java", "ZipUtil" )>
<cfset decompressed_letter = myObject.decompress( getLetter.letter_text ) >
<cfif cgi.server_name eq "app.gsu.edu">
    <cfset decompressed_letter=Replace('#decompressed_letter#', '/applicantstatus/admin/images/scott_sig.gif', 'file:///d:\inetpub\applicantstatus\admin\images\scott_sig.gif', 'ALL')>
    <cfset decompressed_letter=Replace('#decompressed_letter#', 'file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif', 'file:///d:\inetpub\applicantstatus\admin\images\scott_sig.gif', 'ALL')>
     <cfset decompressed_letter=Replace('#decompressed_letter#', '/applicantstatus/admin/images/dean_berman_sig.jpg', 'file:///d:\inetpub\applicantstatus\admin\images\dean_berman_sig.jpg', 'ALL')>
<cfelseif cgi.server_name eq "istcfdev.gsu.edu" or cgi.server_name eq "istcfqa.gsu.edu">
    <cfset decompressed_letter=Replace('#decompressed_letter#', '/applicantstatus/admin/images/scott_sig.gif', 'file:///d:\inetpub\cf-qa\applicantstatus\admin\images\scott_sig.gif', 'ALL')>
    <cfset decompressed_letter=Replace('#decompressed_letter#', 'file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif', 'file:///d:\inetpub\cf-qa\applicantstatus\admin\images\scott_sig.gif', 'ALL')>
<cfelse>
    <cfset decompressed_letter=Replace('#decompressed_letter#', '/applicantstatus/admin/images/scott_sig.gif', 'file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif', 'ALL')>
</cfif>
<cfset decompressed_letter=Replace('#decompressed_letter#', '>.', '> .', 'ALL')>
<cfoutput><div id="letter">#decompressed_letter#</div></cfoutput>

</cfdocument>