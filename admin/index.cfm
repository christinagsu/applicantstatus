<!---<cferror type="request" mailto="christina@gsu.edu" template="counselor/admin_error.cfm">
<cferror type="exception" mailto="christina@gsu.edu" template="counselor/admin_error.cfm">--->

  
<cfapplication name="applicantstatusAppAdmin" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>
     
 <cfset Session.admin_appstatus_user=true> 
   <cfset Session.mobile = "false">
   
<cfif not isDefined("Session.app_referrer")><cfset Session.app_referrer=""></cfif>
<cfif isDefined("Form.submittedadmissionsform")><cfset Session.app_referrer="admissionsform"></cfif>
<!---<cfset referrer=cgi.http_referer>
<cfif referrer does not contain "/applicantstatus/" and referrer neq "">
	<cfset Session.app_referrer=#referrer#>
</cfif>--->

    
<cfif cgi.server_name eq "webdb.gsu.edu" and SERVER_PORT eq 80><cflocation url="https://webdb.gsu.edu/applicantstatus/admin"></cfif>
<cfif cgi.server_name eq "istcfqa.gsu.edu" and SERVER_PORT eq 80><cflocation url="https://istcfqa.gsu.edu/applicantstatus/admin"></cfif>
<cfif cgi.server_name eq "app.gsu.edu" and SERVER_PORT eq 80><cflocation url="https://app.gsu.edu/applicantstatus/admin"></cfif>  
  
<cfoutput><cfif not isDefined("URL.refresh") and isDefined("Form.username") and not isDefined("URL.error_occurred")>
	<script>
	var URL=document.location;
	if (location.search.indexOf("?")==-1) 
		URL=URL+"?";
	else URL=URL+"&";
	URL=URL+"refresh=true";
	document.location=URL;
	</script>
</cfif></cfoutput>      
       
<cfif isDefined("URL.logout")>
	<cfset Session.admin_appstatus_user="">
	<cfset Session.student_id="">
	<cfset Session.studentLevel="">
    <cfset cookie.UserAuth=false and cgi.server_name eq "webdb.gsu.edu">
	<cfif cgi.server_name eq "webdb.gsu.edu"><cfcache action="flush" timespan="0" directory="d:/Inetpub/applicantstatus/"></cfif>
</cfif>

<cfif not isDefined("cookie.UserAuth") or cookie.UserAuth eq false or isDefined("URL.logout")>
	<cflocation url="login.cfm">  
</cfif>

