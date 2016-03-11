<CFFUNCTION NAME="showLoginPage">
	<!---<br><div style="padding:10px;background-color: #F5E3BD;border:1px solid #990000; width:500px;">
	<p><b>Note:</b> GoSOLAR/Banner Maintenance Downtime, April 12-15</p>
 	<p>Banner and GoSOLAR will be unavailable for a system upgrade beginning Friday, April 12th until Monday, April 15th. As a result, the applicant status check will be unavailable during this time. The system will be available again the afternoon of Monday, April 15th. Thank you.</p>
	</div><br>--->
	<cfinclude template="\config_webapp.cfm">
	<cfinclude template="\config\webapp_bannerdown.cfm">
	<cfoutput>
	<H2>Login</H2>
	<div style="color:red;">
		<p>Please Be Advised</p>
 
	<p>Georgia State University is in the process of finalizing our consolidation with Perimeter College.  We will be upgrading our student information system in order to complete this process. The system will be unavailable from March 7th at 9:00pm EST until March 17, 2016 at 9:00am EST.</p>
 
	<p>We are sorry for any inconvenience, and urge all students and parents to contact their Georgia State admissions counselor or <a href="mailto:admissions@gsu.edu">admissions@gsu.edu</a> for any information pertaining to application or acceptance into Georgia State University. Thank you for your patience. </p>
</div>

    <cfset Session.student_id="">
    <div style=" <!--width: 650px; -->
border: 0px; padding: 5px;
<!--margin: 0px auto-->">
  <FORM ACTION="index.cfm" METHOD="POST" NAME="loginform" onsubmit="return validateStudentLogin(this);">
    <div class="row" style="white-space:nowrap">
      <span class="label">Date of Birth:</span><span
class="formw"><SELECT NAME="birth_month" id="birth_month">
	<cfloop from="1" to="12" index="month">
		<cfset tempmonth=#monthasstring(month)#>
		<cfset tempabbr=#Left(tempmonth,3)#>
		<option value="#UCase(tempabbr)#" <cfif isDefined("Form.birth_month") and Form.birth_month eq UCase(tempabbr)> selected</cfif>>#tempmonth#</option>
	</cfloop>
	</SELECT>
	<SELECT NAME="birth_day" id="birth_day">
	<cfloop from="1" to="31" index="day">
		<cfif day lt 10>
			<cfset dayvalue="0"&day>
		<cfelse>
			<cfset dayvalue=""&day>
		</cfif>
		<option value="#dayvalue#" <cfif isDefined("Form.birth_day") and Form.birth_day eq dayvalue> selected</cfif>>#day#</option>
	</cfloop>
	</SELECT>
	<cfif isDefined("Form.birth_year")><cfset selYear=Form.birth_year><cfelse><cfset selYear=""></cfif>
	<cfinvoke method="showYears" selectedyear="#selYear#" />
    </div>
    <div class="row">
      <span class="label">First 3 letters <span style="white-space:nowrap">of first name:</span></span><span
class="formw"><INPUT TYPE="text" NAME="stud_first_name_three_letters" id="stud_first_name_three_letters" SIZE="3" MAXLENGTH="3" value="<cfif isDefined('Form.stud_first_name_three_letters')>#Form.stud_first_name_three_letters#</cfif>"></span>
    </div>
    <div class="row">
      <span class="label">Last Name:</span><span
class="formw"><INPUT TYPE="text" NAME="stud_last_name" id="stud_last_name" SIZE="30" MAXLENGTH="60" value="<cfif isDefined('Form.stud_last_name')>#Form.stud_last_name#</cfif>"></span>
    </div>
    <div class="dotted">
    <div class="row" style="white-space: nowrap;">
      <span class="label">Last 4 digits SSN:</span><span
class="formw">
        <INPUT TYPE="text" NAME="stud_four_digits_ssn" id="stud_four_digits_ssn" SIZE="12" MAXLENGTH="4" value="<cfif isDefined('Form.stud_four_digits_ssn')>#Form.stud_four_digits_ssn#</cfif>">
		 
		 <span class="extrarow">- OR -</span><span class="extrarow"> GPC-ID: </span><span class="extrarow"><INPUT TYPE="text" NAME="stud_gpc_id" id="stud_gpc_id" SIZE="9" MAXLENGTH="9" value="<cfif isDefined('Form.stud_gpc_id')>#Form.stud_gpc_id#</cfif>"></span>
		 <!---<span class="extrarow"><A HREF="https://www.gpc.edu/getmygpcid/index.php?GPCLook=NO" onclick="return open_gpcidwin()">.</a></span>--->
      </span>
    </div>
		<div class="row">
      <span class="label"> </span><span
class="formw">
         
		 <span class="extrarow"><a href="" onclick="return open_gpcidwin()" style="margin-left: 155px;">What is My GPC-ID?</a></span>
      </span>
    </div>
    </div>
  <div class="spacer">
  &nbsp;
  </div>


</div>


	
	
	<BR>
	<INPUT class="loginbutton" TYPE="submit" name="submit_login" VALUE="Continue">
	<INPUT class="resetbutton" TYPE="reset" VALUE="Reset">
		<input type="hidden" name="stud_panther_number" value="">
	</FORM>
	 <!---<p>Banner is temporarily down. Please try again later.</p>--->
	<script>
	document.loginform.stud_four_digits_ssn.value="";
	document.loginform.stud_panther_number.value="";
	</script>
	<cfif not isDefined("Form.submit_login")><script>document.loginform.reset();</script></cfif>
	</cfoutput>
</CFFUNCTION>
<cffunction name="showYears">
	<cfargument name="selectedYear" required="no">
	<cfoutput>
		<cfset fromyear=#Year(NOW())#-103>
		<cfset toyear=#Year(NOW())#-10>
		<select name="birth_year" id="birth_year">
	 <cfloop index="year" from="#toyear#" to="#fromyear#" step="-1">
			<option value="#year#"
			<cfif isDefined("selectedyear") and selectedyear eq year>selected</cfif>
			>#year#</option>
	 </cfloop>
	 </select>
		</cfoutput>
</cffunction>
<CFFUNCTION NAME="validateStudentLogin">
	<!---<p>Banner is temporarily down. Please try again later.</p><cfinvoke component="applicantStatus" method="showFooter" /><cfabort>--->
	<cfif Form.birth_year eq "">
		<p style="color:red;">Please enter your birth year.</p>
		<cfinvoke method="showLoginPage" />
		<cfinvoke method="showFooter" />
		<cfabort>
	<cfelseif not isNumeric(Form.birth_year) or Form.birth_year NEQ Round(Form.birth_year)>
		<p style="color:red;">Please enter a 4-digit birth year.</p>
		<cfinvoke method="showLoginPage" />
		<cfinvoke method="showFooter" />
		<cfabort>
	<cfelseif Form.stud_first_name_three_letters eq "" or Len(Form.stud_first_name_three_letters) lt 1>
		<p style="color:red;">Please enter the first 3 letters of your first name.</p>
		<cfinvoke method="showLoginPage" />
		<cfinvoke method="showFooter" />
		<cfabort>
	<cfelseif Form.stud_last_name eq "">
		<p style="color:red;">Please enter your last name.</p>
		<cfinvoke method="showLoginPage" />
		<cfinvoke method="showFooter" />
		<cfabort>
	<cfelseif Form.stud_four_digits_ssn eq "" and Form.stud_panther_number eq "" and Form.stud_gpc_id eq "">
		<p style="color:red;">Please enter either the last 4 digits of your SSN or your complete Panther number or your GPC-ID.</p>
		<cfinvoke method="showLoginPage" />
		<cfinvoke method="showFooter" />
		<cfabort>
	<cfelseif Form.stud_four_digits_ssn neq "" and Form.stud_panther_number neq "">
		<p style="color:red;">Please only enter either your SSN, Panther number, or your GPC-ID.  Please do not enter any combination of these items.</p>
		<cfinvoke method="showLoginPage" />
		<cfinvoke method="showFooter" />
		<cfabort>
	<cfelseif Form.stud_four_digits_ssn neq "" and (Len(Form.stud_four_digits_ssn) neq 4 or not isNumeric(Form.stud_four_digits_ssn))>
		<p style="color:red;">Please enter all of the last 4 numeric digits of your SSN.</p>
		<cfinvoke method="showLoginPage" />
		<cfinvoke method="showFooter" />
		<cfabort>
	<cfelseif Form.stud_panther_number neq "" and (Len(Form.stud_panther_number) neq 9 or not isNumeric(Form.stud_panther_number))>
		<p style="color:red;">Please enter all 9 numeric digits of your Panther Number.</p>
		<cfinvoke method="showLoginPage" />
		<cfinvoke method="showFooter" />
		<cfabort>
	<cfelseif Form.stud_panther_number neq "" and Left(Form.stud_panther_number, 1) neq "0">
		<p style="color:red;">Please make sure the Panther Number you enter begins with a 0.</p>
		<cfinvoke method="showLoginPage" />
		<cfinvoke method="showFooter" />
		<cfabort>
	<cfelseif Form.stud_gpc_id neq "" and (Len(Form.stud_gpc_id) neq 9 or not isNumeric(Form.stud_gpc_id))>
		<p style="color:red;">Please enter all 9 numeric digits of your GPC-ID.</p>
		<cfinvoke method="showLoginPage" />
		<cfinvoke method="showFooter" />
		<cfabort>
	<cfelseif Form.stud_gpc_id neq "" and Left(Form.stud_gpc_id, 1) neq "9">
		<p style="color:red;">Please make sure the GPC-ID you enter begins with a 9.</p>
		<cfinvoke method="showLoginPage" />
		<cfinvoke method="showFooter" />
		<cfabort>
	</cfif>
