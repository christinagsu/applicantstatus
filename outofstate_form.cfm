<cfif isDefined("URL.stud")>
<cfapplication name="applicantstatusAppAdmin" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>
<cfelseif isDefined("URL.panid") or isDefined("Form.returning_student")>
<cfapplication name="returningStudentsScholStatus" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>
<cfelse>
<cfapplication name="applicantstatusApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>
</cfif>
<cfset Session.mobile=false>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Out-of-State Tuition Waiver</title>
<style>
 <!---had to be added 4/7/2015 because no space before links---> a {margin-left:2px;}
 body {font-family: Arial, Helvetica, sans-serif; margin: 40px;}
</style>
</head>

<body>

 <cfif Session.mobile eq "true">
 	<link href="/applicantstatus/mobilestyles.css" rel="stylesheet" type="text/css" />
    <meta name="HandheldFriendly" content="true" />
	<meta name="viewport" content="width=device-width, height=device-height, user-scalable=no, initial-scale=1" />
    <cfinvoke component="applicantStatus" method="showBanner">
 </cfif>

 <table width="100%">
  <Tr><Td><img src="/applicantstatus/admin/images/header2a.png" style="margin-left:20px;" /></Td><td align="right"><img src="/applicantstatus/admin/images/header2b.png" style="margin-right:40px;" /></td></Tr>
 </table>
<cfoutput>
 <cfif isDefined("Session.student_id")>
    	<cfset studid=Session.student_id>
    <cfelseif isDefined("URL.stud")>
    	<cfset studid=URL.stud>
       <cfelse>
       	<cfset studid=Form.studid>
    </cfif>
<cfif not isDefined("agreed_form_text")>
	<cfif isDefined("URL.appterm")>
	 <cfset curappterm=URL.appterm>
	 <cfelse>
	 <cfset curappterm=Form.appterm>
	</cfif>
	<!---below checked for security--->
    <cftry>
      <cfstoredproc  procedure="wwokbapi.f_get_sch_cohort" datasource="hsguidanceoracle">
      <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#studid#"> 
      <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="app_term_code" type="in" value="#curappterm#"> 
      <cfprocresult name="out_result_set_scholtype">
      </cfstoredproc> 
      <cfcatch>
         <cfoutput>11<B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
      </cfcatch>
    </cftry>
    <cfset scholfound=false>
    <cfloop query="out_result_set_scholtype">
      <cfif (isDefined("URL.schol_code") and scholarship_code eq URL.schol_code)>
	  <cfset scholfound=true>
	   <cfset scholtype=scholarship_type>
	    <cfset gpatext=scholarship_gpa_req>
	     <cfset scholarship_name=scholarship_description>
	</cfif>
    </cfloop>
    <cfif scholfound eq false>
     <cfloop query="out_result_set_scholtype">
        <cfif Left(scholarship_code, 3) eq "OST">
	 <cfset scholfound=true>
	   <cfset scholtype=scholarship_type>
	    <cfset gpatext=scholarship_gpa_req>
	     <cfset scholarship_name=scholarship_description>	
	</cfif>
     </cfloop>
    </cfif>
    <cfif scholfound eq false>
        <p>Sorry, you have not been offered this waiver yet.</p>
        <cfabort>
    </cfif>
    <!---done with security--->
</cfif>

