<cfapplication name="applicantstatusAppAdmin" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<cfif not isDefined("Session.admin_appstatus_user") or Session.admin_appstatus_user eq ""><p>Sorry, you do not have access to this letter.</p><cfexit></cfif>

<cfquery name="getForm" datasource="eAcceptance">
select form_text from scholarship_forms_archive where form_id=#URL.form#
</cfquery>

<cfif getForm.RecordCount eq 0>
<p>Sorry, this form does not exist.</p><cfexit>
</cfif>

<cfdocument format="pdf"  marginBottom="0" marginTop="0" marginLeft="0" marginRight="0" pagewidth="8.5" pageheight="11.75" pageType="custom">

<style type="text/css"> 
body{font-family:"Times New Roman", Times, serif; margin: 0px .3in 0px .3in; padding: 0px; font-size:14px;}
table{font-family:"Times New Roman", Times, serif; margin: 0px 0in 0px 0in; padding: 0px; font-size:14px;}
#letter p {margin-bottom: 18px; margin-top:0px; line-height:17px; }
#letter br {margin-bottom:0px; margin-top:0px; line-height:13px; }
/*WAS: #letter {margin-top:145px;margin-bottom:0px;}*/
#letter {margin-top:0px;margin-bottom:0px;}
</style>

<cfset myObject = createObject( "java", "ZipUtil" )>
<cfset decompressed_letter = myObject.decompress( getForm.form_text ) >
<cfif cgi.server_name eq "app.gsu.edu">
    <cfset decompressed_letter=Replace(decompressed_letter, "file:///c:\inetpub\wwwroot\applicantstatus\counselor\images\foundation_logo.gif", "file:///d:\inetpub\applicantstatus\counselor\images\foundation_logo.gif")>
    <cfset decompressed_letter=Replace(decompressed_letter, "/applicantstatus/counselor/images/head_logo.gif", "file:///d:\inetpub\applicantstatus\counselor\images\head_logo.gif")>
    <cfset decompressed_letter=Replace(decompressed_letter, "/applicantstatus/counselor/images/foundation_logo.gif", "file:///d:\inetpub\applicantstatus\counselor\images\foundation_logo.gif")>
    <cfset decompressed_letter=Replace(decompressed_letter, "/applicantstatus/admin/images/header2.png", "file:///d:\inetpub\applicantstatus\admin\images\header2.png", "all")>
<cfelseif cgi.server_name neq "glacier.gsu.edu" and cgi.server_name neq "glacierqa.gsu.edu">
    <cfset decompressed_letter=Replace(decompressed_letter, "/applicantstatus/counselor/images/head_logo.gif", "file:///c:\inetpub\wwwroot\applicantstatus\counselor\images\head_logo.gif", "all")>
    <cfset decompressed_letter=Replace(decompressed_letter, "/applicantstatus/counselor/images/foundation_logo.gif", "file:///c:\inetpub\wwwroot\applicantstatus\counselor\images\foundation_logo.gif", "all")>
    <cfset decompressed_letter=Replace(decompressed_letter, "file:///c:\inetpub\wwwroot\applicantstatus\counselor\images\foundation_logo.gif", "file:///d:\inetpub\cf-qa\applicantstatus\counselor\images\foundation_logo.gif", "all")>
     <cfset decompressed_letter=Replace(decompressed_letter, "file:///c:\inetpub\wwwroot\applicantstatus\counselor\images\head_logo.gif", "file:///d:\inetpub\cf-qa\applicantstatus\counselor\images\head_logo.gif", "all")>
     <cfset decompressed_letter=Replace(decompressed_letter, "/applicantstatus/admin/images/header2.png", "file:///d:\inetpub\cf-qa\applicantstatus\admin\images\header2.png", "all")>
</cfif>

<cfoutput><div id="letter">#decompressed_letter#</div></cfoutput>

</cfdocument>