<cfquery name="getUsers" datasource="eAcceptance">
    	select * from users
    </cfquery>
    <cfset adminlist=ValueList(getUsers.CAMPUS_ID)>
    <cfif ListFind(#adminlist#, #Cookie.campusid#) eq 0>
      <cfset cookie.UserAuth=false>
      <cflocation url="login.cfm">
    </cfif>

<cfset cookie.high_school_code="">

<cfif isDefined("URL.option")>
	<cfset Session.option = URL.option>
<cfelseif isDefined("Form.option")>
	<cfset Session.option = Form.option>
</cfif>
<cfif not isDefined("Session.option") or Session.option eq ""><cfset Session.option=1></cfif>
<cfif cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "glacierqa.gsu.edu">
	<cfset Session.datasource="hsguidance_dev">
	<!---<cfset Session.odatasource="hsguidanceoracle_student">--->
	<!---<cfset Session.odatasource="hsguidanceoracle_B8QA">--->
	<cfset Session.odatasource="hsguidanceoracle">
<cfelse>
	<cfset Session.datasource="hsguidance">
	<!---<cfset Session.odatasource="hsguidanceoracle_student">--->
	<!---<cfset Session.odatasource="hsguidanceoracle">--->
	<cfset Session.odatasource="hsguidanceoracle">
</cfif>

<cfif isDefined("Session.student_id") and Session.student_id neq "" and not isDefined("URL.logout")>
	<cfinvoke component="/applicantstatus/applicantStatus" method="getStudentLevel" returnvariable="app" studid="#Session.student_id#" />
	<cfoutput query="app">
		<!---<cfoutput>#APP_STU_LEVEL#</cfoutput>--->
		<cfif app_stu_level eq "GS" or app_stu_level eq "GR" or app_stu_level eq "LW">
			<cfset Session.studentLevel="graduate">
		<cfelse>
			<cfset Session.studentLevel="">
		</cfif>
	</cfoutput>
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--<meta http-equiv="X-UA-Compatible" content="IE=7;FF=3;OtherUA=4" /> -->
<title>eAcceptance Administrative System</title>
<!---OLD
<link href="/applicantstatus/counselor/hsguidance.css" rel="stylesheet" type="text/css" />
<link href="/applicantstatus/counselor/hsguidance_supplement.css" rel="stylesheet" type="text/css" />
--->
<link href="/ApplicationTemplateCSS/css/960.css" rel="stylesheet" type="text/css">
<link href="/ApplicationTemplateCSS/css/layout.css" rel="stylesheet" type="text/css">
<link href="/ApplicationTemplateCSS/fonts/m_plus/stylesheet.css" rel="stylesheet" type="text/css">
<!--popup functions below-->
	<script type="text/javascript">
	    var GB_ROOT_DIR = "/applicantstatus/counselor/greybox/";
	</script>
	<script type="text/javascript" src="/applicantstatus/counselor/greybox/AJS.js"></script>
	<script type="text/javascript" src="/applicantstatus/counselor/greybox/AJS_fx.js"></script>
	<script type="text/javascript" src="/applicantstatus/counselor/greybox/gb_scripts.js"></script>
	<link href="/applicantstatus/counselor/greybox/gb_styles.css" rel="stylesheet" type="text/css" />
	<!--popup functions ended-->
	<script type="text/javascript" src="js_funcs.js"></script>
	<script language="javascript" src="CalendarPopup.js"></script>
	<script language="javascript" src="AnchorPosition.js"></script>
	<script language="javascript" src="date.js"></script>
	<script language="javascript" src="PopupWindow.js"></script>
	<link href="tempcss.css" rel="stylesheet" type="text/css" />
</head>

<body>

<!---<div id="wrapper">
  <!-- Banner Start -->
  <div id="header">
    <div id="topbar">
      <div id="logo"><a href="http://www.gsu.edu/"><img src="../counselor/images/head_logo.gif" alt="Georgia State University" border="0" /></a></div>
      <div id="homebutton"> <a href="http://www.gsu.edu/"><img src="../counselor/images/bannerhomelink.gif" alt="Georgia State Home" name="homebutton" width="151" height="25" border="0" id="Image1" onMouseOver="MM_swapImage('Image1','','../counselor/images/bannerhomelink2.gif',1)" onMouseOut="MM_swapImgRestore()" /></a></div>
    </div>
  </div>
  <cfoutput>
  <cfif isDefined("cookie.UserAuth") and cookie.UserAuth eq true and not isDefined("URL.logout")>
	  <div id="tools"> <span class="title"><cfif isDefined("Session.student_id") and not isDefined("URL.error_occurred")><cfinvoke component="/applicantstatus/counselor/hsguidance" method="getName" studid="#Session.student_id#" returnvariable="name" />#name#<cfif Session.studentLevel neq "graduate"><cfinvoke component="/applicantStatus/applicantStatus" method="getStudentHS" studid="#Session.student_id#" returnvariable="hs" /><cfif hs neq "">: #hs#</cfif></cfif> </cfif><!--<span class="happystephen"><a href="##"></a></span>--></span><ul class="tabs"><li <cfif Session.option eq 1>class="selected"</cfif>><a href="index.cfm?option=1">Home</a></li><li <cfif Session.option eq 2>class="selected"</cfif>><a href="index.cfm?option=2">Previous Mailings</a><li><a href="index.cfm?logout=true">Logout</a></li></ul></div>
  </cfif>
  </cfoutput>
  <!-- Banner End -->
  <!-- Page Start -->
   <div id="page">
    <cfif isDefined("Session.student_id") and Session.student_id neq "" and not isDefined("URL.logout")>
  <div id="topnav">
      <ul><!---
     <li><a href="index.cfm?view_scholarship=#scholarship#" class="selected">#getTitle.title#:</a></li>
      <li><a href="index.cfm?edit_scholarship=#scholarship#">Edit Scholarship</a> | </li>
      <li><a href="index.cfm?review_applicants=#scholarship#">Review Applicants</a> | </li>
      <li><a href="index.cfm?awards=#scholarship#">Awards</a></li>
	  ---></ul>
  </div>
  </cfif>
   
    <!--Core Page Start-->
    <div id="core-full">
      <!--Breadcrumbs Start-->
      <!--Breadcrumbs End-->
      <!-- Flash Start -->
      <!-- Flash End -->
      <!--Content Start-->
      <div id="content" style="width:63%">--->
	  	
		
		
		
<cfif not isDefined("Cookie.counselor_name")><cflocation addtoken="no" url="index.cfm?logout=true" /></cfif>
		
		<cfif cgi.server_name eq "istcfdev.gsu.edu" or cgi.server_name eq "glacier.gsu.edu">
		  <cfset system_type="Dev">
		<cfelseif cgi.server_name eq "istcfqa.gsu.edu" or cgi.server_name eq "glacierqa.gsu.edu">
		  <cfset system_type="QA">
		<cfelseif cgi.server_name eq "app.gsu.edu" or cgi.server_name eq "webdb.gsu.edu">
		  <cfset system_type="Prod">
		</cfif>
		
<div class="wrapper">
  <div class="container_16" id="header">
    <div class="grid_6"><img src="/ApplicationTemplateCSS/images/gsulogo_departonlybanner.gif" width="109" height="84" alt="Georgia State University" class="logo">
      <div class="appname"><cfoutput>#system_type#</cfoutput> Admissions<br>
        Status Check</div>
    </div>
    <div class="grid_10 toolbar">Logged in as: <cfoutput>#Cookie.counselor_name#</cfoutput> | <a href="javascript:open_window('help.html', 'Help', 'width=600,height=300,scrollbars=yes')">HELP</a> | <a href="index.cfm?logout=true">LOGOUT</a></div>
  </div>
  <div class="clear"></div>
  <div class="container_16 tabnav">
    <ul>    
      <li <cfif Session.option eq 1>class="current sub"</cfif>><a href="index.cfm?option=1"><span>Home</span></a></li>
	   <li <cfif Session.option eq 2 or Session.option eq 4 or Session.option eq 5>class="current sub"</cfif>><a href="index.cfm?option=2"><span>Custom Paragraphs</span></a></li>
       <li <cfif Session.option eq 6>class="current sub"</cfif>><a href="index.cfm?option=6"><span>eAcceptance</span></a></li>
       <li <cfif Session.option eq 10>class="current sub"</cfif>><a href="index.cfm?option=10"><span>Preview Students</span></a></li>
       <li <cfif Session.option eq 3>class="current sub"</cfif>><a href="index.cfm?option=3"><span>Previous Mailings</span></a></li>
       <li <cfif Session.option eq 12>class="current_sub"</cfif>><a href="index.cfm?option=12"><span>eScholarships</span></a></li>
       <li <cfif Session.option eq 20>class="current_sub"</cfif>><a href="index.cfm?option=20"><span>HGC</span></a></li>
      <li <cfif Session.option eq 11>class="current sub"</cfif>><a href="index.cfm?option=11"><span>Administrators</span></a></li>
    </ul>
  </div>
   <div class="clear"></div>
  <cfif Session.option eq 2>
      <div class="container_16">
        <div class="tabnavsub" id="app">
          <ul>
            <li><a href="index.cfm?option=2"><span>Residency Paragraphs</span></a></li>
            <li><a href="index.cfm?option=2&paragraphtype=nonresident2"><span>Non-res Sentence1</span></a></li>
            <li><a href="index.cfm?option=2&paragraphtype=nonresident"><span>Non-res Sentence2</span></a></li>
            <!---<li><a href="index.cfm?option=2&paragraphtype=intstudies"><span>Interdisciplinary Studies</span></a></li>
            <li><a href="index.cfm?option=2&paragraphtype=nursing"><span>Nursing</span></a></li>
            <li><a href="index.cfm?option=2&paragraphtype=music"><span>Music</span></a></li>
            <li><a href="index.cfm?option=2&paragraphtype=musicmanag"><span>Music Management</span></a></li>--->
	    <li><a href="index.cfm?option=2&paragraphtype=statusexplanation"><span>Status Explanation</span></a></li>
            <li><a href="index.cfm?option=2&paragraphtype=degrees"><span>Upload Degree Spreadsheet</span></a></li>
	    <li><a href="index.cfm?option=2&paragraphtype=admitted_freshmen"><span>Welcome Center Events</span></a></li>
	    <li><a href="index.cfm?option=2&paragraphtype=scholarships"><span>Scholarships</span></a></li>
          </ul>
        </div>
      </div>
      <div class="clear"></div>
    <cfelseif Session.option eq 6>
	<div class="container_16">
        <div class="tabnavsub" id="app">
          <ul>
            <li><a href="index.cfm?option=6"><span>Edit Current Letter</span></a></li>
	    <li><a href="index.cfm?option=6&function=edit_checklist"><span>Insert/Edit Checklist Items</span></a></li>
	    <!---<li><a href="index.cfm?option=6&function=view_statistics"><span>View Statistics</span></a></li>--->
          </ul>
        </div>
      </div>
      <div class="clear"></div>
    <cfelseif Session.option eq 20>
      <div class="container_16">
        <div class="tabnavsub" id="app">
          <ul>
            <li><a href="index.cfm?option=20&upload_couns_file=true"><span>Upload Counselor File</span></a></li>
          </ul>
        </div>
      </div>
      <div class="clear"></div>
    <cfelseif Session.option eq 12 or Session.option eq 13 or Session.option eq 14 or Session.option eq 15 or Session.option eq 16 or Session.option eq 17 or Session.option eq 18 or Session.option eq 19>
        <div class="container_16">
        <div class="tabnavsub" id="app">
          <ul>
            <li><a href="index.cfm?option=18&paragraphtype=scholarship"><span>Scholarship Page</span></a></li>
            <li><a href="index.cfm?option=13&paragraphtype=2"><span>Scholarship Rules</span></a></li>
            <!---THIS FORM CAN ONLY BE EDITED BY THE FOUNDATION. IF SOMEONE REQUESTS THIS LINK BE MADE ACTIVE AGAIN, LET MICHELE KNOW AND ASK HER WHAT TO DO 10/30/2015 DO POSSIBLY MAKE IT AVAILABLE JUST TO MY CAMPUS ID. ---><cfif #Cookie.campusid# eq "christina" or #Cookie.campusid# eq "mmiller64"><li><a href="index.cfm?option=14&paragraphtype=1"><span>Acceptance Form</span></a></li></cfif>
            <li><a href="index.cfm?option=15&paragraphtype=item4"><span>Rules Item 4</span></a></li>
            <li><a href="index.cfm?option=16&paragraphtype=3"><span>Out-of-State Tuition Form</span></a></li>
            <li><a href="index.cfm?option=17"><span>Signed Student Forms</span></a></li>
	    <li><a href="index.cfm?option=19"><span>Scholarship Deadline</span></a></li>
          </ul>
        </div>
      </div>
      <div class="clear"></div>
	</cfif>  
  <div class="container_16 page">
   
  <div class="clear"></div>
  <div class="container_16 page">
    <div class="grid_16" id="app">
	
	<br>
	
	<!---<div style="padding:10px;background-color: #F5E3BD;border:1px solid #990000; width:500px;">
			<p><b>Note:</b> GoSOLAR/Banner Maintenance Downtime, November 21-24</p>
			<p>Banner and GoSOLAR will be undergoing maintenance beginning Friday, November 21st through Monday, November 24th. As a result, eAcceptance will be unavailable during this time.  The system will be available again the afternoon of Tuesday, November 25th.  Thank you.</p>
		</div><br>--->
	
	<!---<div style="padding:10px;background-color: #F5E3BD;border:1px solid #990000">
			Note: This system will not be available over Labor Day weekend. During this time, Information Systems and Technology (IS&T) is performing maintenance to restore critical power systems in Georgia State University's Data Center. Thank you.

		</div>--->
	
	<cfif isDefined("URL.error_occurred")>
			<p>An error has occurred.  Please try again soon.</p>
			<br><br><br><br><br><br><br><br>
			<cfabort>
		</cfif>
		<cfif isDefined("Form.save_template") or isDefined("Form.save_template_option6")>
			<cfinvoke component="applicantStatusAdmin" method="saveTemplate" />
		<cfelseif isDefined("Form.cancel_template")>
			<cfinvoke component="applicantStatusAdmin" method="generateLetters" />
		<cfelseif isDefined("Form.send_letters")>
			<cfinvoke component="applicantStatusAdmin" method="sendLetters" />
		<cfelseif Session.option eq 6 and (isDefined("URL.function") and URL.function eq "view_statistics") or (isDefined("Form.function") and Form.function eq "view_statistics")>
			<cfinvoke component="applicantStatusAdmin" method="getDeviceStatistics" />
		<cfelseif isDefined("Form.insertingChecklistItem")>
			<cfinvoke component="applicantStatusAdmin" method="insertBannerChecklistItem" />
		<cfelseif isDefined("Form.banner_checklist_code")>
			<cfinvoke component="applicantStatusAdmin" method="showBannerChecklistForm" />
		<cfelseif isDefined("Form.function") and Form.function eq "insertChecklistItem">
			<cfinvoke component="applicantStatusAdmin" method="insertRequirementIntoChecklist" />
		<cfelseif isDefined("Form.function") and Form.function eq "updateChecklistItem">
			<cfinvoke component="applicantStatusAdmin" method="updateChecklistRequirement" />
		<cfelseif Session.option eq 6 and (isDefined("URL.function") and URL.function eq "edit_checklist") or (isDefined("Form.function") and Form.function eq "edit_checklist")>
			<cfinvoke component="applicantStatusAdmin" method="editChecklist" />
		<cfelseif isDefined("Form.edit_letter") or Session.option eq 6>
			<cfinvoke component="applicantStatusAdmin" method="editLetter" />
         <cfelseif Session.option eq 2 and isDefined("URL.paragraphtype") and URL.paragraphtype eq "degrees">
         	<cfinvoke component="applicantStatusAdmin" method="uploadDegreeSpreadsheetForm" />
         <cfelseif isDefined("Form.submitDegreeSpreadsheetFile")>
         	<cfinvoke component="applicantStatusAdmin" method="uploadDegreeSpreadsheet" />
	<cfelseif (Session.option eq 2 or isDefined("Form.residency_paragraph")) and not isDefined("URL.paragraphtype") and not isDefined("Form.custom_paragraph") and not isDefined("Form.nonresidency_paragraph")  and not isDefined("Form.nonresidency_paragraph2") and not isDefined("Form.welcomecenter_explanation") and not isDefined("scholCustPara_explanation") and not isDefined("Form.statuscode_explanation")>
			<cfinvoke component="applicantStatusAdmin" method="showResidencyParagraphsForm" />
	 <cfelseif (Session.option eq 2 and isDefined("URL.paragraphtype") and URL.paragraphtype eq "nonresident") or isDefined("Form.nonresidency_paragraph")>
         	<cfinvoke component="applicantStatusAdmin" method="showNonresidentParagraphForm" />
	  <cfelseif (Session.option eq 2 and isDefined("URL.paragraphtype") and URL.paragraphtype eq "statusexplanation") or isDefined("Form.statuscode_explanation")>
         	<cfinvoke component="applicantStatusAdmin" method="showStatusExplanationForm" />
	<cfelseif (Session.option eq 2 and (isDefined("URL.paragraphtype") and (URL.paragraphtype eq "admitted_freshmen" or URL.paragraphtype eq "welcomecenterevents")) or (isDefined("Form.welcomecenter_studenttype") or isDefined("Form.welcomecenter_explanation")))>
         	<cfinvoke component="applicantStatusAdmin" method="showWelcomeCenterForm" />
	<cfelseif (Session.option eq 2 and (isDefined("URL.paragraphtype") and (URL.paragraphtype eq "scholarships" or URL.paragraphtype eq "scholarshipTerms")) or (isDefined("Form.scholarship_studenttype") or isDefined("Form.scholCustPara_explanation")))>
         	<cfinvoke component="applicantStatusAdmin" method="showScholCustomParForm" />	
         <cfelseif (Session.option eq 2 and (isDefined("Form.nonresidency_paragraph2") or (isDefined("URL.paragraphtype") and URL.paragraphtype eq "nonresident2")))>
         	<cfinvoke component="applicantStatusAdmin" method="showNonresidentParagraphForm2" />
         <cfelseif Session.option eq 2 or isDefined("Form.custom_paragraph")>
         	<cfif isDefined("URL.paragraphtype")>
            	<cfset paragraphtype=URL.paragraphtype>
            <cfelse>
            	<cfset paragraphtype=Form.customparagraphtype>
            </cfif>
        	<cfinvoke component="applicantStatusAdmin" method="showCustomParagraphForm" paragraphtype="#paragraphtype#" />
        <cfelseif Session.option eq 11>
        	<cfinvoke component="applicantStatusAdmin" method="usersTab" />
        <cfelseif Session.option eq 12>
        	<!---<cfinvoke component="applicantStatusAdmin" method="showCustomParagraphForm" paragraphtype="scholarship" />--->
            <cfinvoke component="applicantStatusAdmin" method="editScholarshipPageForm" />
        <cfelseif Session.option eq 13  or (isDefined("Form.scholarship_form") and Form.paragraphtype eq "scholarshipRules")>
        	<cfinvoke component="applicantStatusAdmin" method="editScholarshipForms" paragraphtype="scholarshipRules" />
        <cfelseif Session.option eq 14  or (isDefined("Form.scholarship_form") and Form.paragraphtype eq "acceptanceForm")>
        	<cfinvoke component="applicantStatusAdmin" method="editScholarshipForms" paragraphtype="acceptanceForm" />
        <cfelseif Session.option eq 18  or isDefined("Form.scholarshipPage")>
        	<cfinvoke component="applicantStatusAdmin" method="editScholarshipPageForm" />
        <cfelseif Session.option eq 15  or isDefined("Form.item4form")>
        	<cfinvoke component="applicantStatusAdmin" method="editItem4Form" />
        <cfelseif Session.option eq 16  or isDefined("Form.out_of_state")>
        	<cfinvoke component="applicantStatusAdmin" method="editOutofStateForm"  />
        <cfelseif Session.option eq 17>
        	<cfinvoke component="applicantStatusAdmin" method="showSignedScholForms" />
	<cfelseif Session.option eq 19  or isDefined("Form.schol_deadline")>
		<cfinvoke component="applicantStatusAdmin" method="editScholarshipDeadlineForm" />
        <cfelseif Session.option eq 3 and isDefined("URL.pdfbatches")>
        	<cfinvoke component="applicantStatusAdmin" method="showPDFBatches" />
        <cfelseif Session.option eq 3>
			<cfinvoke component="applicantStatusAdmin" method="showPrevMailings" />
        <cfelseif Session.option eq 10>
        	<cfinvoke component="applicantStatusAdmin" method="previewStudentsTab" />
	<cfelseif Session.option eq 20 and isDefined("Form.submitCounselorAccessFile")>
         	<cfinvoke component="applicantStatusAdmin" method="uploadCounselorFile" />
	<cfelseif Session.option eq 20>
		<cfinvoke component="applicantStatusAdmin" method="uploadCounselorFileForm" />
		<cfelse>
			<cfinvoke component="applicantStatusAdmin" method="showHome" />
		</cfif>
	
	
	</div>
    <div class="clear"></div>
  </div>
  <div class="clear"></div>
  <div class="container_16 footer">
    <div class="grid_16" style="width:100%;" align="center">
	
	 <cfinvoke component="/applicantstatus/counselor/hsguidance" method="showPageFooter" />
	
	</div>
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

</body>
</html>