<cfif isDefined("Form.submit_form")>
	<cfset myObject = createObject( "java", "ZipUtil" )>
    <cfset final_text_compressed = myObject.compress(Form.agreed_form_text) >
    
    <cfquery name="checkForForm" datasource="eAcceptance">
    	select * from scholarship_forms_archive where panther_id='#NumberFormat(Form.studid, "000000000")#' and scholarship_id is null and form_type=3 and <cfif isDefined("Form.schol_code")>( form_code='#Form.schol_code#' <!---form_code='OSTWO' or form_code='OSTW50' or form_code='OSTWTR'--->)<cfelse>( substr(form_code,0,3)='OST') </cfif> and TO_CHAR(form_date,'YYYY')=#Year(NOW())# 
    </cfquery>
    <cfif checkForForm.RecordCount gt 0>
		<p>Thank you, you have already agreed to this form.</p>
    <cfelse>
       <cfif isDefined("Form.schol_code")>
	 <cfset tempscholcode=#Form.schol_code#>
       <cfelse>
	 <cfset tempscholcode="OSTWO">
       </cfif>
    	<cftransaction>
        <cfquery name="archiveForm" datasource="eAcceptance">
            insert into scholarship_forms_archive (form_id, form_type, form_text, form_date, panther_id, scholarship_id, version_id, student_first_name, student_last_name, form_code, scholarship_code, appterm, student_type) values (scholformsarchive_seq.NEXTVAL, 3, <cfqueryparam cfsqltype="cf_sql_clob" value="#final_text_compressed#">, #NOW()#, '#NumberFormat(Form.studid, "000000000")#', '', #Form.version_id#, '#Form.studfirstname#', '#Form.studlastname#', '#tempscholcode#', '#tempscholcode#', '#Form.appterm#', <cfif isDefined("Session.returning_student") and Session.returning_student neq "">'r'<cfelse>''</cfif>)
        </cfquery>
        <cfquery name="getFormId" datasource="eAcceptance">
        	select max(form_id) as form_id from scholarship_forms_archive 
        </cfquery>
        </cftransaction>
        <!---<cfoutput>#Form.schol_id# #Form.appterm# SRFRM 1 #Form.studid#</cfoutput>--->
         <cftry>
        
              <cfstoredproc  procedure="wwokbupi.p_accept_form" datasource="hsguidanceoracle">
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#studid#"> 
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="term_code" type="in" value="#Form.appterm#"> 
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="scholarship_code" type="in" value="#tempscholcode#"> 
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="form_code" type="in" value="STFRM"> 
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="version_number" type="in" value="#getFormId.form_id#"> 
                <CFPROCPARAM TYPE="out" dbvarname="ERROR_CODE" CFSQLTYPE="cf_sql_integer" variable="error">
                </cfstoredproc> 

              <cfcatch>
                 <cfoutput>11<B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
		 <cfmail
		from="christina@gsu.edu"
		replyto = "christina@gsu.edu"
		to="christina@gsu.edu"
		bcc="christina@gsu.edu"
		subject="eScholarships accept form error"
		SERVER="mailhost.gsu.edu">
		
		#cfcatch.message# -> #cfcatch.detail#
		
		<cfif isDefined("Cookie.campusid")><cfoutput>#Cookie.campusid#</cfoutput></cfif>
		</cfmail>
              </cfcatch>
          </cftry>
        
        <p>Thank you, your agreement has been recorded!</p>
    </cfif>
    <!---<button onclick="javascript:window.close();">Close Window</button>--->
    <cfoutput><cfif (isDefined("Session.scholarship_letter_id") and Session.scholarship_letter_id neq "") or isDefined("Session.returning_student")><button onclick="javascript:document.location='viewYourScholarshipLetter.cfm?<cfif isDefined("Session.scholarship_letter_id")>letter_id=#Session.scholarship_letter_id#<cfelse>panid=#URLEncodedFormat(Encrypt(studid, '#Session.campusid##Session.enc_key#'))#</cfif>';">Back to Scholarship Letter</button></cfif> <cfif Session.mobile eq "false"><button onclick="javascript:window.close();">Close Window</button></cfif></cfoutput>
<cfelse>
<form method="post" action="outofstate_form.cfm" name="out_of_state_waiver">

<cfquery name="getOST" datasource="eAcceptance">
    select * from scholarship_forms where form_type=3 order by form_date desc
</cfquery>
<cfset myObject = createObject( "java", "ZipUtil" )>
<cfset decompressed_form = myObject.decompress(getOST.form_text) >

<cfsavecontent variable="form_content">
<link href="/applicantstatus/admin/tempcss.css" rel="stylesheet" type="text/css" />

<cftry>
		<cfstoredproc  procedure="wwokbapi.f_get_general" datasource="#Session.odatasource#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#studid#"> 
		<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfset studfirstname="#out_result_set.first_name# #out_result_set.mi#">
        <cfset studlastname="#out_result_set.last_name#">
<cfcatch>
    <cfset studfirstname="">
    <cfset studlastname="">
</cfcatch>
</cftry>


<cfset ost_form=Replace('#decompressed_form#', '[DATE]', '#DateFormat(NOW(), 'mm/dd/yyyy')#', 'ALL')>

<cfif scholtype eq "U"><cfset itemtype="UW"><cfelseif scholtype eq "S"><cfset itemtype="SR"></cfif>
     <!---<cfif scholtype eq "U">
         <cfquery name="getItem4Text" datasource="eAcceptance">
            select * from custom_paragraphs where paragraph_type='item4#itemtype#'
         </cfquery>
         <cfset item4text=Replace(getItem4Text.paragraph_text, "<p>", "")>
		 <cfset item4text=Replace(item4text, "</p>", "")>
     <cfelse>--->
     	<cfif isDefined("gpatext")>
	  <cfset item4text=gpatext>
	<cfelse>
	  <cfset item4text="">
	</cfif>
     <!---</cfif>
     <cfset ost_form=#Replace(ost_form, "[ITEM 4]", item4text)#>
     <cfset ost_form=#Replace(ost_form, "[SCHOLARSHIP NAME]", scholarship_name, "all")#>--->



	<cfquery name="getLetter" datasource="eAcceptance">
	select student_type from sent_letters where student_id=#studid# order by letter_date desc
	</cfquery>
	<cfif getLetter.student_type eq 2 or getLetter.student_type eq 206 or getLetter.student_type eq 406>
	 <cfset studtype_sems="T">
	<cfelse>
	 <cfset studtype_sems="F">
	</cfif>
	<cfquery name="getScholSems" datasource="eAcceptance">
	 select * from custom_paragraphs where paragraph_type='scholarship_terms' and student_type='#studtype_sems#'
	</cfquery>
	
<!---</cfif>--->
     <cfset ost_form=#Replace(ost_form, "[ITEM 4]", item4text)#>
     <cfset schol_sems=Replace(getScholSems.paragraph_text, "<p>", "", "all")>
     <cfset schol_sems=Replace(schol_sems, "</p>", "", "all")>
     <cfset ost_form=#Replace(ost_form, "[SCHOLARSHIP SEMESTERS]", schol_sems, "all")#>
     <cfset ost_form=#Replace(ost_form, "[SCHOLARSHIP NAME]", scholarship_name, "all")#>

<cfset ost_form=Replace('#ost_form#', '[PANTHER NUMBER]', '#studid#', 'ALL')>
<cfset ost_form=Replace('#ost_form#', '[STUDENT NAME]', '#studlastname#, #studfirstname# ', 'ALL')>


<cfoutput>#ost_form#</cfoutput>

</cfsavecontent>
<!---<link href="/applicantstatus/admin/tempcss.css" rel="stylesheet" type="text/css" />--->
#ost_form#
<input type="hidden" name="appterm" value="#URL.appterm#" />
<input type="hidden" name="version_id" value="#getOST.form_id#" />
<input type="hidden" name="studid" value="#studid#" />
<input type="hidden" name="studfirstname" value="#studfirstname#" />
<input type="hidden" name="studlastname" value="#studlastname#" />
<cfif isDefined("Session.returning_student")><input type="hidden" name="returning_student" value="true"></cfif>
<cfif isDefined("URL.schol_code")>
 <cfset tempscholcode=URL.schol_code>
 <cfelse>
  <cfset tempscholcode="">
</cfif>
<input type="hidden" name="schol_code" value="#tempscholcode#">


<input type="submit" name="submit_form" value="Agree">  <cfif (isDefined("Session.scholarship_letter_id") and Session.scholarship_letter_id neq "") or isDefined("Session.returning_student")><input type="button" onclick="javascript:document.location='viewYourScholarshipLetter.cfm?<cfif isDefined("Session.scholarship_letter_id")>letter_id=#Session.scholarship_letter_id#<cfelse>panid=#URLEncodedFormat(Encrypt(studid, '#Session.campusid##Session.enc_key#'))#</cfif>';" value="Back to Scholarship Letter" /></cfif> <cfif Session.mobile eq "false"><input type="button" onclick="javascript:window.close();" value="Close Window" /></cfif>

<!---<input type="submit" name="submit_form" value="Agree" > <button onclick="javascript:window.close();">Close Window</button>--->
<cfset ost_form=Replace(ost_form, '"', '&quot;', 'all')>
 <cfif cgi.server_name eq "glacierqa.gsu.edu" or cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "istcfdev.gsu.edu" or cgi.server_name eq "istcfqa.gsu.edu">
    	<!---also doesn't work anymore because of change on server 1/7/2015: <img src="admin/images/header2.png" width="600" />--->
	<cfset tempheader="<img src='/applicantstatus/admin/images/header2.png' width='600' /><br><Br>">
    <cfelseif  cgi.server_name eq "app.gsu.edu">
	<cfset tempheader="<img src='/applicantstatus/admin/images/header2.png' width='600' /><br><Br>">
    <cfelse>
    	<cfset tempheader="<img src='file:///c:\inetpub\wwwroot\applicantstatus\admin\images\header2.png' width='600' />">
    </cfif>
<input type="hidden" name="agreed_form_text" value="#tempheader##ost_form#<br><table width='100%'><tr><td width='20%'><i>Digitally Signed</i></td><td width='20%'><i>#DateFormat(NOW(), 'mm/dd/yyyy')#</i></td><td width='20%'><i>#studfirstname# #studlastname#</i></td></tr></table>" />
</form>
</cfif>
</cfoutput>
<cfinvoke component="counselor/hsguidance" method="showPageFooter" />
</body>
</html>
