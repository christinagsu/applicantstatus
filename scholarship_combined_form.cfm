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
<title>Scholarship Form</title>
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
         11<B>#cfcatch.message# -> #cfcatch.detail#</B>
      </cfcatch>
    </cftry>
    <cfset scholtype="">
    <cfloop query="out_result_set_scholtype">
        <cfif scholarship_id eq URL.schol_id and (scholarship_code eq "" or scholarship_code eq URL.schol_code)><cfset scholtype=scholarship_type><cfset scholcode=scholarship_code><cfset scholamount=scholarship_amount><cfif isDefined("project_id")><cfset scholprojid=project_id></cfif><cfif isDefined("scholarship_description")><cfset scholdesc=scholarship_description></cfif><cfif isDefined("scholarship_gpa_req")><cfset gpatext=scholarship_gpa_req></cfif></cfif>
    </cfloop>
    <cfif scholtype eq "">
        <p>Sorry, you have not been accepted for this scholarship.</p>
        <cfabort>
    </cfif>
    <cfif scholtype eq "S">
        <cfset awardamount=scholamount>
    <cfelse>
        <cfquery name="checkPermissions" datasource="scholarships">
        select * from applications, students where students.student_id=applications.student_id and gsu_student_id=#studid# and scholarship_id=#schol_id# and awarded='y' order by application_start_date desc
        </cfquery>
        <cfquery name="getScholInfo" datasource="scholarships">
        select * from scholarships where scholarship_id=#schol_id#
        </cfquery>
	<cfquery name="GetCollInfo" datasource="scholarships">
	      select * from scholarships_colleges where scholarship_id=#schol_id#
	</cfquery>
        <cfif isDefined("checkPermissions") and checkPermissions.RecordCount eq 0>
        <p>You have not been awarded this scholarship yet.  If you have questions about the scholarship, please contact the Scholarship Office<!---<cfif getScholInfo.contact_name eq ""><a href="mailto:gchisholm@gsu.edu">Greg Chisholm</a><cfelse><cfif getScholInfo.contact_email neq ""><a href="mailto:#getScholInfo.contact_email#"></cfif>#getScholInfo.contact_name#</a></cfif>--->.
        <cfexit>
        </cfif>
        <cfset awardamount=checkPermissions.AWARD_AMOUNT>
    </cfif>
</cfif>

