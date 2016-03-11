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
</head>

<body>

 <cfif Session.mobile eq "true">
 	<link href="/applicantstatus/mobilestyles.css" rel="stylesheet" type="text/css" />
    <meta name="HandheldFriendly" content="true" />
	<meta name="viewport" content="width=device-width, height=device-height, user-scalable=no, initial-scale=1" />
    <cfinvoke component="applicantStatus" method="showBanner">
 </cfif>

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
        <cfif scholarship_code eq "OSTWO"><cfset scholfound=true></cfif>
    </cfloop>
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
    	select * from scholarship_forms_archive where panther_id='#NumberFormat(Form.studid, "000000000")#' and scholarship_id is null and form_type=3 and form_code='OSTWO'
    </cfquery>
    <cfif checkForForm.RecordCount gt 0>
		<p>Thank you, you have already agreed to this form.</p>
    <cfelse>
    	<cftransaction>
        <cfquery name="archiveForm" datasource="eAcceptance">
            insert into scholarship_forms_archive (form_id, form_type, form_text, form_date, panther_id, scholarship_id, version_id, student_first_name, student_last_name, form_code, scholarship_code, appterm, student_type) values (scholformsarchive_seq.NEXTVAL, 3, <cfqueryparam cfsqltype="cf_sql_clob" value="#final_text_compressed#">, #NOW()#, '#NumberFormat(Form.studid, "000000000")#', '', #Form.version_id#, '#Form.studfirstname#', '#Form.studlastname#', 'OSTWO', 'OSTWO', '#Form.appterm#', <cfif isDefined("Session.returning_student") and Session.returning_student neq "">'r'<cfelse>''</cfif>)
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
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="scholarship_code" type="in" value="OSTWO"> 
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
<cfset ost_form=Replace('#ost_form#', '[PANTHER NUMBER]', '#studid#', 'ALL')>
<cfset ost_form=Replace('#ost_form#', '[STUDENT NAME]', '#studfirstname# #studlastname#', 'ALL')>


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

<input type="submit" name="submit_form" value="Agree">  <cfif (isDefined("Session.scholarship_letter_id") and Session.scholarship_letter_id neq "") or isDefined("Session.returning_student")><input type="button" onclick="javascript:document.location='viewYourScholarshipLetter.cfm?<cfif isDefined("Session.scholarship_letter_id")>letter_id=#Session.scholarship_letter_id#<cfelse>panid=#URLEncodedFormat(Encrypt(studid, '#Session.campusid##Session.enc_key#'))#</cfif>';" value="Back to Scholarship Letter" /></cfif> <cfif Session.mobile eq "false"><input type="button" onclick="javascript:window.close();" value="Close Window" /></cfif>

<!---<input type="submit" name="submit_form" value="Agree" > <button onclick="javascript:window.close();">Close Window</button>--->
<cfset ost_form=Replace(ost_form, '"', '&quot;', 'all')>
<input type="hidden" name="agreed_form_text" value="#ost_form#<br><table width='100%'><tr><td width='20%'><i>Digitally Signed</i></td><td width='20%'><i>#DateFormat(NOW(), 'mm/dd/yyyy')#</i></td><td width='20%'><i>#studfirstname# #studlastname#</i></td></tr></table>" />
</form>
</cfif>
</cfoutput>
<cfinvoke component="counselor/hsguidance" method="showPageFooter" />
</body>
</html>
