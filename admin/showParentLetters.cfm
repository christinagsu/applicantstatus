<cfapplication name="applicantstatusAppAdmin" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>
<cfif not isDefined("Session.admin_appstatus_user")>
	<p>Sorry, you must be logged in as an administrator to view this page.</p>
    <cfabort>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Admission Letters</title>
</head>

<body>

<cfheader name="Content-Disposition" value="inline; filename=myAdmissionsLetter.pdf">
<cfcontent type="application/pdf">

<cfdocument format="pdf"  marginBottom="0" marginTop="0" marginLeft="0" marginRight="0" pagewidth="8.5" pageheight="11.75" pageType="custom">
<style type="text/css"> 
body{font-family:"Times New Roman", Times, serif; margin: 0px .3in 0px .3in; padding: 0px; font-size:14px;}
#letter p {margin-bottom: 18px; margin-top:0px; line-height:17px; }
#letter br {margin-bottom:0px; margin-top:0px; line-height:13px; }
#letter {margin-top:285px;margin-bottom:0px;}
</style>
<cfquery name="getTemplates" datasource="eAcceptance">
	select unique_id, student_type from sent_templates where sent_template_id=#URL.pdf#
</cfquery>
<cfif getTemplates.student_type lt 200><cfset parentid=5>
<cfelseif getTemplates.student_type lt 400><cfset parentid=205>
<cfelse><cfset parentid=405>
</cfif>
<cfif isDefined("URL.numbatch")>
    <cfquery name="getLetters" datasource="eAcceptance">
        <!---select * from sent_letters where pdf_unique_id='#getTemplates.unique_id#' <cfif isDefined("URL.numbatch")>and rownum >= #int(((URL.numbatch-1)*1000)+1)# and rownum < #int((URL.numbatch*1000)+1)#</cfif> order by letter_order --->
        select * 
        from 
        ( select rownum rnum, a.* 
        from (select * from sent_letters where pdf_unique_id='#getTemplates.unique_id#' order by letter_order) a 
        where rownum < #int((URL.numbatch*1000)+1)# ) 
        where rnum >= #int(((URL.numbatch-1)*1000)+1)#
      <!---because order by breaks rownum--->
    </cfquery>
<cfelse>
	<cfquery name="getLetters" datasource="eAcceptance">
		select * from sent_letters where pdf_unique_id='#getTemplates.unique_id#' order by letter_order
    </cfquery>
</cfif>
<cfquery name="getParentTemplates" datasource="eAcceptance">
	select * from saved_templates where template_type=#parentid# order by template_date desc
</cfquery>
<cfset count=1>
<cfoutput query="getLetters">
	<cfset myObject = createObject( "java", "ZipUtil" )>
	<cfinvoke component="applicantStatusAdmin" method="ReplaceParentFields" original_text="#getParentTemplates.template_text#" returnvariable="parent_letter" letter_info="#getLetters#" lettersetrow="#getLetters.currentrow#" />
    <cfif cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "glacierqa.gsu.edu" or cgi.server_name eq "istcfdev.gsu.edu" or cgi.server_name eq "istcfqa.gsu.edu">
		<cfset parent_letter=Replace('#parent_letter#', '<img src="file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', '<img src="/applicantstatus/admin/images/scott_sig.gif" />', 'ALL')>
      <cfelse>
        <cfset parent_letter=Replace('#parent_letter#', '<img src="file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', '<img src="file:///d:\inetpub\applicantstatus\admin\images\scott_sig.gif" />', 'ALL')>
      </cfif>
	<div id="letter">#parent_letter#</div>
    <cfif count lt #getLetters.RecordCount#><cfdocumentitem type="pagebreak"></cfdocumentitem></cfif>
    <cfset count=count+1>
</cfoutput>
</cfdocument>

</body>
</html>
