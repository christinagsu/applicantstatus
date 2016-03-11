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
<cfif not isDefined("Session.odatasource")><cfset Session.odatasource="hsguidanceoracle"></cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Scholarship/Award/Fellowship Acceptance Form</title>
</head>

<body>
<cfif not isDefined("Session.mobile")><cfset Session.mobile="false"></cfif>
 <cfif Session.mobile eq "true">
 	<link href="/applicantstatus/mobilestyles.css" rel="stylesheet" type="text/css" />
    <meta name="HandheldFriendly" content="true" />
	<meta name="viewport" content="width=device-width, height=device-height, user-scalable=no, initial-scale=1" />
    <cfinvoke component="applicantStatus" method="showBanner">
 </cfif>

<cfoutput>
<!---check permissions--->
<cfif isDefined("URL.schol_id")>
	<cfset schol_id=URL.schol_id>
<cfelse>
	<cfset schol_id=Form.schol_id>
</cfif>
 <cfif isDefined("Session.student_id")>
    	<cfset studid=Session.student_id>
    <cfelseif isDefined("URL.stud")>
    	<cfset studid=URL.stud>
       <cfelseif isDefined("Form.studid")>
       	<cfset studid=Form.studid>
	<cfelseif isDefined("Form.panther_id")>
	<cfset studid=Form.panther_id>
	<cfelseif isDefined("URL.panid")>
	<cfset studid=Decrypt(URL.panid, "#Session.campusid##Session.enc_key#")>
    </cfif>
<cfif isDefined("URL.schol_id")>    
	<!---below, get scholarship type--->
    <cftry>
      <cfstoredproc  procedure="wwokbapi.f_get_sch_cohort" datasource="hsguidanceoracle">
      <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#studid#"> 
      <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="app_term_code" type="in" value="#URL.appterm#"> 
      <cfprocresult name="out_result_set_scholtype">
      </cfstoredproc> 
      <cfcatch>
         <cfoutput>11<B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
      </cfcatch>
    </cftry>
    <cfset scholtype="">
    <cfloop query="out_result_set_scholtype">
        <cfif (scholarship_id eq URL.schol_id and (scholarship_code eq "" or scholarship_code eq URL.schol_code)) or scholarship_code eq URL.schol_code><cfset scholtype=scholarship_type><cfset scholcode=scholarship_code><cfset scholamount=scholarship_amount></cfif>
    </cfloop>
    <cfif scholtype eq "">
        <p>Sorry, you have not been accepted for this scholarship.</p>
        <cfabort>
    </cfif>
    <cfif scholcode eq "KHA">
       <cfif cgi.server_name eq "istcfqa.gsu.edu">
	      <cfset schol_id=5749>
       <cfelse>
	      <cfset schol_id=5818>
       </cfif>
       <cfset awardamount=scholamount>
    </cfif>
    <cfif scholtype eq "S">
        <cfset awardamount=scholamount>
    <cfelse>
        <cfquery name="checkPermissions" datasource="scholarships">
        select * from applications, students where students.student_id=applications.student_id and gsu_student_id=#studid# <cfif isDefined("schol_id") and schol_id neq "">and scholarship_id=#schol_id#</cfif> and awarded='y'
        </cfquery>
        <cfquery name="getScholInfo" datasource="scholarships">
        select * from scholarships where scholarship_id=#schol_id#
        </cfquery>
	<cfset schol_exception=false>
	<cfif (scholcode eq "KHA")><cfset schol_exception=true></cfif>
	<cfif schol_exception eq false>
	      <cfif checkPermissions.RecordCount eq 0>
	      <p>You have not been awarded this scholarship yet.  If you have questions about the scholarship, please contact the Scholarship Office<!---<cfif getScholInfo.contact_name eq ""><a href="mailto:gchisholm@gsu.edu">Greg Chisholm</a><cfelse><cfif getScholInfo.contact_email neq ""><a href="mailto:#getScholInfo.contact_email#"></cfif>#getScholInfo.contact_name#</a></cfif>--->.
	      <cfexit>
	      </cfif>
	      <cfset awardamount=checkPermissions.AWARD_AMOUNT>
	</cfif>
    </cfif>
</cfif>

