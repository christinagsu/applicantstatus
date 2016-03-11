<cfif isDefined("URL.panid")>
<cfapplication name="returningStudentsScholStatus" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>
<cfelse><cfapplication name="applicantstatusApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>
</cfif>

<cfsavecontent variable="acceptedFormPage">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Accepted Form</title>
<style>
 <!---had to be added 4/7/2015 because no space before links---> a {margin-left:2px;}
  <cfif isDefined("URL.scholcode") and Left(URL.scholcode, 3) eq "OST">body {font-family: Arial, Helvetica, sans-serif; margin: 40px;}
  h2 {margin-left:0px;}</cfif>
</style>
</style>
</head>

<body>

<cfif URL.formtype eq 1 or URL.formtype eq 2>
<cfquery name="getAcceptedForm" datasource="eAcceptance">
	select * from scholarship_forms_archive where (form_type=1 or form_type=2) <cfif isDefined("URL.scholid") and URL.scholid neq "" and URL.scholid neq 1345>and scholarship_id='#URL.scholid#'</cfif> <cfif isDefined("URL.scholcode") and URL.scholcode neq "" and URL.scholcode neq "OSTWO">and scholarship_code='#URL.scholcode#'</cfif> and panther_id=#Session.student_id# order by form_date desc, form_type
</cfquery>
<cfelse>
<cfquery name="getAcceptedForm" datasource="eAcceptance">
	select * from scholarship_forms_archive where form_type=#URL.formtype# <cfif isDefined("URL.scholid") and URL.scholid neq "" and URL.scholid neq 1345>and scholarship_id='#URL.scholid#'</cfif> <cfif isDefined("URL.scholcode") and URL.scholcode neq "" and URL.scholcode neq "OSTWO">and scholarship_code='#URL.scholcode#'</cfif> and panther_id=#Session.student_id# order by form_date desc
</cfquery>
</cfif>


<!---<cfdump var="#getAcceptedForm#"><cfoutput>#getAcceptedForm.RecordCount# select * from scholarship_forms_archive where form_type=#URL.formtype# <cfif isDefined("URL.scholid")>and scholarship_id='#URL.scholid#'</cfif> and panther_id=#Session.student_id#</cfoutput>--->

<cfif getAcceptedForm.RecordCount gt 1>
	<!---<cfmail to="christina@gsu.edu" from="christina@gsu.edu" server="mailhost.gsu.edu" subject="Accepted Forms">
    	Showing accepted forms...more than 1 stored
        form type: #URL.formtype#
        scholarship id: #URL.scholid#
        panther id: #Session.student_id#
    </cfmail>--->
</cfif>
<cfoutput>
<cfset myObject = createObject( "java", "ZipUtil" )>
<cfset decompressed_form = myObject.decompress( getAcceptedForm.form_text ) >
<cfif cgi.server_name eq "app.gsu.edu">
<cfset decompressed_form=Replace(decompressed_form, "/applicantstatus/counselor/images/head_logo.gif", "file:///d:\inetpub\applicantstatus\counselor\images\head_logo.gif", "all")>
<cfset decompressed_form=Replace(decompressed_form, "/applicantstatus/counselor/images/foundation_logo.gif", "file:///d:\inetpub\applicantstatus\counselor\images\foundation_logo.gif", "all")>

</cfif>
	#decompressed_form#
</cfoutput>

</body>
</html>
</cfsavecontent>

<cfif Session.mobile eq "false">
	<cfset scale="99">
	<cfif isDefined("URL.formtype") and URL.formtype eq 1><cfset scale="90"></cfif>
   
    	<cfoutput>#acceptedFormPage#</cfoutput>
	<cfif URL.formtype eq 1 or URL.formtype eq 2>
		<cfset tempcount=1>
		<cfoutput query="getAcceptedForm">
			<cfif tempcount eq 2>
				<cfdocumentitem type="pagebreak" />
				<cfset myObject = createObject( "java", "ZipUtil" )>
				<cfset decompressed_form = myObject.decompress( getAcceptedForm.form_text ) >
				<cfif cgi.server_name eq "app.gsu.edu">
					<cfset decompressed_form=Replace(decompressed_form, "/applicantstatus/counselor/images/head_logo.gif", "file:///d:\inetpub\applicantstatus\counselor\images\head_logo.gif", "all")>
					<cfset decompressed_form=Replace(decompressed_form, "/applicantstatus/counselor/images/foundation_logo.gif", "file:///d:\inetpub\applicantstatus\counselor\images\foundation_logo.gif", "all")>
				</cfif>
				#decompressed_form#
			</cfif>
			<cfset tempcount=tempcount+1>
		</cfoutput>
	</cfif>
   
<cfelse>
 	<link href="/applicantstatus/mobilestyles.css" rel="stylesheet" type="text/css" />
    <meta name="HandheldFriendly" content="true" />
	<meta name="viewport" content="width=device-width, height=device-height, user-scalable=no, initial-scale=1" />
    <cfinvoke component="applicantStatus" method="showBanner">
	<cfoutput>#acceptedFormPage#</cfoutput>
</cfif>
<cfinvoke component="counselor/hsguidance" method="showPageFooter" />