<cfif isDefined("Form.submit_form")>
	<cfset myObject = createObject( "java", "ZipUtil" )>
    <!--- <cfset final_text_compressed = myObject.compress(Form.agreed_form_text) > --->
    <cfset final_text_compressed_scholarshiprules = myObject.compress(Form.agreed_scholarshiprulesform_text) >
    <cfset final_text_compressed_acceptance = myObject.compress(Form.agreed_acceptanceform_text) >
    
    <cfquery name="checkForForm" datasource="eAcceptance">
    	select * from scholarship_forms_archive where panther_id='#NumberFormat(Form.studid, "000000000")#' <cfif Form.schol_id neq "">and scholarship_id='#Form.schol_id#'</cfif> <cfif isDefined("Form.schol_code") and Form.schol_code neq "">and scholarship_code='#Form.schol_code#'</cfif> and form_type=1 and TO_CHAR(form_date,'YYYY')=#Year(NOW())#
    </cfquery>
    <cfif checkForForm.RecordCount gt 0>
		<p>Thank you, you have already agreed to this form.</p>
    <cfelse>
    	<cftransaction>
        <cfquery name="archiveForm" datasource="eAcceptance">
            insert into scholarship_forms_archive (form_id, form_type, form_text, form_date, panther_id, scholarship_id, version_id, student_first_name, student_last_name, scholarship_code, appterm, student_type) values (scholformsarchive_seq.NEXTVAL, 1, <cfqueryparam cfsqltype="cf_sql_clob" value="#final_text_compressed_acceptance#">, #NOW()#, '#NumberFormat(Form.studid, "000000000")#', '#Form.schol_id#', #Form.version_id#, '#Form.studfirstname#', '#Form.studlastname#', '#Form.schol_code#', '#Form.appterm#', <cfif isDefined("Session.returning_student") and Session.returning_student neq "">'r'<cfelse>''</cfif>)
        </cfquery>
        <cfquery name="getFormId_acceptance" datasource="eAcceptance">
        	select max(form_id) as form_id from scholarship_forms_archive 
        </cfquery>
        </cftransaction>
        <cftransaction>
         <cfquery name="archiveForm" datasource="eAcceptance">
            insert into scholarship_forms_archive (form_id, form_type, form_text, form_date, panther_id, scholarship_id, version_id, student_first_name, student_last_name, scholarship_code, appterm, student_type) values (scholformsarchive_seq.NEXTVAL, 2, <cfqueryparam cfsqltype="cf_sql_clob" value="#final_text_compressed_scholarshiprules#">, #NOW()#, '#NumberFormat(Form.studid, "000000000")#', '#Form.schol_id#', #Form.version_id#, '#Form.studfirstname#', '#Form.studlastname#', '#Form.schol_code#', '#Form.appterm#', <cfif isDefined("Session.returning_student") and Session.returning_student neq "">'r'<cfelse>''</cfif>)
        </cfquery>
        <cfquery name="getFormId_scholrules" datasource="eAcceptance">
        	select max(form_id) as form_id from scholarship_forms_archive 
        </cfquery>
        </cftransaction>
        <!---#Form.schol_id# #Form.appterm# SRFRM 1 #Form.studid#--->
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
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="form_code" type="in" value="SGFRM"> 
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="version_number" type="in" value="#getFormId_scholrules.form_id#"> 
                <CFPROCPARAM TYPE="out" dbvarname="ERROR_CODE" CFSQLTYPE="cf_sql_integer" variable="error">
                </cfstoredproc>
              
               <cfstoredproc  procedure="wwokbupi.p_accept_form" datasource="hsguidanceoracle">
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#sign_studid#"> 
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="term_code" type="in" value="#Form.appterm#"> 
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="scholarship_code" type="in" value="#Form.schol_code#"> 
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="form_code" type="in" value="SRFRM"> 
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="version_number" type="in" value="#getFormId_acceptance.form_id#"> 
                <CFPROCPARAM TYPE="out" dbvarname="ERROR_CODE" CFSQLTYPE="cf_sql_integer" variable="error">
                </cfstoredproc> 

              <cfcatch>
                 11<B>#cfcatch.message# -> #cfcatch.detail#</B>
		 <cfmail
		from="christina@gsu.edu"
		replyto = "christina@gsu.edu"
		to="christina@gsu.edu"
		bcc="christina@gsu.edu"
		subject="eScholarships accept form error"
		SERVER="mailhost.gsu.edu">
		
		#cfcatch.message# -> #cfcatch.detail#
		
		<cfif isDefined("Cookie.campusid")>#Cookie.campusid#</cfif>
		</cfmail>
              </cfcatch>
          </cftry>
        
        <p>Thank you, your agreement has been recorded!</p>
    </cfif>
    <!---<button onclick="javascript:window.close();">Close Window</button>--->
    <cfif (isDefined("Session.scholarship_letter_id") and Session.scholarship_letter_id neq "") or isDefined("Session.returning_student")><button onclick="javascript:document.location='viewYourScholarshipLetter.cfm?<cfif isDefined("Session.scholarship_letter_id")>letter_id=#Session.scholarship_letter_id#<cfelse>panid=#URLEncodedFormat(Encrypt(Session.STUDENT_ID, '#Session.campusid##Session.enc_key#'))#</cfif>';">Back to Scholarship Letter</button></cfif> <cfif Session.mobile eq "false"><button onclick="javascript:window.close();">Close Window</button></cfif>
<cfelse>
<form method="post" action="scholarship_combined_form.cfm" name="scholarship_acceptance">

<cfsavecontent variable="acceptance_form_content">
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
     
     <cfquery name="getCodes" datasource="scholarships">
			select * from awardingunit_scholcode where scholarship_code='#URL.schol_code#'
		</cfquery>
      <!---<cfmail
		from="christina@gsu.edu"
		replyto = "christina@gsu.edu"
		to="christina@gsu.edu"
		bcc="christina@gsu.edu"
		subject="eScholarships test"
		SERVER="mailhost.gsu.edu">
		
		select * from awardingunit_scholcode where scholarship_code='#trim(URL.schol_code)#'
		
		<cfif isDefined("Cookie.campusid")>#Cookie.campusid#</cfif>
		</cfmail>--->
     <cfif getCodes.RecordCount gt 0 and getCodes.awarding_unit neq "">
        	<cfquery name="getContactInfo" datasource="scholarships">
            select * from contact_info where contact_unit='#Trim(getCodes.awarding_unit)#'
            </cfquery>
     <cfelse>
       <cfquery name="getContactInfo" datasource="scholarships">
            select * from contact_info where contact_unit='AD'
            </cfquery>
     </cfif>
        <cfif scholarship_type eq "S">
        	 <cfset getStudentAppInfo=getContactInfo>
        <cfelse>
        	<cfquery name="getStudentAppInfo" datasource="scholarships">
            select * from applications, students where students.student_id=applications.student_id and gsu_student_id=#studid# and scholarship_id=#URL.schol_id# order by application_start_date desc
            </cfquery>
		<cfset getContactInfo=getStudentAppInfo>
        </cfif>
    </cfif>
</cfloop>
<table cellpadding="0" width="100%" border="1" bordercolor="##000000" cellspacing="0">
	<tr><td rowspan="2" valign="top" width="50%"><b>Recipient's name & remittance/home address</b><br />#studfirstname# #studlastname#<br />#address#</td><td valign="top"><b>Recipient's current e-mail address:</b><br />#email#</td></tr><tr><td><b>Recipient's Panther ID##</b><br />#studid#</td></tr>
</table><br />
<table cellpadding="0" width="100%" border="1" bordercolor="##000000" cellspacing="0">
	<tr><td width="30%"><b>Awarding unit's name</b><br><cfif isDefined("getContactInfo.awarding_unit")>#getContactInfo.awarding_unit#&nbsp;</cfif></td><td colspan="2" valign="top" width="60%"><b>Contact university P O Box</b><br /><!---<cfif curscholtype eq "S">#getStudentAppInfo.po_box#---><cfif isDefined("getContactInfo.po_box")>#getContactInfo.po_box#</cfif></td></tr>
    <tr><td cellpadding="0"><b>Awarding unit's contact person</b><br /><!---<cfif curscholtype eq "S">#getStudentAppInfo.contact_person#---><cfif isDefined("getContactInfo.contact_person")>#getContactInfo.contact_person#</cfif></td><td width="30%"><b>Contact e-mail:</b><br /><!---<cfif curscholtype eq "S">#getStudentAppInfo.contact_email#---><cfif isDefined("getContactInfo.contact_email")>#getContactInfo.contact_email#</cfif></td><td width="30%"><b>Contact telephone:</b><br /><!---<cfif curscholtype eq "S">#getStudentAppInfo.contact_phone#---><cfif isDefined("getContactInfo.contact_phone")>#getContactInfo.contact_phone#</cfif></td></tr>
	<!---<tr><td width="30%"><b>Awarding unit's name</b><cfif isDefined("getStudentAppInfo.awarding_unit")><br />#getStudentAppInfo.awarding_unit#&nbsp;</cfif></td><td colspan="2" valign="top" width="60%"><b>Contact university P O Box</b><br /><cfif curscholtype eq "S">#getStudentAppInfo.po_box#<cfelseif isDefined("getScholInfo.po_box")>#getScholInfo.pobox#</cfif></td></tr>
    <tr><td cellpadding="0"><b>Awarding unit's contact person</b><br /><cfif curscholtype eq "S">#getStudentAppInfo.contact_person#<cfelseif isDefined("getScholInfo.contact_name")>#getScholInfo.contact_name#</cfif></td><td width="30%"><b>Contact e-mail:</b><br /><cfif curscholtype eq "S">#getStudentAppInfo.contact_email#<cfelseif isDefined("getScholInfo.contact_email")>#getScholInfo.contact_email#</cfif></td><td width="30%"><b>Contact telephone:</b><br /><cfif curscholtype eq "S">#getStudentAppInfo.contact_phone#<cfelseif isDefined("getScholInfo.contact_phone")>#getScholInfo.contact_phone#</cfif></td></tr>--->
    <tr><td valign="top" nowrap><b>Name of Scholarship/award/fellowship:</b><br /><cfif isDefined("curtitle")>#curtitle#</cfif></td><td><b>Scholarship/Award/Fellowship project ID:</b><br /><cfif isDefined("curprojectid")>#curprojectid#</cfif></td>
     <td><b>Yearly Award Amount</b><br><cfif curscholtype eq "U"> 
         <cfif getStudentAppInfo.award_amount eq "" or getStudentAppInfo.award_amount eq "TBD">
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
 <cfquery name="getCollege" datasource="scholarships">
	select * from colleges where college_id=#GetCollInfo.college_id#
 </cfquery>
 <cfset college=getCollege.college>
 <cfset form_text=#Replace(form_text, "[AWARDING UNIT]", #college#, "all")#>
<cfelse>
 <cfset form_text=#Replace(form_text, "[SCHOLARSHIP COORDINATOR NAME]", #getStudentAppInfo.contact_person#, "all")#>
 <cfset form_text=#Replace(form_text, "[SCHOLARSHIP COORDINATOR EMAIL]", #getStudentAppInfo.contact_email#, "all")#>
 <cfset form_text=#Replace(form_text, "[AWARDING UNIT]", #getStudentAppInfo.awarding_unit#, "all")#>
</cfif>
#form_text#

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


<cfsavecontent variable = "scholarshiprules_form_content">

    <!---<cfset lettercount=len(getStudentInfo.student_id)>
    <cfset studentid=getStudentInfo.student_id>
    <cfloop from="1" to="#NumberFormat(9-lettercount)#" index="i">
    <cfset studentid="0"&studentid>
    </cfloop>--->
    <!---<cfif isDefined("Session.student_id")>
    	<cfset studid=Session.student_id>
    <cfelse>
    	<cfset studid=URL.stud>
    </cfif>--->
    <cfif isDefined("scholtype") and scholtype eq "U">
        <cfquery name="getStudentAppInfo" datasource="scholarships">
        select * from applications, students where students.student_id=applications.student_id and gsu_student_id=#studid# and scholarship_id=#URL.schol_id# order by application_start_date desc
        </cfquery>
    </cfif>
    
    <div width="100%" align="right"><img src="/applicantstatus/counselor/images/head_logo.gif" /></div>
    <cfoutput>
    <cftry>
		<cfstoredproc  procedure="wwokbapi.f_get_general" datasource="#Session.odatasource#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#studid#"> 
		<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfset studfirstname="#out_result_set.first_name# #out_result_set.mi#">
        <cfset studlastname="#out_result_set.last_name#">
        <cfset studpantherid="#studid#">
    <cfcatch>
        <cfset studfirstname="">
        <cfset studlastname="">
        <cfset studpantherid="">
    </cfcatch>
    </cftry>
    <cfif isDefined("scholtype") and scholtype eq "U">
		<cfif isDefined("getScholInfo") and getScholInfo.RecordCount eq 0>
            <p>This scholarship does not exist.  Please click on the link again.</p>
            <cfexit>
        <cfelseif getStudentAppInfo.award_amount eq "">
            <p>Your award amount has not been recorded.  Please click on this link again later.</p>
            <cfexit>
        </cfif>
    </cfif>
    <cfquery name="getScholarshipRules" datasource="eAcceptance">
    	select form_text, form_id from scholarship_forms where form_type=2 order by form_date desc
    </cfquery>
    <cfset myObject = createObject( "java", "ZipUtil" )>
	<cfset form_text = myObject.decompress(getScholarshipRules.form_text) >
    <cfif isDefined("scholtype") and scholtype eq "U"> 
		 <cfset form_text=#Replace(form_text, "[SCHOLARSHIP NAME]", getScholInfo.title, "all")#>
         <cfset form_text=#Replace(form_text, "[CURRENT YEAR]", DateFormat(NOW(),"yyyy"))#>
	 <cfif not isDefined("getStudentAppInfo.semester_award_amount")><cfset semaward=(getStudentAppInfo.award_amount/2)>
	 <cfelse><cfset semaward=getStudentAppInfo.semester_award_amount>
	 </cfif>
         <cfset form_text=#Replace(form_text, "[SEMESTER PAYMENTS]", NumberFormat(semaward, "$_,___.__"), "all")#>
         <cfset form_text=#Replace(form_text, "[YEARLY PAYMENTS]", NumberFormat(getStudentAppInfo.award_amount, "$_,___.__"), "all")#>
	 <cfset form_text=#Replace(form_text, "[SCHOLARSHIP COORDINATOR NAME]", #getScholInfo.contact_name#, "all")#>
	 <cfset form_text=#Replace(form_text, "[SCHOLARSHIP COORDINATOR EMAIL]", #getScholInfo.contact_email#, "all")#>
	 <cfquery name="getCollege" datasource="scholarships">
		select * from colleges where college_id in (#getCollInfo.college_id#)
	 </cfquery>
	 <cfset college=getCollege.college>
	 <cfset form_text=#Replace(form_text, "[AWARDING UNIT]", #college#, "all")#>
     <cfelse>
     	<cfset form_text=#Replace(form_text, "[SCHOLARSHIP NAME]", scholdesc, "all")#>
         <cfset form_text=#Replace(form_text, "[CURRENT YEAR]", DateFormat(NOW(),"yyyy"))#>
         <cfif scholamount eq "">
		 	<cfset form_text=#Replace(form_text, "[SEMESTER PAYMENTS]", "N/A", "all")#>
         	<cfset form_text=#Replace(form_text, "[YEARLY PAYMENTS]", "N/A", "all")#>
		 <cfelse>
			 <cfset form_text=#Replace(form_text, "[SEMESTER PAYMENTS]", NumberFormat((scholamount/2), "$_,___.__"), "all")#>
             <cfset form_text=#Replace(form_text, "[YEARLY PAYMENTS]", NumberFormat(scholamount, "$_,___.__"), "all")#>
         </cfif>
	 <!--- this is commented out to get the contact information from above (the new way)<cfquery name="getContactInfo" datasource="scholarships">
		select * from contact_info
	 </cfquery>--->
	 <cfset form_text=#Replace(form_text, "[SCHOLARSHIP COORDINATOR NAME]", #getContactInfo.contact_person#, "all")#>
	 <cfset form_text=#Replace(form_text, "[SCHOLARSHIP COORDINATOR EMAIL]", #getContactInfo.contact_email#, "all")#>
	 <cfset form_text=#Replace(form_text, "[AWARDING UNIT]", #getContactInfo.awarding_unit#, "all")#>
     </cfif>
     <cfif scholtype eq "U"><cfset itemtype="UW"><cfelseif scholtype eq "S"><cfset itemtype="SR"></cfif>
     <cfif scholtype eq "U">
         <cfquery name="getItem4Text" datasource="eAcceptance">
            select * from custom_paragraphs where paragraph_type='item4#itemtype#'
         </cfquery>
         <cfset item4text=Replace(getItem4Text.paragraph_text, "<p>", "")>
		 <cfset item4text=Replace(item4text, "</p>", "")>
     <cfelse>
     	<cfset item4text=gpatext>
     </cfif>
     <cfset form_text=#Replace(form_text, "[ITEM 4]", item4text)#>
   	 <cfset form_text=#Replace(form_text, "[PANTHER NUMBER]", studpantherid)#>
     <cfset form_text=#Replace(form_text, "[STUDENT NAME]", "#studfirstname# #studlastname#")#>
     <!---Scholarship Amount: To be determined based on tuition rates and registered credit hours--->
     <cfset form_text=#Replace(form_text, 'N/A', "<i>To Be Determined</i>", "all")#>
    #form_text#
    <!---<div width="100%" align="center"><b>#getScholInfo.title# Rules<br />#getStudentAppInfo.award_year#</b></div>
    <p>Congratulations on being awarded the #getScholInfo.title#.  So that you may receive the full benefits, we would like to inform you of the guidelines governing this scholarship.</p>
    <ol>
    <li>Questions about the #getScholInfo.title# may be directed to #getScholInfo.contact_name# at <a href="mailto:#getScholInfo.contact_email#">#getScholInfo.contact_email#</a>.<br /><br /></li>
    <li>Your scholarship, which will be disbursed in equal payments of #NumberFormat(getStudentAppInfo.semester_award_amount, "$__.__")# at the beginning of the fall and spring semester during the #getStudentAppInfo.award_year# academic year, is valued at #NumberFormat(getStudentAppInfo.award_amount, "$__.__")# per full academic year.<br /><br /></li>
    <li>You must be enrolled as a full-time student (at least 12 credit hours) and meet the enrollment requirements of your college each semester you receive the award.<br /><br /></li>
    <li>#getScholInfo.schol_guidelines#<br /><br /></li>
    <li>You must digitally sign and date the #getScholInfo.title# online guideline form and the GSU Foundation award request form as soon as possible, but no later than #DateFormat(getScholInfo.award_doc_deadline, "mmmm d, yyyy")#.<br /><br /></li>
    <li>You are encouraged to apply for additional financial aid, but this is not a requirement to receive the #getScholInfo.title#.  If you demonstrate financial need, there may be other funds for which you are eligible.<br /><br /></li>
    <li>There are federal laws governing the maximum amount of financial aid a student can receive, based on the cost of attendance (COA) at a university as determined by their Financial Aid office.  Should award offers for any student exceed this COA, first federal loans and then non-federal award amounts (such as the Honors Scholarships) will be reduced until a student's total award package meets the COA limit.  By law, Pell award amounts (federal funds), can not be reduced.  Please contact the GSU Office of Financial Aid at financialaid@gsu.edu should you have any questions about these federal laws and how they may impact your overall award package.</li>
    </ol>
    I have read and agree to the terms and conditions of the #getScholInfo.title# outlined above.--->
    </cfoutput>
    </cfsavecontent>


#acceptance_form_content#
<br><br>
<cfquery name="getDeadline" datasource="eAcceptance">
	      select * from custom_paragraphs where paragraph_type='scholarshipDeadline#trim(getContactInfo.contact_unit)#'
       </cfquery>
       <cfset scholarshiprules_form_content=#Replace(scholarshiprules_form_content, "[DEADLINE DATE]", #getDeadline.paragraph_text#, "all")#>
#scholarshiprules_form_content#
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
<cfset acceptance_form_content=Replace(acceptance_form_content, '"', '&quot;', 'all')>
<cfset scholarshiprules_form_content=Replace(scholarshiprules_form_content, '"', '&quot;', 'all')>
<input type="hidden" name="agreed_scholarshiprulesform_text" value="#scholarshiprules_form_content#<br><table width='100%'><tr><td width='20%'><i>Digitally Signed</i></td><td width='20%'><i>#DateFormat(NOW(), 'mm/dd/yyyy')#</i></td><td width='20%'><i>#studfirstname# #studlastname#</i></td></tr></table>" />
<input type="hidden" name="agreed_acceptanceform_text" value="#acceptance_form_content#<br><table width='100%'><tr><td width='20%'><i>Digitally Signed</i></td><td width='20%'><i>#DateFormat(NOW(), 'mm/dd/yyyy')#</i></td><td width='20%'><i>#studfirstname# #studlastname#</i></td></tr></table>" />
</form>
</cfif>
</cfoutput>
<cfif not isDefined("Form.submit_form")><cfinvoke component="counselor/hsguidance" method="showPageFooter" /></cfif>
</body>
</html>