<cfif isDefined("Form.submit_form")>
	<cfset myObject = createObject( "java", "ZipUtil" )>
    <cfset final_text_compressed = myObject.compress(Form.agreed_form_text) >
    
    <cfquery name="checkForForm" datasource="eAcceptance">
    	select * from scholarship_forms_archive where panther_id='#NumberFormat(Form.studid, "000000000")#' <cfif Form.schol_id neq "">and scholarship_id='#Form.schol_id#'</cfif> <cfif isDefined("Form.schol_code") and Form.schol_code neq "">and scholarship_code='#Form.schol_code#'</cfif> and form_type=1 and TO_CHAR(form_date,'YYYY')=#Year(NOW())#
    </cfquery>
    <cfif checkForForm.RecordCount gt 0>
		<p>Thank you, you have already agreed to this form.</p>
    <cfelse>
    	<cftransaction>
        <cfquery name="archiveForm" datasource="eAcceptance">
            insert into scholarship_forms_archive (form_id, form_type, form_text, form_date, panther_id, scholarship_id, version_id, student_first_name, student_last_name, scholarship_code, appterm, student_type) values (scholformsarchive_seq.NEXTVAL, 1, <cfqueryparam cfsqltype="cf_sql_clob" value="#final_text_compressed#">, #NOW()#, '#NumberFormat(Form.studid, "000000000")#', '#Form.schol_id#', #Form.version_id#, '#Form.studfirstname#', '#Form.studlastname#', '#Form.schol_code#', '#Form.appterm#', <cfif isDefined("Session.returning_student") and Session.returning_student neq "">'r'<cfelse>''</cfif>)
        </cfquery>
        <cfquery name="getFormId" datasource="eAcceptance">
        	select max(form_id) as form_id from scholarship_forms_archive 
        </cfquery>
        </cftransaction>
        <!---<cfoutput>#Form.schol_id# #Form.appterm# SRFRM 1 #Form.studid#</cfoutput>--->
	<cfif isDefined("Session.student_id") and Session.student_id neq "">
	 <cfset sign_studid=NumberFormat(Session.student_id, "000000000")>
	<cfelse>
	 <cfset sign_studid=NumberFormat(Form.studid, "000000000")>
	</cfif>
         <cftry>
        
              <cfstoredproc  procedure="wwokbupi.p_accept_form" datasource="hsguidanceoracle">
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#sign_studid#"> 
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="term_code" type="in" value="#Form.appterm#"> 
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="scholarship_code" type="in" value="#Form.schol_code#"> 
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="form_code" type="in" value="SRFRM"> 
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
    <cfoutput><cfif (isDefined("Session.scholarship_letter_id") and Session.scholarship_letter_id neq "") or isDefined("Session.returning_student")><button onclick="javascript:document.location='viewYourScholarshipLetter.cfm?<cfif isDefined("Session.scholarship_letter_id")>letter_id=#Session.scholarship_letter_id#<cfelse>panid=#URLEncodedFormat(Encrypt(Session.STUDENT_ID, '#Session.campusid##Session.enc_key#'))#</cfif>';">Back to Scholarship Letter</button></cfif> <cfif Session.mobile eq "false"><button onclick="javascript:window.close();">Close Window</button></cfif></cfoutput>
<cfelse>
<form method="post" action="acceptance_form.cfm" name="scholarship_acceptance">

<cfsavecontent variable="form_content">
<link href="/applicantstatus/admin/tempcss.css" rel="stylesheet" type="text/css" />
<table  width="100%"><tr><td><img src="/applicantstatus/counselor/images/foundation_logo.gif" /></td><td align="right"><b>GEORGIA STATE UNIVERSITY FOUNDATION<br />Scholarship/Award/Fellowship Acceptance Form</b></td></tr></table>
<!---<div width="100%" align="center"><i>This form must be submitted as an attachment to a <b>Foundation Scholarship/Award/Fellowship Request</b>.</i></div><br />--->
<!---<cfset lettercount=len(getStudentInfo.student_id)>
<cfset studentid=getStudentInfo.student_id>
<cfloop from="1" to="#NumberFormat(9-lettercount)#" index="i">
<cfset studentid="0"&studentid>
</cfloop>--->
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
<cfinvoke component="counselor/hsguidance" method="getAddress" studid="#studid#" addresstype="MA" returnvariable="address" />
<cfinvoke component="counselor/hsguidance" method="getEmail" studid="#studid#" type="GSU" returnvariable="email" />
<cftry>
  <cfstoredproc  procedure="wwokbapi.f_get_sch_cohort" datasource="hsguidanceoracle">
  <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#studid#"> 
  <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="app_term_code" type="in" value="#URL.appterm#"> 
  <cfprocresult name="out_result_set_cohort">
  </cfstoredproc> 
  <cfcatch>
    err
  </cfcatch>
</cftry>
<!---<cfdump var="#out_result_set_cohort#">--->
<cfloop query="out_result_set_cohort">
	<cfif scholarship_id eq URL.schol_id and (scholarship_code eq "" or scholarship_code eq URL.schol_code)>
    	<cfset curprojectid="#project_id#">
	<cfif not isDefined("curprojectid") or curprojectid eq ""><cfset curprojectid="To be Determined"></cfif>
        <cfset curscholtype=scholarship_type>
        <cfset curtitle=scholarship_description>
	 <cfset curscholamount=scholarship_amount>
     
        <cfif scholarship_type eq "S">
        	<cfquery name="getStudentAppInfo" datasource="scholarships">
            select * from contact_info
            </cfquery>
        <cfelse>
        	<cfquery name="getStudentAppInfo" datasource="scholarships">
            select * from applications, students where students.student_id=applications.student_id and gsu_student_id=#studid# <cfif schol_exception eq true and isDefined("schol_id") and schol_id neq "">and scholarship_id=#schol_id#<cfelse>and scholarship_id=#URL.schol_id#</cfif> order by application_start_date desc
            </cfquery>
        </cfif>
    </cfif>
</cfloop>
<table cellpadding="0" width="100%" border="1" bordercolor="##000000" cellspacing="0">
	<tr><td rowspan="2" valign="top" width="50%"><b>Recipient's name & remittance/home address</b><br />#studfirstname# #studlastname#<br />#address#</td><td valign="top"><b>Recipient's current e-mail address:</b><br />#email#</td></tr><tr><td><b>Recipient's Panther ID##</b><br />#studid#</td></tr>
</table><br />
<table cellpadding="0" width="100%" border="1" bordercolor="##000000" cellspacing="0">
	<tr><td width="30%"><b>Awarding unit's name</b><cfif isDefined("getStudentAppInfo.awarding_unit")><br />#getStudentAppInfo.awarding_unit#&nbsp;</cfif></td><td colspan="2" valign="top" width="60%"><b>Contact university P O Box</b><br /><cfif curscholtype eq "S">#getStudentAppInfo.po_box#<cfelseif isDefined("getScholInfo.po_box")>#getScholInfo.pobox#</cfif></td></tr>
    <tr><td cellpadding="0"><b>Awarding unit's contact person</b><br /><cfif curscholtype eq "S">#getStudentAppInfo.contact_person#<cfelseif isDefined("getScholInfo.contact_name")>#getScholInfo.contact_name#</cfif></td><td width="30%"><b>Contact e-mail:</b><br /><cfif curscholtype eq "S">#getStudentAppInfo.contact_email#<cfelseif isDefined("getScholInfo.contact_email")>#getScholInfo.contact_email#</cfif></td><td width="30%"><b>Contact telephone:</b><br /><cfif curscholtype eq "S">#getStudentAppInfo.contact_phone#<cfelseif isDefined("getScholInfo.contact_phone")>#getScholInfo.contact_phone#</cfif></td></tr>
    <tr><td valign="top" nowrap><b>Name of Scholarship/award/fellowship:</b><br /><cfif isDefined("curtitle")>#curtitle#</cfif></td><td><b>Scholarship/Award/Fellowship project ID:</b><br /><cfif isDefined("curprojectid")>#curprojectid#</cfif></td>
     <td><b>Award Amount</b><br><cfif curscholtype eq "U" and schol_exception eq false> 
         <cfif (getStudentAppInfo.award_amount eq "" or getStudentAppInfo.award_amount eq "TBD")>
	   To be Determined
	   <cfelse>
	   #NumberFormat(getStudentAppInfo.award_amount, "$_,___.__")#
	 </cfif>
     <cfelse>

         <cfif curscholamount eq "" or curscholamount eq "TBD">
         	To be Determined
		 <cfelseif isNumeric(scholamount)>
		  #NumberFormat(scholamount, "$_,___.__")#
		  <cfelse>
		  #scholamount#
         </cfif>
     </cfif></td></tr>
</table>
    <!---<tr><td valign="top"><b>Authorizing office (dean or vice president, for example)</b><br /><cfif curscholtype neq "S">#getStudentAppInfo.authorizing_office#</cfif></td></tr>--->
    

    
</table>

<cfquery name="getScholarshipRules" datasource="eAcceptance">
    select form_text, form_id from scholarship_forms where form_type=1 order by form_date desc
</cfquery>
<cfset myObject = createObject( "java", "ZipUtil" )>
<cfset form_text = myObject.decompress(getScholarshipRules.form_text) >
<cfif scholtype eq "U">
 <cfset form_text=#Replace(form_text, "[SCHOLARSHIP COORDINATOR NAME]", #getScholInfo.contact_name#, "all")#>
 <cfset form_text=#Replace(form_text, "[SCHOLARSHIP COORDINATOR EMAIL]", #getScholInfo.contact_email#, "all")#>
  <cfif getScholInfo.college eq "">
       <cfquery name="getCollege" datasource="scholarships">
	     select * from scholarships_colleges where scholarship_id=#schol_id#
       </cfquery>
       <cfset getScholInfo.college=getCollege.college_id>
</cfif>
 <cfquery name="getCollege" datasource="scholarships">
	select * from colleges where college_id=#getScholInfo.college#
 </cfquery>
 <cfset college=getCollege.college>
 <cfset form_text=#Replace(form_text, "[AWARDING UNIT]", #college#, "all")#>
<cfelse>
 <cfset form_text=#Replace(form_text, "[SCHOLARSHIP COORDINATOR NAME]", #getStudentAppInfo.contact_person#, "all")#>
 <cfset form_text=#Replace(form_text, "[SCHOLARSHIP COORDINATOR EMAIL]", #getStudentAppInfo.contact_email#, "all")#>
 <cfset form_text=#Replace(form_text, "[AWARDING UNIT]", #getStudentAppInfo.awarding_unit#, "all")#>
</cfif>
<cfoutput>#form_text#</cfoutput>

<!---<p>By signing this form, you agree to the terms of this offer of scholarship/award/fellowship. </p>
<ol style="margin-left:15px;">
<li>I understand that I have tentatively been awarded a foundation scholarship/award/fellowship. I understand that if my scholarship/award/fellowship becomes final, I will receive a confirmation letter from the foundation. I also understand that if there are issues with my scholarship/award/fellowship that I will be contacted by a representative of the awarding unit. </li>
<li>I understand that the amount of financial aid that I am eligible for is based on my enrollment status, classification (undergraduate or graduate), residency, housing arrangements and aid received from other sources. I promise to notify the Office of Student Financial Aid of any corrections or changes to my information to prevent incorrect disbursements of your aid.</li>
<li>I authorize release of an official transcript of my academic record to the awarding unit specified above and to the foundation for purpose of determining eligibility for the above specified scholarship/ award/fellowships. </li>
<li>I hereby authorize the university to release "directory information" as defined by the University FERPA Records Access Policy such as student name, city, state and country of residence (both local and permanent), age and place of birth, major field of study, full or part-time status, participation in officially recognized activities and sports, degrees and awards applied for and/or received, dates of attendance, previous educational institutions attended and, with respect to members of athletic teams, age, hometown, hobbies, and general items of interest to the foundation to be shared with the donor of my scholarship. </li>
<li>I agree to the university and the foundation releasing and using information about me and my photograph for publications and promotional and marketing purposes. </li>
<li>I agree to participate in scholarship recipient activities, including the annual scholarship luncheon. </li>
<li>I promise to write, under supervision of foundation representatives and staff, thank-you letter(s) to the donor(s) of my scholarship/award/fellowship. </li>
<li><b><u>For foreign nationals.</u></b> To avoid delay in processing scholarship payments, foreign nationals should complete the tax information on the Glacier System.  The GSU Tax Accountant must complete an analysis before the scholarship can be disbursed.  The tax accountant may contact the student if additional student information is needed.<br />---><br />

<!---<div id="release" width="10px"><h3>Residency Status</h3>Is the student a US citizen or Permanent Resident Alien (Green Card Holder)? <input name="citizen_status" type="radio" /> Yes <input name="citizen_status" type="radio" />No</div>--->
Under penalties of perjury, I certify that the above statements are true and accurate. </li>
</ol><br />
</cfsavecontent>
#form_content#
<input type="hidden" name="appterm" value="#URL.appterm#" />
<input type="hidden" name="version_id" value="#getScholarshipRules.form_id#" />
<input type="hidden" name="schol_id" value="#URL.schol_id#" />
<input type="hidden" name="schol_code" value="#scholcode#" />
<input type="hidden" name="studid" value="#studid#" />
<input type="hidden" name="studfirstname" value="#studfirstname#" />
<input type="hidden" name="studlastname" value="#studlastname#" />
<cfif isDefined("Session.returning_student")><input type="hidden" name="returning_student" value="true"></cfif>

<input type="submit" name="submit_form" value="Agree">  <cfif isDefined("Session.scholarship_letter_id") and Session.scholarship_letter_id neq ""><input type="button" onclick="javascript:document.location='viewYourScholarshipLetter.cfm?letter_id=#Session.scholarship_letter_id#';" value="Back to Scholarship Letter" /></cfif> <cfif Session.mobile eq "false"><input type="button" onclick="javascript:window.close();" value="Close Window" /></cfif>

<!---<input type="submit" name="submit_form" value="Agree"> <button onclick="javascript:window.close();">Close Window</button>--->
<cfset form_content=Replace(form_content, '"', '&quot;', 'all')>
<input type="hidden" name="agreed_form_text" value="#form_content#<br><table width='100%'><tr><td width='20%'><i>Digitally Signed</i></td><td width='20%'><i>#DateFormat(NOW(), 'mm/dd/yyyy')#</i></td><td width='20%'><i>#studfirstname# #studlastname#</i></td></tr></table>" />
</form>
</cfif>
</cfoutput>
<cfif not isDefined("Form.submit_form")><cfinvoke component="counselor/hsguidance" method="showPageFooter" /></cfif>
</body>
</html>