</CFFUNCTION>
<CFFUNCTION NAME="tryLogin">
	<!---<p>Banner is temporarily down. Please try again later.</p><cfinvoke component="applicantStatus" method="showFooter" /><cfabort>--->
	<cfinclude template="\config_webapp.cfm">
	<cfinclude template="\config\webapp_bannerdown.cfm">
	<cfif Form.stud_four_digits_ssn eq "">
		<cfset ssn="????">
	<cfelse>
		<cfset ssn=Form.stud_four_digits_ssn>
	</cfif>
	<cfif Form.stud_panther_number eq "">
		<cfset pnum="?????????">
	<cfelse>
		<cfset pnum=Form.stud_panther_number>
	</cfif>
	<!---<cfoutput>#Session.odatasource# #Form.birth_month# #Form.birth_day# #Form.birth_year# #ssn# #pnum# #Form.stud_first_name_three_letters# #Form.stud_last_name#</cfoutput>--->
	<cfset studlastname=Replace(Form.stud_last_name, "'", "''")>
	
	<cfinvoke method="validateStudentLogin" />
	
	<cftry>
	
	<cfif ssn neq "????" or Form.stud_gpc_id neq "">
		<cfif ssn eq "????"><cfset tempssn=""><cfelse><cfset tempssn=ssn></cfif>
		<cfset tempmonth=DateFormat("#Form.birth_month# 1, 2001", "mm")>
		<cfhttp url="https://webapp-qa.gpc.edu/gsuApiCode/checkCredentials" method="POST" result="result" charset="utf-8" port="443" >
			<cfhttpparam name="Content-Type" value="application/x-www-form-urlencoded" type="header">
			<cfhttpparam name="Accept" value="application/json" type="header">
			<cfhttpparam type="body" value='{"authentication":{"api_key":"GSU783354110","api_pass":"A|7E>arpK.L8:qkAX$ab"},"checkParms":{"firstName3": "#Form.stud_first_name_three_letters#", "lastName": "#studlastname#", "dob": "#Form.birth_year#-#tempmonth#-#Form.birth_day#", "ssnLast4": "#tempssn#", "gpcid": "#Form.stud_gpc_id#"}}'>
		</cfhttp>
			<cfset getResult = deserializeJSON(result.filecontent)>
	</cfif>
		
		
		
	 
	<cfcatch>
		<cfif isDefined("cfcatch.message")><cfset message=cfcatch.message><cfelse><cfset message=""></cfif>
		<cfif isDefined("cfcatch.detail")><cfset detail=cfcatch.detail><cfelse><cfset detail=""></cfif>
		<cfif isDefined("cfcatch.NativeErrorCode")><cfset errorcode=cfcatch.NativeErrorCode><cfelse><cfset errorcode=""></cfif>
		<cfoutput><cfinvoke method="showerrors" message="#message#" detail="#detail#" errorcode="#errorcode#" returnvariable="error" /><cfif error neq "">#error#<cfelse></cfif></cfoutput>
		<!---<cfmail
		from="christina@gsu.edu"
		replyto = "christina@gsu.edu"
		to="christina@gsu.edu"
		bcc="christina@gsu.edu"
		subject="app status - problem connecting to GPC webservice"
		SERVER="mailhost.gsu.edu">
		Error in App Status
		<cfoutput>
		<cfif isDefined("cgi.HTTP_REFERER")>#cgi.HTTP_REFERER#</cfif>
		<cfif isDefined("Session.student_id")>#Session.student_id#</cfif>
		<cfif isDefined("Session.studentLevel")>#Session.studentLevel#</cfif>
		<cfif isDefined("Session.returning_student")>#Session.returning_student#</cfif>
		<cfif isDefined("session.option")>#Session.option#</cfif>
		<cfif isDefined("cfcatch.message")>#cfcatch.message#</cfif>
		<cfif isDefined("cfcatch.detail")>#cfcatch.detail#</cfif>
		#DateFormat(NOW(), "mm/dd/yyyy")# #TimeFormat(NOW(), "hh:mm tt")#
		<cfif isDefined("Form.birth_month")>#Form.birth_month#</cfif> 
		<cfif isDefined("Form.birth_day")>#Form.birth_day#</cfif>
		<cfif isDefined("Form.birth_year")>#Form.birth_year#</cfif> 
		<cfif isDefined("Form.stud_four_digits_ssn")>#Form.stud_four_digits_ssn#</cfif>
		<cfif isDefined("Form.stud_panther_number")>#Form.stud_panther_number#</cfif>
		<cfif isDefined("Form.stud_first_name_three_letters")>#Form.stud_first_name_three_letters#</cfif> 
		<cfif isDefined("Form.stud_last_name")>#Form.stud_last_name#</cfif> 
		</cfoutput>
		</cfmail>
		<h3 style="color:red;">Please try back later. Thank you.</h3>--->
		  <cfinvoke component="applicantStatus" method="showLoginPage" /><cfexit>
	</cfcatch>
	
	</cftry>
	 
	<cfoutput>
		<!---<cfdump var="#getResult.Authentication#">
		<cfdump var="#out_result_set#">--->
	<cfif (not isDefined("getResult") or not isDefined("getResult.Authentication") or #getResult.Authentication# neq "SUCCESSFUL") and (not isDefined("out_result_set.panther_no") or out_result_set.panther_no eq "")>
		
		
		<cfif isDefined("out_result_set.panther_no") and out_result_set.panther_no neq "">
			<cfinvoke method="logStudentIn" student_id="#out_result_set.panther_no#" studlastname="#studlastname#"  />
		<cfelse>
			<p class="errortext" style="color:red;"><i>Your login information did not match correctly.  If you are an undergraduate or graduate applicant, this is due to our Banner Consolidation downtime; please log in after March 17, 2016.</i></p>
			<cfinvoke component="applicantStatus" method="showLoginPage" />
		</cfif>
		<!---end of 900 ID issue.--->
		
		
	<cfelse>
		<cfif isDefined("out_result_set.panther_no")><cfset panthernum=out_result_set.panther_no><cfelse><cfset panthernum=""></cfif>
		<cfif isDefined("getResult.Authentication") and getResult.Authentication eq "SUCCESSFUL"><cfset gpcnum=getResult.studentId><cfelse><cfset gpcnum=""></cfif>
		<!---<cfdump var="#getResult.Authentication#">--->
		<cfinvoke method="logStudentIn" panthernum="#panthernum#" gpcnum="#gpcnum#" studlastname="#studlastname#"  />
	</cfif>
	</cfoutput>
</CFFUNCTION>
<cffunction name="logStudentIn">
<cfargument name="panthernum">
<cfargument name="gpcnum">
<cfargument name="studlastname">
		<!---<cfinvoke component="applicantStatus" method="showApplicationSummary" studentid="#Session.student_id#" />--->
        <cfif panthernum neq "">
					<cfinvoke method="addZeros" panther_id="#panthernum#" returnvariable="panthernum" />
					<cfset student_id=panthernum>
					<cfset Session.student_id="#panthernum#">
				<cfelse>
					<cfset student_id=gpcnum>
					<cfset Session.student_id="#gpcnum#">
				</cfif>
        <cfquery name="insertLogin" datasource="eAcceptance">
        	insert into student_clicks (click_id, panther_id, click_event, click_date, user_agent) values (studentclicks_seq.NEXTVAL, '#student_id#', 1, #NOW()#, '#Left(CGI.HTTP_USER_AGENT, 499)#')
        </cfquery>
				<cfif isDefined("Form.submit_login")>
					<cfset bdate=ParseDateTime("#Form.birth_month# #Form.birth_day#, #Form.birth_year#")>
					<cfinvoke method="determineCorrectSystem" pid="#panthernum#" gpcid="#gpcnum#" birthdate="#Form.birth_year#-#DateFormat(bdate, "mm")#-#Form.birth_day#" lastname="#studlastname#" />
				</cfif>
</cffunction>
<cffunction name="determineCorrectSystem">
<cfargument name="pid">
<cfargument name="gpcid">
<cfargument name="birthdate">
<cfargument name="lastname">
	<cfset gpc_record=false>
	<cfset gsu_record=false>
	<cfset inactive_gsu=false>
	<cfoutput>
	<!---starting to check gpc db for gpc application status--->
	<cfif gpcid eq "">
			<cfquery name="getGPCID" datasource="hsguidanceoracle">
			select spriden_id
from spriden
where spriden_id like '9%'
and   spriden_ntyp_code = 'LGCY'
and   spriden_change_ind = 'I' 
and   spriden_pidm =
     (select spriden_pidm
      from spriden
      where spriden_id = '#pid#'
      and   spriden_change_ind is null)
			</cfquery>
			<cfset gpcid=getGPCID.spriden_id>
	</cfif>
	<cfif gpcid neq "">
	 <cfhttp url="https://webapp-qa.gpc.edu/gsuApiCode/getApplicantStatus" method="POST" result="result1" charset="utf-8" port="443" >
  <cfhttpparam name="Content-Type" value="application/x-www-form-urlencoded" type="header">
    <cfhttpparam name="Accept" value="application/json" type="header">
    <cfhttpparam type="body" value='{"authentication": {"api_key": "GSU783354110","api_pass": "A|7E>arpK.L8:qkAX$ab"},"applicantStatus": {"studentId": "#gpcid#"}}'>
	</cfhttp>
	 <cfset getResult = deserializeJSON(result1.filecontent)>
	 <!---<cfif isDefined("getResult.applicationStatus") and getResult.applicationStatus neq "NONE"><cfset gpc_record=true></cfif>--->
	 <cfif isDefined("getResult.applicationStatus") and not (getMetadata(getResult.applicationStatus).getName() eq "coldfusion.runtime.Struct" and getResult.applicationDate eq "null") and not (isDefined("getResult.applicationDate") and getResult.applicationDate eq "null")><cfset gpc_record=true><cfinvoke method="sendStudentToGPCSystem" pid="#pid#" gpcid="#gpcid#" birthdate="#birthdate#" lastname="#lastname#" /><cfelse><p>Georgia State University could not locate an application with the information you entered. Please contact the Office of Admissions for Perimeter College at gpcrec@gpc.edu if you were searching for an associate's application or the Office of Undergraduate Admissions at admissions@gsu.edu if you were searching for an application for one of our bachelor's programs. If your original entry term has expired, our offices require that you fill out our reactivation form - where we will then update your record with an active application entry term.</p><p>Please be prepared to provide your Panther ID or GPC User ID, which can be located in the first email you received after opening an application for either of our degree programs.</p><cfinvoke method="showFooter" /></cfif><cfabort>
	 <!---<cfdump var="#getResult.applicationStatus#"><cfdump var="#getResult#">#getResult.applicationDate#<cfabort>--->
	 <!---#getResult.applicationStatus[1]# ||  #getResult.applicationStatus[2]#--->
	</cfif>
	</cfoutput>
	 
	<!---<cfinvoke method="logOutOfSystem" />
	<cfif Find("SUCCESSFUL", #result.filecontent.toString()#) gt 0><cflocation addToken="no" url="https://eapps.gpc.edu/mystatus/gsuRemoteMystatusLogin.php?token=#token#">--->
	<!---<cfif Find("NONE", #result1.filecontent.toString()#) eq 0><cfset gpc_record=true></cfif>--->
	<cfset pid="">
	<cfif pid eq "">
		
	</cfif>
	      <cfif pid neq "">
		<cfstoredproc  procedure="wwokbapi.f_get_app" datasource="hsguidanceoracle">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#pid#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_term_code" type="in" value="TERM"> 
			<cfprocresult name="out_result_set">
			</cfstoredproc>
		<cfloop query="out_result_set">
			<cfif app_stu_level neq "UA">
				<cfset gsu_record=true>
				<cfset gsu_app_date=app_date>
			</cfif>
		</cfloop>
		<cfif gsu_record eq false>
			<cfquery name="getInactiveApps" datasource="hsguidanceoracle">
			SELECT saradap_term_code_entry, saradap_appl_date
			from saradap a
			where saradap_pidm = (select spriden_pidm
														from   spriden
														where  spriden_id = '#pid#'
														and    spriden_change_ind is null)
			and saradap_levl_code in ('US', 'UG')
			and (a.saradap_term_code_entry || to_char(a.saradap_appl_date, 'YYMMDD')) =
			(select max(b.saradap_term_code_entry || to_char(b.saradap_appl_date, 'YYMMDD'))
				from saradap b, stvterm
				where b.saradap_pidm = a.saradap_pidm
				and   b.saradap_levl_code in ('US', 'UG')
				and   b.saradap_term_code_entry = stvterm_code
				and   stvterm_end_date <= sysdate)
			</cfquery>
			<cfif getInactiveApps.RecordCount gt 0>
				<cfset gsu_record=true>
				<cfset inactive_gsu=true>
				<cfset gsu_app_date=getInactiveApps.saradap_appl_date>
			</cfif>
		</cfif>
	      </cfif>
	<cfif gpc_record eq true and gsu_record eq true>
	  <cfif isDefined("getResult.applicationDate")>
	    <cfset gpc_app_date=getResult.applicationDate>
	  <cfelse>
	    <cfset gpc_app_date="">
	  </cfif>
	  <cfinvoke method="giveStudentSystemChoice" pid="#pid#" gpcid="#gpcid#" birthdate="#birthdate#" lastname="#lastname#" gpcAppDate="#gpc_app_date#" gsuAppDate="#gsu_app_date#" inactive_gsu="#inactive_gsu#" />
	<cfelseif gpc_record eq true>
	  <cfinvoke method="sendStudentToGPCSystem" pid="#pid#" gpcid="#gpcid#" birthdate="#birthdate#" lastname="#lastname#" />
	<cfelse>
		<cfset newLoc="index.cfm?option=1">
		<!---<cfif inactive_gsu eq true><cfset newLoc=newLoc&"&inactive_gsu=#inactive_gsu#"></cfif>
		<cfoutput>#newLoc#</cfoutput>--->
		<cflocation url="#newLoc#" addtoken="no">
		<cfabort>
	</cfif><!---later add in if they have both records...give choice about which system to view--->
</cffunction>
<cffunction name="giveStudentSystemChoice">
<cfargument name="pid">
<cfargument name="gpcid">
<cfargument name="birthdate">
<cfargument name="lastname">
<cfargument name="gpcAppDate">
<cfargument name="gsuAppDate">
<cfargument name="inactive_gsu" default="" required="no">
	<p>We see that you have applied to both GSU (Downtown) and Perimeter College.  Please choose which application status you would like to view:</p>
	<cfoutput><form method="post" action="index.cfm"><br>
			<input type="radio" id="gsu" name="systemChoice" value="gsu" />GSU (Downtown) - Application Date: #DateFormat(gsuAppDate, "mm/dd/yyyy")#<Br>
			<input type="radio" id="gpc" name="systemChoice" value="gpc" />GSU Perimeter College - Application Date: #gpcAppDate#<br><br><br>
			<input type="hidden" name="chooseSystem" value="true" />
			<input type="hidden" name="pid" value="#pid#" />
			<input type="hidden" name="gpcid" value="#gpcid#" />
			<input type="hidden" name="birthdate" value="#birthdate#" />
			<input type="hidden" name="lastname" value="#lastname#" />
			<!---<input type="hidden" name="inactive_gsu" value="#inactive_gsu#">--->
			<input type="submit" value="See Status" onclick="return validateRadio()"><br><br><br><br><br>
	</form></cfoutput>
</cffunction>
<cffunction name="sendStudentToGPCSystem">
<cfargument name="pid">
<cfargument name="gpcid">
<cfargument name="birthdate">
<cfargument name="lastname">
	<cfset token=Hash("#pid#_#DateFormat(NOW(), 'mmddyyyy')#_#TimeFormat(NOW(), 'hhnnss')#_#Int(Rand()*999999999999999999999)#", "MD5")>
<cfoutput>#token# #birthdate#</cfoutput>
	<cfhttp url="https://webapp-qa.gpc.edu/gsuApiCode/gsuToken" method="POST" result="result" charset="utf-8" port="443" >
  <cfhttpparam name="Content-Type" value="application/x-www-form-urlencoded" type="header">
    <cfhttpparam name="Accept" value="application/json" type="header">
    <cfhttpparam type="body" value='{"authentication":{"api_key":"GSU783354110","api_pass":"A|7E>arpK.L8:qkAX$ab"},"studentData":{"token":"#token#","studentId":"#gpcid#","dob":"#birthdate#","lastName":"#lastname#"}}'>
	</cfhttp>
	<!---<cfinvoke method="logOutOfSystem" />--->
	<!---<cfdump var="#result#"><cfoutput>#result.filecontent.toString()#</cfoutput>--->
	<cfif Find("SUCCESSFUL", #result.filecontent.toString()#) gt 0><cflocation addToken="no" url="https://eapps.gpc.edu/mystatus/gsuRemoteMystatusLogin.php?token=#token#">
	<cfelse><p>A temporary error has occured. Please try again later.</p></cfif>
	<cfabort>
</cffunction>
<cffunction name="showWelcomeBanner">
   <cfargument required="no" name="appterm">
   <cfargument required="no" name="dec_code">
   <cfargument required="no" name="dec_app_no">
   <cfargument required="no" name="app_stat_code_desc">
   <cfargument required="no" name="app_date">
	<cfquery name="getWelcomeBannerStatus"  datasource="eAcceptance">
	  select * from student_clicks where click_event=9 and panther_id='#Session.student_id#'
	</cfquery>
	<!---<cfoutput>#Session.student_id#</cfoutput>--->
	<script>
		<cfif getWelcomeBannerStatus.RecordCount gt 0> //this function must be specified twice because it won't let me put an if statment inside the accordion declaration to state whether the accordion  should be active or not.
		  $(function() {
		    $('.wrapper').show();
				$( "#accordion" ).accordion({
						collapsible: true,
						active:false,
						activate: function(event, ui) {
								if(ui.newHeader.attr('id') == undefined)
										$('#accordion-header').html('Share Your News&nbsp;&nbsp;&nbsp;<img src="admin/images/eacceptance_expand_2.png">');
								else
										$('#accordion-header').html('Share Your News&nbsp;&nbsp;&nbsp;<img src="admin/images/eacceptance_close.png">');
						}
				});
				$("#panther-button").button();
		});
		<cfelse>
		  $(function()
		    $('.wrapper').show();
				$( "#accordion" ).accordion({
						collapsible: true,
						activate: function(event, ui) {
								if(ui.newHeader.attr('id') == undefined)
										$('#accordion-header').html('Share Your News&nbsp;&nbsp;&nbsp;<img src="admin/images/eacceptance_expand_2.png">');
								else
										$('#accordion-header').html('Share Your News&nbsp;&nbsp;&nbsp;<img src="admin/images/eacceptance_close.png">');
						}
				});
				$("#panther-button").button();
		});
		 </cfif>
	</script>
       <style>
	      body {font-size: 0.8em; outline: none !important;}
	      #accordion {width: /* WIDTH OF CONTENT */ 960px; padding-left:-20px;margin-left:-10px;<!---margin: 0 auto;--->}
	      .accordion-tab {
		      color: white;
		      padding: 10px;
		      background: #0066CC;
		      border: 0px;
	      }
	      .content-with-background {
		      padding: 10px;
		      color: white;
		      background-color: #0066CC;
		      background: -moz-linear-gradient(top,  	#0066CC, #0077DD);
		      background: -webkit-linear-gradient(top,  	#0066CC, #0077DD);
		      background: -o-linear-gradient(top,  	#0066CC, #0077DD);
		      background: linear-gradient(top,  	#0066CC, #0077DD);
		      /* versions of IE use these */
		      filter:progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr='#0066CC',EndColorStr='#0077DD');
		      -ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorstr=#0066CC, endColorstr=#0077DD)";
		      border-radius:5px 5px 5px 5px;
	      }
	      *:focus
	      {
		      outline: none;
	      }
      }
      </style>
       <cfoutput>
	
	<!---check if honors or transfer to show image--->
	<cfquery name="getAcceptanceLetters" datasource="eAcceptance">
		select * from sent_letters where student_id=#Session.student_id# and (appdate between to_date('#DateFormat(APP_DATE, 'dd-mm-yyyy')#','DD-MM-YYYY') and to_date('#DateFormat(APP_DATE, 'dd-mm-yyyy')# 23:59:59','DD-MM-YYYY hh24:mi:ss')) and (<cfset termcount=1><cfloop list="#appterm#" index="s"><cfif termcount gt 1> or </cfif>appterm='#s#'<cfset termcount=termcount+1></cfloop>) order by letter_date desc
	</cfquery>
	<cfquery name="getSentLetter" dbtype="query">
		select * from getAcceptanceLetters where student_type=41 order by letter_date desc
	</cfquery>
	<cfif getSentLetter.RecordCount gt 0><cfset honors_student_confirmed=true>
	<cfelse><cfset honors_student_confirmed=false></cfif>
	<cfquery name="getSentLetter" dbtype="query">
		select * from getAcceptanceLetters where student_type=2 or student_type=206 or student_type=406 order by letter_date desc
	</cfquery>
	<cfif getSentLetter.RecordCount gt 0><cfset transfer_student_confirmed=true>
	<cfelse><cfset transfer_student_confirmed=false></cfif>
	<!---end checking on honors/transfer--->
	
      <div id="accordion" class="ui-accordion ui-widget ui-helper-reset">
	<cfinvoke component="counselor/hsguidance" method="getAppDecision" studid="#Session.student_id#" termcode="#appterm#" appnum="#dec_app_no#" returnvalue="true" returnvariable="app_dec_code" />
	<h3 style="font-size:14px;" class="ui-accordion-header ui-helper-reset ui-state-default ui-corner-all ui-accordion-icons">Application Summary for <cfif isDefined("last_name")>#last_name#,</cfif> <cfif isDefined("first_name")>#first_name#</cfif> #Session.student_id#: Status
	<cfif dec_code eq 86 or dec_code eq 87>
	  <cfquery name="getStatuses" datasource="eAcceptance">
		select * from status_explanations where status_code='<cfif isDefined("app_dec_code")>#app_dec_code#<cfelse>#dec_code#</cfif>' and info_text is not null
	   </cfquery>
	  <!---<cfif app_stat_code eq "C">Complete - Ready for Review<cfelseif app_stat_code eq "I">Incomplete - Items Outstanding<cfelse>--->#app_stat_code_desc#<!---</cfif>--->
	  
	<cfelse>
	  Accepted
	</cfif></span>
	<span id="accordion-header" style="margin-left: <cfif dec_code eq 86 or dec_code eq 87>100<cfelse>220</cfif>px;">Share Your News&nbsp;&nbsp;&nbsp;<cfif getWelcomeBannerStatus.RecordCount gt 0><img src="admin/images/eacceptance_expand_2.png"><cfelse><img src="admin/images/eacceptance_close.png"></cfif></span>
	</h3>
	<div width="100%" align="center" style="display: none">
	  <cfif isDefined("appterm")>
	    <cfset stringterm="">
	    <cfset loopcount=1>
	    <cfloop list="#appterm#" index="s">
	      <cfif loopcount lt 3>
		<cfinvoke component="counselor/hsguidance" method="getTerm" termcode="#s#" returnvariable="sterm" />
		<cfif stringterm neq ""><cfset stringterm=stringterm&" and "></cfif>
		<cfset stringterm=stringterm&sterm>
	      </cfif>
	      <cfset loopcount=loopcount+1>
	    </cfloop>
	  </cfif>
	  <h3 class="acceptance" style="margin-top: 20px;"><span class="acceptance-msg"><cfif isDefined("first_name")>#first_name#,</cfif> you're accepted <cfif isDefined("appterm")>for <cfif dec_code eq 86>spring<cfelseif dec_code eq 87>summer<cfelse>#lcase(stringterm)#</cfif> semester</cfif>!</span></h3>
	  <h3 class="acceptance"><span class="acceptance-msg2">Welcome to Georgia State.</span></h3>
	 
	 
	 
	 <table><tr><td valign="top">
	 
	 
	 
	 <table class="social-buttons-table"><tr>
	  <td colspan=3 style="text-align: center; height: 25px;"><h4 style="margin: 5px 0px;">Share Your News!</h4></td>
</tr><tr>
	  <td align="center">
<!---used to be:<iframe src="//www.facebook.com/plugins/share_button.php?href=http%3A%2F%2Fadmissions.gsu.edu%2Fhow-do-i-apply%2Fapplication-status%2F&amp;layout=button_count" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width: 80px; height: 20px;" allowTransparency="true"></iframe>--->
<a target="_blank" href="https://www.facebook.com/GeorgiaStateUniversity/"><img src="admin/images/square-facebook-32.png"></a>
</td>
	  <td align="center">
	  <!---used to be:<a class="twitter-hashtag-button"
  href="https://twitter.com/intent/tweet?button_hashtag=GSUncommon&text=I%20got%20into%20Georgia%20State!"
  data-related="twitter">
Tweet
</a>
<script type="text/javascript">
window.twttr=(function(d,s,id){var t,js,fjs=d.getElementsByTagName(s)[0];if(d.getElementById(id)){return}js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);return window.twttr||(t={_e:[],ready:function(f){t._e.push(f)}})}(document,"script","twitter-wjs"));
</script>--->
<a target="_blank" href="https://twitter.com/GeorgiaStateU"><img src="admin/images/square-twitter-32.png"></a>
</td>
	  <td align="center" style="font-size:10px;font-weight:normal;" width="20%"><a target="_blank" href="http://instagram.com/georgiastateuniversity"><img alt="Instagram" src="admin/images/Instagram-32.png"></a><br></td></tr>
		<Tr><td colspan="3" style="padding-bottom:14px;">use ##GSUncommon</td></Tr>
</table>	  
	  

</td><td valign="top">

<table class="social-buttons-table">
	  <tr>
	  <td colspan=3 style="text-align: center; height: 25px;"><h4 style="margin: 5px 0px;">Follow us and Play our Snapchat game:</h4></td></tr>
		<tr><Td style="padding-bottom:5px;"><img alt="SnapChat" src="admin/images/snapchat_small1.png"></Td></tr>
</table>	  



</td></tr></table>

	  
	  
	  <cfif honors_student_confirmed eq true>
	    <img width="853" height="480" src="admin/images/Honors.jpg">
	  <cfelseif transfer_student_confirmed eq true>
	    <img width="853" height="480" src="admin/images/Transfer.jpg">
	  <cfelse>
	    <img width="853" height="480" src="admin/images/Freshmen.jpg">
	  </cfif>
	</div>
      </div>
      
      
      
      
      
      
      
      
     <!--- <table border="1" cellspacing="0">
	<tr><Td style="margin-left:10px;margin-right:10px;"><div class="content-section"><h2>View Your Official Letter<cfif scholcount gt 0>s</cfif></h2><hr style="margin-top:10px;"><span width="100%" align="right"><a target="_blank" href="http://get.adobe.com/reader/">Need Adobe Acrobat?</a></span>
		
	<cfif getSALetter.RecordCount gt 0>
		  <tr>
			  <td><a id="greyboxlink" href="viewSentLetterIntro.cfm?letter_id=#getSALetter.letter_id#" title="View SA Letter" rel="gb_page_center[500, 525]"><!---<a href="javascript:document.appstatusform.submit();">---><img border="0" src="admin/images/acceptance_letter_icon.png" align="middle" style="margin-left:5px;"></a></td>
			  <td><a id="greyboxlink" href="viewSentLetterIntro.cfm?letter_id=#getSALetter.letter_id#" title="View Admissions Letter" rel="gb_page_center[500, 525]">View Your Summer Academy <cfif getSALetter.student_type eq 11>PATH</cfif> Offer Letter</a><cfif Session.mobile eq "false"><br>(PDF)</cfif></td>
		       </tr>
	  </cfif>

	  <cfif getSentLetter.RecordCount gt 0>
	    <tr>
	      <td><a id="greyboxlink" href="viewSentLetterIntro.cfm?letter_id=#getSentLetter.letter_id#" title="View Admissions Letter" rel="gb_page_center[500, 525]"><img border="0" src="admin/images/acceptance_letter_icon.png" align="middle" style="margin-left:5px;"></a></td>
	      <td><a id="greyboxlink" href="viewSentLetterIntro.cfm?letter_id=#getSentLetter.letter_id#" title="View Admissions Letter" rel="gb_page_center[500, 525]">View Your Letter</a><cfif Session.mobile eq "false"><br>(PDF)</cfif></td>
	    </tr>
	  </cfif>
	  <cfif out_result_set_cohort.RecordCount gt 0>
	     <tr><td><a href="viewYourScholarshipLetter.cfm?letter_id=#getSentLetter.letter_id#" title="View Scholarship Letter"><img border="0" src="admin/images/scholarship_letter_icon.png"></a></td>
		     <td>
	      <div style="border-top:1px solid; border-top-color:gray; padding-top:15px;" onClick="document.location='viewYourScholarshipLetter.cfm?letter_id=#getSentLetter.letter_id#';">
	      <a href="viewYourScholarshipLetter.cfm?letter_id=#getSentLetter.letter_id#" title="View Scholarship Letter">View your Scholarship Letter</a><br>(PDF)<!---<span style="float:right;display:inline;margin-right:50px;font-size:24px;font-weight:bold;margin-top:-10px;">></span>--->
	      </div></td></tr>
	  </cfif>
				 
	
	
	
	
	
	
	
	
	
	
	
	
	
	</Td></tr>
	<tr></tr>
	<tr></tr>
      </table>--->
      </cfoutput>
       <cfif isDefined("URL.refresh") and getWelcomeBannerStatus.RecordCount eq 0>
	<cfquery name="updateWelcomeBannerStatus"  datasource="eAcceptance">
	    insert into student_clicks (click_id, click_date, click_event, panther_id, user_agent) values (studentclicks_seq.NEXTVAL, #NOW()#, 9, '#Session.student_id#', '#Left(CGI.HTTP_USER_AGENT, 499)#')
	</cfquery>
      </cfif>
</cffunction>
<cffunction name="showApplicationSummary2">
	<cfinvoke component="counselor/hsguidance" method="getAddress" studid="#studentid#" addresstype="MA" returnvariable="address" />
	<cfinvoke component="counselor/hsguidance" method="getPhone" studid="#studentid#" addresstype="MA" returnvariable="phone" />
	<cfinvoke component="counselor/hsguidance" method="getEthnicity" studid="#studentid#" returnvariable="ethnicity" />
	<cfinvoke component="counselor/hsguidance" method="getRace" studid="#studentid#" returnvariable="race_resultset" />
	<cfinvoke component="counselor/hsguidance" method="getGender" studid="#studentid#" returnvariable="gender" />
	<cfinvoke component="counselor/hsguidance" method="getCitizenship" studid="#studentid#" returnvariable="citizen" />
	<cfinvoke component="counselor/hsguidance" method="getEmail" studid="#studentid#"  type="IND"returnvariable="email" />
    	<cfinvoke component="counselor/hsguidance" method="getEmail" studid="#studentid#"  type="GSU"returnvariable="emailgsu" />
	<cfinvoke component="counselor/hsguidance" method="getName" studid="#studentid#" returnvariable="name" />
	<cfoutput>
		<cfinvoke component="counselor/hsguidance" method="getApps" studid="#studentid#" returnvariable="apps"  />
		<cfif apps.RecordCount eq 0 or (apps.app_term_code eq "" and apps.app_no eq "")><p>Georgia State University could not locate an application with the information you entered. Please contact the Office of Admissions for Perimeter College at <a href="mailto:gpcrec@gpc.edu">gpcrec@gpc.edu</a> if you were searching for an associate's application or the Office of Undergraduate Admissions at <a href="mailto:admissions@gsu.edu">admissions@gsu.edu</a> if you were searching for an application for one of our bachelor's programs. If your original entry term has expired, our offices require that you fill out our reactivation form - where we will then update your record with an active application entry term.</p> 

<p>Please be prepared to provide your Panther ID or GPC User ID, which can be located in the first email you received after opening an application for either of our degree programs.  

</p><cfreturn>
	</cfif>
	<table width="100%" class="acceptance-table">
	  <Tr><td width="80%">
		
	<p>Welcome #name.split(" ")[1]#!</p><p>If you have any questions about the content in this summary, please contact your <a target="_blank" href="http://admissions.gsu.edu/category/advisor/">admissions counselor</a>. You may still edit or revise the information on this page. </p><p>Please check back regularly for status updates.</p>
	</td>
	  <Td nowrap><cfinvoke component="counselor/hsguidance" method="showContactBox" /></Td></Tr>
	</table>
	
	<cfset prevterm="">
	<cfif apps.ToString() eq "confidential"><p><i>Sorry, you may not check your application status because your record is marked as "Confidential Student Information".</i></p><cfreturn></cfif>
	
	<div class="content-section-wrapper">
		<div class="content-section" <!---style="height: 261px"--->>
				      <table class="usermatrix" width="100%">
				      <tr class="row"><td colspan="2" <!---cfif Session.mobile eq "false">style="border-bottom-width: 1px; border-bottom-style: outset; border-color: Black; white-space:nowrap;"</cfif--->> <cfif Session.mobile eq "true"><input type="button" id="expandbutton" value="Expand Student Information" onclick="style_studentinfo.display = style_studentinfo.display? display:display; style_expandbutton.display = 'none'; style_collapsebutton.display = style_collapsebutton.display? display:display;"><input type="button" id="collapsebutton" value="Collapse Student Information" style="display:none;" onclick="style_studentinfo.display = 'none'; style_expandbutton.display = style_expandbutton.display? display:display; style_collapsebutton.display = 'none';"></cfif></td></tr>
				      <tbody id="studentinformation" <cfif Session.mobile eq "true">style="display:none"</cfif>>
				      <tr><td valign="top" colspan="4"><h3 style="margin: 0px">Student Personal Information</h3><hr></td></tr>
					      <tr><td style="padding-bottom:10px;" valign="top" width="20%"><b>Name:</b></td><td valign="Top" width="30%">#name#</td><cfif apps.app_stu_type neq "F"><td style="padding-bottom:10px;" valign="top" width="20%"><b>Race:</b></td><td valign="top" width="30%"><cfif race_resultset.toString() eq "confidential"><i>Confidential Student Information</i><cfelseif race_resultset.RecordCount eq 1>#race_resultset.race_code#<cfelse><ul><cfloop query="race_resultset"><li>#race_resultset.race_code#</li></cfloop></ul></cfif></td></cfif></tr>
					      <tr><td style="padding-bottom:10px;" valign="top"><b>Mailing Address:</b></td><td valign="top">#address#</td><td style="padding-bottom:10px;" valign="top"><b>Gender:</b></td><td valign="top">#gender#</td></tr>
					      <tr><td style="padding-bottom:10px;" valign="top"><b>Phone Number:</b></td><td valign="top">#phone#<br></td><td style="padding-bottom:10px;" valign="top"><b>Citizenship:</b></td><td valign="top">#citizen#</td></tr>
					      <tr><td style="padding-bottom:10px;" valign="top"><b>Personal Email:</b></td><td valign="top">#email# &nbsp; &nbsp; &nbsp; <br></td>
						<cfif studentview neq "">
						      <td valign="top"><b>Panther Number:</b></td><td valign="top">#studentid#</td>
						</cfif></tr>
				      <cfif emailgsu neq ""><tr><td style="padding-bottom:10px;" valign="top"><b>GSU Email:</b></td><td valign="top">#emailgsu#<br></td></tr></cfif>
					      <cfif apps.app_stu_type neq "F"><tr><td style="padding-bottom:10px;" valign="top"><b>Ethnicity:</b></td><td valign="top">#ethnicity#</td></tr></cfif>
					      
					   
					      
					      
					      
				      </tbody>
				      </table>
		</div></div>
		 																									  
																																																											     
	<!---<cfset first="true">
	<cfset highest_term=200901>
	<cfloop query="apps">
		<cfif #APP_TERM_CODE# gt highest_term>
			<cfset highest_term=#APP_TERM_CODE#>
		</cfif>
	</cfloop>--->
	
	<cftry>
	<cfinvoke method="showApplications" studentid="#studentid#" studentview="#studentview#" whichterms="accepted" />
	<cfinvoke method="showApplications" studentid="#studentid#" studentview="#studentview#" whichterms="all" />
	<cfcatch>#cfcatch.message# -> #cfcatch.detail#</cfcatch>
	</cftry>
	
	<p><b>Disclaimer:</b> <i>Please allow at least two weeks from the time documents are mailed to the Office of Undergraduate Admissions to be processed and visible in our system.</i></p>
			    <p>Note: To change your Student Information, please go to the <a target="_blank" href="http://registrar.gsu.edu/assistance/">Enrollment Services Center</a> or log in to <a target="_blank" href="http://paws.gsu.edu">PAWS</a> with your CampusID and password.</p>
	
	</td><td></td></tr>
	</cfoutput>
</cffunction>
<cffunction name="showApplications">
<cfargument name="studentid">
<cfargument name="studentview">
<cfargument name="whichterms">
  
    <cfset dec_code="">
    <cfoutput>
    <cfloop query="apps">
			<cfif app_stu_level eq "UA"><cfcontinue></cfif>
		<!---<cfif app_term_code neq highest_term><cfcontinue></cfif>--->
		<cfinvoke component="counselor/hsguidance" method="getAppDecision" studid="#Session.student_id#" termcode="#APP_TERM_CODE#" appnum="#APP_NO#" returnvalue="true" returnvariable="app_dec_code" /> 
		<cfset dec_code=#app_dec_code#>
		<cfset dec_app_no=#APP_NO#>
		<cfset dec_app_desc=#app_stat_code_desc#>

		<cfif dec_code eq "01" or dec_code eq "10" or dec_code eq "11" or dec_code eq "12" or dec_code eq "15" or dec_code eq "16" or dec_code eq "86" or dec_code eq "87">
				<cfset admitted=true>
			<cfelse>
				<cfset admitted=false>
		</cfif>
		<cfif whichterms eq "accepted" and admitted eq false>
		  <cfcontinue>
		<cfelseif whichterms eq "all" and admitted eq true>
		  <cfcontinue>
		</cfif>
		
		<cfset year=Left(APP_TERM_CODE, 4)>
		<cfinvoke component="counselor/hsguidance" method="getTerm" termcode="#app_term_code#" returnvariable="stringterm" />
		<h3>Application Term: #stringterm# Semester #year#</h3><hr><br>
		
		  <cfquery name="getAcceptanceLetters" datasource="eAcceptance">
			  select * from sent_letters where student_id=#studentid# and (appdate between to_date('#DateFormat(APP_DATE, 'dd-mm-yyyy')#','DD-MM-YYYY') and to_date('#DateFormat(APP_DATE, 'dd-mm-yyyy')# 23:59:59','DD-MM-YYYY hh24:mi:ss')) and appterm='#APP_TERM_CODE#' order by letter_date desc
		  </cfquery>
		  <cfquery name="getSentLetter" dbtype="query">
			  select * from getAcceptanceLetters where student_type<5 or student_type>19 order by letter_date desc
		  </cfquery>
		  <cfquery name="getSALetter" dbtype="query">
			  select * from getAcceptanceLetters where student_type=10 or student_type=11 order by letter_date desc
		  </cfquery>
		  <cfquery name="getSpringDeferLetter" dbtype="query">
			  select * from getAcceptanceLetters where student_type=15 or student_type=16 order by letter_date desc
		  </cfquery>
		  <table width="100%">
		  <cfif getSentLetter.RecordCount gt 0 or getSALetter.RecordCount gt 0>
		    
		    
		    <cfif getSALetter.RecordCount gt 0>
			
			      <tr><td valign="top"><br>
				      <cfif getSALetter.student_type eq 10>
					      <a target="_blank" href="http://www.gsu.edu/success/academy.html">View more information about your Success Academy offer.</a>
				      <cfelseif getSALetter.student_type eq 11>
					      <a target="_blank" href="http://www.gsu.edu/success/SA-PATH.html">View more information about your Success Academy PATH offer.</a>
				      </cfif>
			      </td></tr>
		  
		      </cfif>
		    
		    
		    <tr><td valign="top">
		    
		      <cfinvoke component="counselor/hsguidance" method="getAppDecision" studid="#studentid#" termcode="#APP_TERM_CODE#" appnum="#APP_NO#" returnvalue="true" returnvariable="app_dec_code" />
		      <!---#app_dec_code#--->
			<cfset Session.dec_code=app_dec_code>
			<cfset Session.applicantid=studentid>
			<cfset Session.app_term=app_term_code>
		      
		      <cfif Session.admitted eq false and (getSentLetter.RecordCount gt 0 or getSALetter.RecordCount gt 0)><cfinvoke component="counselor/hsguidance" method="showOfficialLetters"  status="denied" getSentLetter="#getSentLetter#" getSALetter="#getSALetter#" getSpringDeferLetter="#getSpringDeferLetter#"></cfif>
		      <cfif Session.admitted eq true and (getSentLetter.RecordCount gt 0 or getSALetter.RecordCount gt 0)><cfinvoke component="counselor/hsguidance" method="showOfficialLetters" getSentLetter="#getSentLetter#" getSALetter="#getSALetter#" app_term_code="#app_term_code#" applicantid="#studentid#" notmainbox="true" /></cfif>
		      </td>
		
		  </cfif>
		
		<Td valign="top" style="padding-top:4px;">
		<div class="content-section-wrapper">
		<div class="content-section">
		<table width="100%"><tr><td style="padding:0px;margin:0px;">
		
		
		<!---<tr><td colspan="2" valign="top"><h3 style="margin: 0px">Application Term: #stringterm# Semester #year#</h3></td></tr>--->
		<tr><td style="padding-bottom:10px;" width="20%"><b>Application Status:</td><td valign="top" width="30%"> <span class="errortext">
			<cfset couns_decision="">
			
			
			
			

				<cfquery name="getStatuses" datasource="eAcceptance">
					select * from status_explanations where status_code='#app_dec_code#' and info_text is not null
				   </cfquery>
				<cfif app_stat_code eq "C">Complete - Ready for Review<cfelseif app_stat_code eq "I">Incomplete - Items Outstanding<cfelse>#app_stat_code_desc#</cfif> <cfif not cgi.script_name contains "/counselor/"> <cfif getStatuses.RecordCount gt 0><a href="##" class="boxyinfo" id="#app_dec_code#" title="Status Explanation" ><img src="https://app.gsu.edu/calculator/icon_info.gif" border="0" align="top"></a></cfif></cfif>


			</span>
            <br>
            </td>
	    <td style="padding-bottom:10px;" width="20%"><b>Application Type:</b></td><td valign="top" width="30%"> <!--#app_type_desc# changed to:--->#app_stu_type_desc#</td>	
			
            
	    </tr>
	    <cfif Session.mobile eq "true">
	    <tr><td><input type="button" id="expand#APP_TERM_CODE#" value="Expand Application Information" onclick="eval('styleuser#APP_TERM_CODE#.display=styleuser#APP_TERM_CODE#.display? display:display;styleapp#APP_TERM_CODE#.display=styleapp#APP_TERM_CODE#.display? display:display;expand#APP_TERM_CODE#.display=\'none\';collapse#APP_TERM_CODE#.display=collapse#APP_TERM_CODE#.display? display:display;');">
			<input style="display:none;" type="button" id="collapse#APP_TERM_CODE#" value="Collapse Application Information" onclick="eval('styleuser#APP_TERM_CODE#.display=\'none\';styleapp#APP_TERM_CODE#.display=\'none\';expand#APP_TERM_CODE#.display=expand#APP_TERM_CODE#.display? display:display;collapse#APP_TERM_CODE#.display=\'none\';');"></td>
			 <script language="javascript">
					    var browser=navigator.appName.toLowerCase(); 
					    if (browser.indexOf("netscape")>-1) var display="table-row"; 
					    else display="block"; 
					    var style_studentinfo=document.getElementById('studentinformation').style;
					    var style_expandbutton=document.getElementById('expandbutton').style;
					    var style_collapsebutton=document.getElementById('collapsebutton').style;
				    </script></td></tr>
	     </cfif>
		
		    <cfif Session.mobile eq "true"><tbody id="applicationinfo#APP_TERM_CODE#" style="display:none"></cfif>
			    
			    <tr><td style="padding-bottom:10px;"><b>Degree:</b></td><td valign="top">#APP_DEGC_CODE_1_DESC#<cfif isDefined("APP_DEGC_CODE_2_DESC") and APP_DEGC_CODE_2_DESC neq "">, #APP_DEGC_CODE_2_DESC#</cfif></td><td style="padding-bottom:10px;"><b>College:</b></td><td valign="top">
			    <CFINVOKE component="counselor/hsguidance" method="getCollegeAppLink" collcode="#APP_COLL_CODE_1#" returnvariable="link">
			    <cfif Session.studentLevel eq "graduate" and link neq "">
				    <a target="_blank" href="#link#">#APP_COLL_CODE_1_DESC# admissions information</a>
			    <cfelse>#APP_COLL_CODE_1_DESC#
			    </cfif>
	    
			    <cfif APP_COLL_CODE_1 neq APP_COLL_CODE_2>
				    <CFINVOKE component="counselor/hsguidance" method="getCollegeAppLink" collcode="#APP_COLL_CODE_2#" returnvariable="link">
				    <cfif isDefined("APP_COLL_CODE_2_DESC") and APP_COLL_CODE_2_DESC neq "">, 
					    <cfif Session.studentLevel eq "graduate">
						    <a target="_blank" href="#link#">#APP_COLL_CODE_2_DESC#</a>
					    <cfelse>#APP_COLL_CODE_2_DESC#
					    </cfif>
				    </cfif>
			    </cfif></td>
	    
			    <cfset major=#APP_MAJR_CODE_1#>
			    <cfif isDefined("APP_MAJR_CODE_2") and APP_MAJR_CODE_2 neq ""><cfset major=major & ", #APP_MAJR_CODE_2#"></cfif>
			    <cfif isDefined("APP_MAJR_CODE_1_2") and APP_MAJR_CODE_1_2 neq ""><cfset major=major & ", #APP_MAJR_CODE_1_2#"></cfif>
			    <cfif isDefined("APP_MAJR_CODE_2_2") and APP_MAJR_CODE_2_2 neq ""><cfset major=major & ", #APP_MAJR_CODE_2_2#"></cfif>
			    <cfif isDefined("Session.studentLevel") and Session.studentLevel eq "graduate"><tr><td><h3>#APP_COLL_CODE_1_DESC# - #major#</cfif>
			    <tr><td><b>Major:</b></td><td valign="top">#major#</td><td></td></tr>
			    <!---<cfinvoke method="getResInfo" studid="#applicantid#" termcode="#app_term_code#" returnvariable="residency" /> 
			    <cfinvoke method="getResInfo" code="true" studid="#applicantid#" termcode="#app_term_code#" returnvariable="residencycode" />--->
			    <cfif Session.studentLevel eq "graduate" or (Session.studentLevel eq "" and trim(app_stat_code_desc) eq "Accept")><tr><td valign="top" style="padding-bottom:10px;"><b>Residency:</b></td><td valign="top"><cfif isDefined("Session.studentLevel") and Session.studentLevel eq "graduate" and APP_RES_CODE eq 0>Your residency status will be determined at time of admission decision.<cfelse>#APP_RES_CODE_DESC#</cfif></td></tr></cfif>
			    
 
			    
			    </tbody>
		    </table>
				
				</div></div>
		    
		      </Td></Tr>
		  </table>
	
	
	
	
				
			    <cfinvoke component="counselor/hsguidance" method="showAppChecklist" studid="#studentid#" termcode="#APP_TERM_CODE#" appnum="#APP_NO#" collegecode="#APP_COLL_CODE_1#" first="true" app_date="#app_date#"<!---reportexcel="#reportexcel#"=---> studentview="#studentview#" />
			    

			    <cfset prevterm=app_term_code>
			    <cfset first="">
	    <!---<cfbreak>--->
	</cfloop>
    </cfoutput>
</cffunction>
<CFFUNCTION NAME="showApplicationSummary">
<CFARGUMENT NAME="studentid">
<CFARGUMENT NAME="studentview" required="No" default="">
    	<cfinvoke component="counselor/hsguidance" method="getName" studid="#Session.student_id#" returnvariable="name" />
	<cftry>
	<cfset myObj = CreateObject("java", "java.lang.String")/>
	<cfset myStr = myObj.init(name) />
	<cfset lastnamelength=int(Len(name) - myStr.lastIndexOf(' '))>
	<cfset last_name = right(name,lastnamelength) />
	<cfset first_name= #GetToken(name, 1, " ")#>
	<cfcatch></cfcatch>
	</cftry>

	
	<cfinvoke component="counselor/hsguidance" method="getApps" studid="#Session.student_id#" returnvariable="apps"  />
	<cfset accepted_term="">
	<cfset admitted=false>
	<cfloop query="apps">
		<cfinvoke component="counselor/hsguidance" method="getAppDecision" studid="#Session.student_id#" termcode="#APP_TERM_CODE#" appnum="#APP_NO#" returnvalue="true" returnvariable="app_dec_code" />
		<cfset dec_code=#app_dec_code#>
		<cfset dec_app_no=#APP_NO#>
		<cfset dec_app_desc=#app_stat_code_desc#>

		<cfif dec_code eq "01" or dec_code eq "10" or dec_code eq "11" or dec_code eq "12" or dec_code eq "15" or dec_code eq "16" or dec_code eq "86" or dec_code eq "87">
		      <cfif accepted_term neq ""><cfset accepted_term=accepted_term&","></cfif>
		      <cfset accepted_term=accepted_term&"#APP_TERM_CODE#">
		      <cfset admitted=true>
		      <cfset appdate=app_date>
		</cfif>
	</cfloop>
	<!---<cfset dec_code="">
	<cfloop query="apps">
		<cfif app_term_code neq accepted_term><cfcontinue></cfif>
		<cfinvoke component="counselor/hsguidance" method="getAppDecision" studid="#Session.student_id#" termcode="#APP_TERM_CODE#" appnum="#APP_NO#" returnvalue="true" returnvariable="app_dec_code" /> 
		<cfset dec_code=#app_dec_code#>
		<cfset dec_app_no=#APP_NO#>
		<cfset dec_app_desc=#app_stat_code_desc#>
	</cfloop>



	<cfif dec_code eq "01" or dec_code eq "10" or dec_code eq "11" or dec_code eq "12" or dec_code eq "15" or dec_code eq "16" or dec_code eq "86" or dec_code eq "87">
			<cfset admitted=true>
		<cfelse>
			<cfset admitted=false>
	</cfif>--->
	
	<cfif admitted eq true><cfinvoke method="showWelcomeBanner" appterm="#accepted_term#" dec_code="#dec_code#" dec_app_no="#dec_app_no#" app_stat_code_desc="#dec_app_desc#" app_date="#appdate#" /><!---only if accepted!!!---></cfif>

     <cfinvoke method="addZeros" panther_id="#Session.student_id#" returnvariable="panther_no" />
        <cfif not isDefined("URL.refresh")>
            <cfquery name="insertLogin" datasource="eAcceptance">
                insert into student_clicks (click_id, panther_id, click_event, click_date, user_agent) values (studentclicks_seq.NEXTVAL, '#panther_no#', 2, #NOW()#, '#Left(CGI.HTTP_USER_AGENT, 499)#')
            </cfquery>
        </cfif>
	<cfinvoke component="counselor/hsguidance" method="showApplicantStatus" applicant_id="#studentid#" studentview="#studentview#" />
    <!---<cfif Session.mobile eq "true">
    	<a name="disclaimer"></a>
    	<hr style="color:black;">
    	<cfinvoke method="showDisclaimer"/>
        <hr>
    </cfif>--->
</CFFUNCTION>
<CFFUNCTION NAME="showDisclaimer">
	<cfif Session.studentLevel eq "graduate">
		<p>If you are an international applicant with questions on immigration issues, please contact <a target="_blank" href="http://www.gsu.edu/es/22891.html">International Student & Scholar Services</a>.</p>
		<!---<p><i>Disclaimer: </i>If an application is complete but no decision has been made, please keep checking for updates.</p>
		<p><i><b>Disclaimer: </b>Please allow at least two weeks from the time documents are mailed to the Office of Undergraduate Admissions to be processed and visible in our system.</i></p>--->
	<cfelse>
	 	<!---<p>This summary is prepared from preliminary data and may be revised or updated.</p>
		<p>An authorized notice of final application status will be sent individually from the university directly to you. Information on this page does not constitute official notification of acceptance or denial.</p>
		<p>If you have questions about the timeliness or accuracy of any information displayed, please contact your <a target="_blank" href="http://admissions.gsu.edu/category/advisor/">admissions counselor</a>.</p>--->
	
     <!--- this will only show up if accepted --->
<!---         
        <p>Next Step for Accepted Undergraduate Students, <a target="_blank" href="http://www.gsu.edu/admissions/28264.html">click here</a>.</p>
		
 --->        
        
        
        
        <p>Please check back regularly for updates to your status!</p>
		<!---<p><b>Note: </b>Your panther number shown below will serve as your student identification number in the Georgia State University system.</b></p>--->
		<p><i><b>Disclaimer: </b>Please allow at least two weeks from the time documents are mailed to the Office of Undergraduate Admissions to be processed and visible in our system.</i></p>
        <p><b>Note: </b>To change your Student Information, please go to the <a target="_blank" href="http://registrar.gsu.edu/assistance/">Enrollment Services Center</a> or log into <a target="_blank" href="https://paws.gsu.edu/cp/home/displaylogin">PAWS</a> with your campus id and password.</p>
	</cfif>
</CFFUNCTION>
<CFFUNCTION NAME="getStudentLevel">
<CFARGUMENT NAME="studid" required="Yes">
	<cftry>
		<cfstoredproc  procedure="wwokbapi.f_get_app" datasource="#Session.odatasource#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#studid#"> 
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_term_code" type="in" value="TERM"> 
		<cfprocresult name="out_result_set">
		</cfstoredproc>
		<cfreturn out_result_set>
	<cfcatch>
		<cfset query=QueryNew("")>
		<cfreturn query>
	</cfcatch>
	</cftry> 
</CFFUNCTION>
<cffunction name="logOutOfSystem">
	<cfset Session.student_id="">
	<cfset Session.studentLevel="">
	<cfif cgi.server_name eq "webdb.gsu.edu">
		<cfcache action="flush" timespan="0" directory="d:/Inetpub/applicantstatus/">
	<cfelseif cgi.server_name eq "istcfdev.gsu.edu" or cgi.server_name eq "istcfqa.gsu.edu">
		<cfcache action="flush" timespan="0" directory="D:/inetpub/cf-qa/applicantstatus/">
	</cfif>
	<cfset StructClear(Session)>
	<cflogout>
</cffunction>
<CFFUNCTION NAME="getStudentHS">
<CFARGUMENT NAME="studid">
	<cftry>
		<cfstoredproc  procedure="wwokbapi.f_get_hsch" datasource="#Session.odatasource#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#studid#"> 
		<cfprocresult name="out_result_set">
		</cfstoredproc>
		<cfreturn out_result_set.hs_name>
	<cfcatch>
		<cfreturn "">
	</cfcatch>
	</cftry> 
</CFFUNCTION>
<cffunction name="showBanner">
	<cfset curfilename=GetFileFromPath(cgi.script_name)>
	<div class="grid_6" <!---<cfif isDefined("URL.faq")>style="height:130px"</cfif>---> style="white-space:nowrap">
    	<cfif Session.mobile eq "true"><span style="float:right;display:inline;font-size:10px;"> <cfif isDefined("Session.student_id") and Session.student_id neq ""><a style="color:white;" href="index.cfm?logout=true">LOGOUT</a></cfif></span></cfif>
        <cfoutput>
        <span class="logo" style="display:inline;"><cfif isDefined("Session.scholarship_letter_id") and Session.scholarship_letter_id neq "" and (curfilename eq "acceptance_form.cfm" or curfilename eq "scholarship_rules_form.cfm" or curfilename eq "showAcceptedForm.cfm")><a href="viewYourScholarshipLetter.cfm?letter_id=#Session.scholarship_letter_id###zoom=100"><cfelse><a href="index.cfm?option=1"></cfif><cfif Session.mobile eq "false"><img src="/ApplicationTemplateCSS/images/gsulogo_departonlybanner.gif" width="109" height="84" alt="Georgia State University"  border="0"><cfelseif isDefined("URL.faq") or curfilename eq "acceptance_form.cfm" or curfilename eq "scholarship_rules_form.cfm" or curfilename eq "showAcceptedForm.cfm" or curfilename eq "viewSentLetterIntro.cfm" or curfilename eq "viewYourScholarshipletter.cfm"><img class="backbutton" height="40" src="admin/images/mobile/backbutton1.jpg" border="0" /><cfelse><img  src="admin/images/mobile/logo3.jpg" height="60px" border="0" /></cfif></a></span>
      <cfif Session.mobile eq "true"><p style="margin:20px;"></p></cfif><span class="appname" style="display:inline;">Admissions<cfif Session.mobile eq "false"><br></cfif>
        Status Check</span>
        </cfoutput>
        		<cfif Session.mobile eq "true">
         <br><br><div class="grid_10 toolbar" <!---<cfif Session.mobile eq "true">style="font-size:20px;white-space:nowrap; text-align:right; margin-right:100px;"</cfif>>Logged in as: --->><cfoutput>
            
                <cftry>
                    <cfinvoke component="counselor/hsguidance" method="getName" studid="#Session.student_id#" returnvariable="name" />#name#
                <cfcatch>
                    <cflocation url="index.cfm?logout=true" addtoken="no">
                </cfcatch>
                </cftry>
                <cfif Session.studentLevel neq "graduate">
                    <cfinvoke component="applicantStatus" method="getStudentHS" studid="#Session.student_id#" returnvariable="hs" />
                    <cfif hs neq "">, #hs#</cfif>
                </cfif>
             
            </cfoutput> <!---| <a href="javascript:open_window('help.html', 'Help', 'width=600,height=300,scrollbars=yes')">HELP</a>---></div>
            </cfif>
    </div>
</cffunction>

<CFFUNCTION NAME="showAddlInfo">
	<h3>Additional Graduate Student Information</h3>
	<ul>
		<li><a target="_blank" href="http://aysps.gsu.edu/index.html">Andrew Young School of Policy Studies</a></li>
		<li><a target="_blank" href="http://www.cas.gsu.edu/grad_admission.html">College of Arts & Sciences</a></li>
		<li><a target="_blank" href="http://education.gsu.edu/main/">College of Education</a></li>
		<li><a target="_blank" href="http://snhp.gsu.edu/">Byrdine F. Lewis School of Nursing and Health Professions</a></li>
		<li><a target="_blank" href="http://robinson.gsu.edu/index.html">J. Mack Robinson College of Business</a></li>
		<li><a target="_blank" href="http://law.gsu.edu">College of Law</a></li>
	</ul>
</CFFUNCTION>
<CFFUNCTION NAME="faqBox">
	<h3>Frequently Asked Questions</h3>
    <form><a id="testLink"  href="<cfif Session.mobile eq "true">index.cfm?faq=true<cfelse>faq/faq.cfm</cfif>" title="Student FAQ" rel="gb_page_center[1000, 525]">Visit our FAQ</a></form>
</CFFUNCTION>
<CFFUNCTION NAME="contactAdmissions">
<cfargument name="student" default="">
	<h3>Inquiry? Issue? Contact the Office of Undergraduate Admissions</h3>
	<form>
	<b>Phone:</b> <cfif student eq "">404-413-2039<cfelse>404-413-2500</cfif><br>
	<b>Email:</b> <a href="mailto:admissions@gsu.edu">admissions@gsu.edu</a><br>
	<b>In person:</b> 200 Sparks Hall<br><Br>
	<b>Mailing Address:</b><br>
	Office of Undergraduate Admissions<br>P.O. Box 4009<Br>Atlanta, GA 30302-4009
	</form>
</CFFUNCTION>
<CFFUNCTION NAME="addZeros">
<cfargument name="panther_id">
	<cfloop index="i" from="1" to="9">
    	<cfif Len(panther_id) neq 9><cfset panther_id="0"&panther_id></cfif>
    </cfloop>
    <cfreturn panther_id>
</CFFUNCTION>

<cffunction name="showerrors">
<cfargument name="message" required="no" default="">
<cfargument name="detail" required="no" default="">
<cfargument name="errorcode" required="no" default="">
<!---1 #cfcatch.type#<br>
2 #cfcatch.message#<br>
3 #cfcatch.detail#
4 #cfcatch.tagcontext#<br>
5 #cfcatch.NativeErrorCode#<br>
6 #cfcatch.SQLState#<br>
7 #cfcatch.Sql#<br>
8 #cfcatch.queryError#<br>
9 #cfcatch.where#<br>
10 #cfcatch.ErrNumber#<br>
11 #cfcatch.MissingFileName#<br>
12 #cfcatch.LockName#<br>
13 #cfcatch.LockOperation#<br>
14 #cfcatch.ErrorCode#<br>
15 #cfcatch.ExtendedInfo#--->
<!---#cfcatch.NativeErrorCode#--->
<cfif isDefined("cfcatch.NativeErrorCode")>
	<cfset error_code=cfcatch.NativeErrorCode>
<cfelse>
	<cfset error_code=errorcode>
</cfif>
<cfif error_code neq "">
	<cfset error="<p class='errortext'><i>">
	<cfif error_code eq 20101><cfset error=error & "Access Denied">
	<cfelseif error_code eq 20102><cfset error=error & "Confidential Student Info">
	<cfelseif error_code eq 20103><cfset error=error & "We could not locate the application based on the information provided below.  Please check that the data entered is correct and try again.">
	<cfelseif error_code eq 20104><cfset error=error & "Invalid Parameter.">
	<cfelseif error_code eq 20105><cfset error=error & "Invalid Student Id">
	<cfelseif error_code eq 20106>
		<cfif Form.stud_panther_number neq "">
			<cfset error=error & "Your Panther## is a duplicate. Please contact the Office of Undergraduate Admissions at 404-413-2500 with this problem.<br>If you are a graduate student, please <a href='http://www.gsu.edu/graduate_admission.html'>contact your graduate admissions office</a>.">
		<cfelseif Form.stud_four_digits_ssn neq "">
			<cfset error=error & "Insufficient Information to retrieve your record.<br>Please use Panther## to check your application status.<br>If you do not know your Panther##, please contact the Office of Undergraduate Admissions at 404-413-2500 with this problem.<br>If you are a graduate student, please <a href='http://graduate.gsu.edu/'>contact your graduate admissions office</a>.">
		<cfelse>
			<cfset error=error & "Bad data present for id.  This is an internal database error.  Please contact the DBA.">
		</cfif>
	<cfelseif error_code eq 20107><cfset error=error & "20107 Unknown exception. This is an internal database error.  Please contact the DBA.">
	<cfelseif error_code eq 20108><cfset error=error & "No Active Academic Info For Student">
	<cfelseif error_code eq 20109><cfset error=error & "No Registration Info For Student">
	<cfelseif error_code eq 1034 or error_code eq 7429>
		<cfmail
		from="christina@gsu.edu"
		replyto = "christina@gsu.edu"
		to="christina@gsu.edu"
		bcc="christina@gsu.edu"
		subject="Banner Down"
		SERVER="mail.gsu.edu">
		The student has been redirected to the scholarships home page.
		
		<cfif isDefined("Cookie.campusid")><cfoutput>#Cookie.campusid#</cfoutput></cfif>
		</cfmail>
		<cflocation url="banner_down.cfm">
		<cfexit>
	<cfelse>
		<cfset error=error & "Banner error #error_code#.">
	</cfif>
	<cfset error=error & "</i></p>">
	<cfreturn error>
<cfelse>
	<cfif isDefined("cfcatch.message")><cfreturn "#cfcatch.message# #cfcatch.detail#">
	<cfelseif isDefined("cfcatch.detail")><cfreturn "#cfcatch.detail#">
	<cfelseif isDefined("cfcatch.type")><cfreturn "#cfcatch.type#">
	<cfelse>
		<cfmail
		from="christina@gsu.edu"
		replyto = "christina@gsu.edu"
		to="christina@gsu.edu"
		bcc="christina@gsu.edu"
		subject="app status"
		SERVER="mailhost.gsu.edu">
		Error in App Status that does not have message or detail.
		<cfoutput>
		<cfif isDefined("cgi.HTTP_REFERER")>#cgi.HTTP_REFERER#</cfif>
		<cfif isDefined("Session.student_id")>#Session.student_id#</cfif>
		<cfif isDefined("Session.studentLevel")>#Session.studentLevel#</cfif>
		<cfif isDefined("Session.returning_student")>#Session.returning_student#</cfif>
		<cfif isDefined("session.option")>#Session.option#</cfif>
		<cfif isDefined("message")>#message#</cfif>
		<cfif isDefined("detail")>#detail#</cfif>
		#DateFormat(NOW(), "mm/dd/yyyy")# #TimeFormat(NOW(), "hh:mm tt")#
		</cfoutput>
		</cfmail>
		<cfreturn "">
	</cfif>
	<!---<cfmail
		from="christina@gsu.edu"
		replyto = "christina@gsu.edu"
		to="christina@gsu.edu"
		bcc="christina@gsu.edu"
		subject="Scholarships File Upload Error"
		SERVER="mail.gsu.edu">
		Native Error code was not defined in Banner API.
		
		#DateFormat(NOW(), "mm/dd/yyyy")# #TimeFormat(NOW(), "hh:mm tt")#
		</cfmail>--->
</cfif>
</cffunction>


<cffunction name="showScholarshipLetter">
  <cfargument name="apptermcode">
    <cftry>
              <cfstoredproc  procedure="wwokbapi.f_get_sch_cohort" datasource="#Session.odatasource#">
              <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#Session.student_id#"> 
              <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="app_term_code" type="in" value="#apptermcode#"> 
              <cfprocresult name="out_result_set_cohort">
              </cfstoredproc>
	      
              <cfcatch>
                 <cfoutput>11<B>#cfcatch.message# -> #cfcatch.detail#</B>11<br /><br /></cfoutput>
              </cfcatch>
          </cftry>
          	<cftry>
            <cfstoredproc procedure="wwokbapi.f_get_pers" datasource="SCHOLARSHIPAPI">
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#Session.student_id#"> 
                <cfprocresult name="pers_info">
            </cfstoredproc>
            <cfcatch>
            <cfoutput>22<B>#cfcatch.message# -> #cfcatch.detail#</B>11<br /><br /></cfoutput>
            </cfcatch>
            </cftry>
            <!---<cfif pers_info.citz_code eq "" or (Trim(LCase(pers_info.citz_code)) eq "a" and (Trim(pers_info.visa_type) eq "" or Trim(LCase(pers_info.visa_type)) eq "no" or Trim(LCase(pers_info.visa_type)) eq "un"))>--->
	    <cfif Trim(LCase(pers_info.citz_code)) eq "a" and (Trim(pers_info.visa_type) eq "" or Trim(LCase(pers_info.visa_type)) eq "no" or Trim(LCase(pers_info.visa_type)) eq "un")>
				<cfset residenttype="NR">
				<cfset has_ost=false>
				<cfset has_nonost=false>
				<cfloop query="out_result_set_cohort">
					<cfif scholarship_code eq "OSTWO" or scholarship_code eq "OSTW50"><cfset has_ost=true></cfif>
					<cfif scholarship_code neq "OSTWO" and scholarship_code neq "OSTW50"><cfset has_nonost=true></cfif>
				</cfloop>
				<cfif has_ost eq true and has_nonost eq false><cfset donotdisplaytaxinfo=true><cfset residenttype="R">
				<cfelse><cfset donotdisplaytaxinfo=false>
				</cfif>
            <cfelse>
            	<cfset residenttype="R">
            </cfif>
            
          
            <!---FIRST CHECK RESIDENCY TYPE!!!!!!!!!!!!!!!!!!!!!!!!!--->
                <cfquery name="getResidencyParagraph" datasource="eAcceptance">
                    select * from residency_extra_info where info_type='paragraph1'
                </cfquery>
                  <cfloop query="getResidencyParagraph">
                    <cfset "paragraph#residency_type#"="<br>#info_text#">
                </cfloop>
                <!---GET OTHER CUSTOM PARAGRAPHS!!!!!!!!!!!!!!!!!!!!!!!!!--->
                    <cfquery name="getCustomParagraphs" datasource="eAcceptance">
                    select * from custom_paragraphs
                </cfquery>
                <cfloop query="getCustomParagraphs">
                    <cfset "#paragraph_type#Paragraph"="<br>#getCustomParagraphs.paragraph_text#">
                </cfloop>
    
               
		
            <cfif isDefined("scholarship#residenttype#Paragraph")><cfset scholText=""><cfif residenttype eq "NR"><cfset scholText="<div style='background-color:##FAF0DC'>"></cfif><cfset scholText=scholText&"#Evaluate('scholarship#residenttype#Paragraph')#"><cfif residenttype eq "NR"><cfset scholText=scholText&"</div>"></cfif></cfif>
	    <cfif residenttype eq "NR"><cfset scholText=scholText&"<!---UNCOMMENT THIS IF NON-RESIDENT ALIENS SHOULD SEE/ACCEPT THEIR SCHOLARSHIP FORMS!!If you are ready to accept your scholarships: ---><br>[AWARDED SCHOLARSHIPS]"></cfif>
            <cfset nonelisted=true>
            <cfset newScholList="<ul>">
	    
	    
           <!---<cfloop list="#scholList#" index="scholid">--->
           <cfloop query="out_result_set_cohort">
	    <cfset found_both="">
	    <cfset form_="">
	   <cfset scholid="">
           	<cfset scholid=scholarship_id>
		<cfset scholcode=scholarship_code>
		<cfset scholtype=scholarship_type>
		<cfset scholdesc=scholarship_description>
		<cfset scholamount=scholarship_amount>
		<cfset gpatext=scholarship_gpa_req>
			<!---check to see if accepted yet--->
                              <cfquery name="checkScholAccepted" datasource="eAcceptance">
                                select * from scholarship_forms_archive where panther_id='#Session.student_id#' <cfif scholid neq "" and scholid neq 1345>and scholarship_id=#scholid#</cfif>
                              </cfquery>
			<!---why was this in here? 4/2/2015, in this case it took berners out for 002179335<cfif isDefined("form_#scholid#")></ul><li></li><cfcontinue></cfif>--->
                    <cfset newScholList=newScholList & '<li>#scholarship_description#:&nbsp; '>
                       
                      
                     <cfif 1 eq 1 <!---residenttype neq "NR" or donotdisplaytaxinfo eq true--->>
                        <cftry>
                          <cfstoredproc  procedure="wwokbapi.f_get_sch_forms" datasource="#Session.odatasource#">
                          <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#Session.student_id#"> 
                          <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="app_term_code" type="in" value="#apptermcode#"> 
                          <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="scholarship_code" type="in" value="#scholarship_code#"> 
                          <cfprocresult name="out_result_set_cohort1">
                          </cfstoredproc> 
                          <cfcatch>
                             <cfoutput>22<B>#cfcatch.message# -> #cfcatch.detail#</B>22<br /><br /></cfoutput>
                          </cfcatch>
                      </cftry>
                      <cfset count=1>
                      <!---<cfset newScholList=newScholList & '<ul>'>--->
		      <cfset form_list="SGFRM, SRFRM">
			<cfset newScholList=newScholList&'<ul>'>
			
			<!---check ahead of time to see if has both forms so can combine them--->
		      <cfset found_sg=false><cfset found_sr=false>
		      <cfoutput query="out_result_set_cohort1">
			  <cfif form_code eq "SGFRM"><cfset found_sg=true></cfif>
			  <cfif form_code eq "SRFRM"><cfset found_sr=true></cfif>
		      </cfoutput>
		      <cfif found_sg eq true and found_sr eq true><cfset found_both=true>
		      <cfelse><cfset found_both=false></cfif>
			
                      <cfoutput query="out_result_set_cohort1">
			  <cfset scholtext=scholtext>
			  <cfif form_code eq "SGFRM">
			    <cfset cz_form_code=2>
                            <cfelseif form_code eq "SRFRM">
                                <cfset cz_form_code=1>
                            <cfelse>
                            	<cfset cz_form_code=3>
                            </cfif>
			  
			   <!---check to see if accepted yet--->
                              <cfquery name="checkAccepted" datasource="eAcceptance">
                                select * from scholarship_forms_archive where panther_id='#Session.student_id#' and form_type=#cz_form_code# <cfif scholid neq "" and scholid neq 1345>and scholarship_id=#scholid#</cfif> <cfif scholcode neq "" and scholcode neq "OSTWO">and scholarship_code='#scholcode#'</cfif>  and TO_CHAR(form_date,'YYYY')=#Year(NOW())#
                              </cfquery>
				
                           <cfif isDefined("form_#scholid#") and Evaluate("form_#scholid#") neq ""><cfset newScholList=newScholList&'</ul></li>'><cfcontinue></cfif>
			      <cfset newScholList=newScholList&'<li type="circle">'>
			
                            
                            
                            
                           
                            
                            <cfif checkAccepted.RecordCount eq 0>
				<cfset acceptLink=''>
				<!--- <cfif 1 eq 1> --->  <!--- mick comment out and change the date per gregs request for may 1 deadline --->
             <!---    After May 1, only students with Second Century, 1913, Excellence, GSU Achievement and GSU Foundation awards who are incoming students (entry term 201408) and have not yet accepted forms should no longer see their award links.  ---> 
				<cfif 1 eq 1>
				<!---<cfif #DateCompare("#NOW()#", "#CreateDateTime(2015, 5, 17, 23, 59, 59)#", "n")# eq -1 or (scholcode neq "AF1SCH" and scholcode neq "AF2SCH" and scholcode neq "EXA" and scholcode neq "HSR" and scholcode neq "HSR2")>---><!---Session.returning_student eq "true" or #DateCompare("#NOW()#", "#CreateDateTime(2014, 5, 1, 23, 59, 59)#", "n")# eq -1 or (scholcode neq "AF1SCH" and scholcode neq "AF2SCH" and scholcode neq "EXA" and scholcode neq "HSR" and scholcode neq "HSR2")>--->
				<!---<cfif #DateCompare("#NOW()#", "#CreateDateTime(2013, 5, 1, 23, 59, 59)#", "n")# eq -1 or (scholcode neq "AF1SCH" and scholcode neq "AF2SCH" and scholcode neq "EXA" and scholcode neq "HSR" and scholcode neq "HSR2")>--->
				<!---<cfif #DateCompare("#NOW()#", "#CreateDateTime(2013, 5, 1, 23, 59, 59)#", "n")# eq -1 or (scholcode neq "AF1SCH" and scholcode neq "AF2SCH" and scholcode neq "EXA" and scholcode neq "HSR" and scholcode neq "HSR2")>--->
					<cfset newScholList=newScholList&'<a '>
					<cfset newScholList=newScholList&'target="_blank"'>
					<cfset newScholList=newScholList&' href="'>
					
					  <cfset acceptLink=''>
					  <!---<cfset acceptLink='/applicantstatus/'>--->
					  <cfif found_both eq true><cfset acceptLink=acceptLink & 'scholarship_combined_form.cfm'><cfelseif form_code eq "SGFRM"><cfset acceptLink=acceptLink & 'scholarship_rules_form.cfm'><cfelseif form_code eq "SRFRM"><cfset acceptLink=acceptLink & 'acceptance_form.cfm'><cfelse><cfset acceptLink=acceptLink & 'outofstate_form.cfm'></cfif>
					  <cfset acceptLink=acceptLink & '?schol_id=#scholid#&appterm=#apptermcode#&schol_code=#scholcode#'>
					  <cfif isDefined("URL.panid")><cfset acceptLink=acceptLink & '&panid=#URLEncodedFormat(URL.panid)#'></cfif>
					  <!---<cfif form_code eq "SRFRM">
					      <cfset newScholList=newScholList & '&scholtype=#getCode.scholarship_type#'>
					  </cfif>--->
					  <cfif GetFileFromPath(cgi.script_name) eq "sendLetters.cfm"><cfset acceptLink=acceptLink&'&stud=<!---#studentset["STUDENT_ID"][studentsetrow]#--->#getLetter.student_id#'></cfif>
					  <cfset newScholList=newScholList&acceptLink&'">'>
				</cfif>
				
                            <cfelse>
                            	<cfset newScholList=newScholList & '<a '>
                               
				  <cfset newScholList=newScholList&'target="_blank"'>
				  <cfset newScholList=newScholList & ' href="showCombinedAcceptedForm.cfm?scholid=#scholid#&scholcode=#scholcode#&formtype=#cz_form_code#'>
				  <cfif isDefined("URL.panid")><cfset newScholList = newScholList & '&panid=#URLEncodedFormat(URL.panid)#'></cfif>
				  <cfset newScholList=newScholList & '##zoom=100">'>
				
                                
                            </cfif>
                            <cfif found_both eq true>
			      <cfset newScholList=newScholList&'Scholarship Form</a>'>
			    <cfelse>
			      <cfset newScholList=newScholList&'#form_description#</a>'>
			    </cfif>
			   
			      <cfif checkAccepted.RecordCount gt 0><cfset newScholList=newScholList&' (Accepted)'>
							<cfelseif acceptLink neq "">
								<cfset newScholList=newScholList&' <span style="color:red;font-weight:bold"><a '>
                                <cfif Session.mobile eq "false"><cfset newScholList=newScholList&'target="_blank"'></cfif>
                                <cfset newScholList=newScholList&' href="#acceptLink#" style="color:red;font-weight:bold;text-decoration:none">(Click to Review and Accept)</a></span>'>
				<cfelse><cfset newScholList=newScholList&' (Scholarship Acceptance Deadline has passed)'>
							</cfif>
			      
			    
                            <cfset newScholList=newScholList&'</li>'>
                            <cfif count eq 1><cfset newScholList=newScholList&''></cfif>
                            <cfset count=count+1>
			    <cfif found_both eq true><cfset nonelisted=false><cfset Variables["form_#scholid#"]="found"></cfif>
			    
                        </cfoutput>
                        <cfset newScholList=newScholList&'</ul></li>'>
		     </cfif>
                    <!---<cfelse>
                        <cfset newScholList=newScholList & "<li>Not found</li>">
                    </cfif>--->
                    <cfset nonelisted=false>
               
            </cfloop>
             <cfset newScholList=newScholList & "</ul>">
            <cfif nonelisted eq true>
                <cfset final_text=Replace('#scholText#', '[AWARDED SCHOLARSHIPS]', 'None', 'all')>
            <cfelse>
	      
		<cfset final_text=Replace('#scholText#', '[AWARDED SCHOLARSHIPS]', '#newScholList#', 'all')>
	      
            </cfif>
            
            
            <cfif 1 eq 1>
                <cftry>
                    <cfstoredproc  procedure="wwokbapi.f_get_general" datasource="#Session.odatasource#">
                    <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#Session.student_id#"> 
                    <cfprocresult name="out_result_set">
                    </cfstoredproc> 
                    <cfset final_text=Replace(final_text, "[STUDENT NAME]", "#out_result_set.first_name# #out_result_set.mi# #out_result_set.last_name#")>
                <cfcatch>
                   <cfoutput>77<B>#cfcatch.message# -> #cfcatch.detail#</B>77<br /><br /></cfoutput>
                </cfcatch>
                
                </cftry>
                <cftry>
                    <cfstoredproc  procedure="wwokbapi.f_get_addr" datasource="#Session.odatasource#">
                    <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#Session.student_id#"> 
                    <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_address_type" type="in" value="MA"> 
                    <cfprocresult name="out_result_set_address">
                    </cfstoredproc> 
                    <cfset final_text=Replace(final_text, "[ADDRESS 1]", "#out_result_set_address.street_line1#", "all")>
                    <cfset final_text=Replace(final_text, "[ADDRESS 2]", "#out_result_set_address.street_line2#", "all")>
                    <cfset final_text=Replace(final_text, "[CITY]", "#out_result_set_address.city#", "all")>
                    <cfset final_text=Replace(final_text, "[STATE]", "#out_result_set_address.state#", "all")>
                    <cfset final_text=Replace(final_text, "[ZIP CODE]", "#out_result_set_address.zip#", "all")>
                <cfcatch>
                    <cfoutput>88<B>#cfcatch.message# -> #cfcatch.detail#</B>88<br /><br /></cfoutput>
                </cfcatch>
                </cftry>
                <cfset final_text=Replace(final_text, "[PANTHER NUMBER]", "#Session.student_id#", "all")>
            </cfif>
            <!---<cfcatch>
                <cfoutput>66<B>#cfcatch.message# -> #cfcatch.detail#</B>66<br /><br /></cfoutput>
            </cfcatch>
            </cftry>--->
            <cfset final_text=Replace('#final_text#', '[DATE]', '#DateFormat(NOW(), "mmmm d, yyyy")#', 'all')>
            <cfoutput>#final_text#</cfoutput>
        
</cffunction>
<cffunction name="showFooter">
	</div>
      <!--Content End-->
      <!--Right Rail Start
      <div class="grid_4">-->
        <!--	  Release Status Box and Form Start-->
		<!---<cfif isDefined("URL.option")>
		<div id="release">
		  <cfinvoke component="counselor/hsguidance" method="showCommonRequestsForm" student="true" />
		</div>
		</cfif>--->
		<!---<cfif isDefined("Session.student_id") and Session.studentLevel eq "graduate">
		<div id="release">
		  <cfinvoke component="applicantStatus" method="showAddlInfo" student="true" />
		</div>
		<cfelseif isDefined("Session.student_id") and Session.student_id neq "">
			<cfif Session.mobile eq "false">
                <div id="release">
                  <cfinvoke component="applicantStatus" method="faqBox" />
                </div>
                <div id="release">
                  <cfinvoke component="applicantStatus" method="contactAdmissions" student="true" />
                </div>
            </cfif>
		</cfif>--->
        <!--	  Release Status Box and Form End-->
      	
	<!--Right Rail End-->
      </div>
      <div class="clear"></div>
    </div>
    <div class="clear"></div>
    <div class="container_16 footer">
      <cfinvoke component="counselor/hsguidance" method="showPageFooter" />
    </div>
    <div class="clear"></div>
  </div>	
    <!-- Footer End -->
    <script type="text/javascript">
	  var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
	  document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
	  </script>
	  <script type="text/javascript">
	  try {
	  var pageTracker = _gat._getTracker("UA-411467-1");
	  pageTracker._trackPageview();
	  } catch(err) {}</script>
  </div>
  
  <!---<script type="text/javascript">
	  if (screen.availHeight=="460")document.getElementById('footer').style.marginBottom='0px';
  </script>--->
  
  <script>
    $(function() {
      $('.wrapper').show();
    });
  </script>
  
  </body>
  </html>
</cffunction>