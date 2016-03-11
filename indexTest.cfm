<!---<cferror type="request" mailto="christina@gsu.edu" template="counselor/admin_error.cfm">
<cferror type="exception" mailto="christina@gsu.edu" template="counselor/admin_error.cfm">--->


<cfapplication name="applicantstatusApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<cfif isDefined("Form.stud_first_name_three_letters") and not isDefined("Form.stud_gpc_id")><cfset Form.stud_gpc_id=""></cfif>

<cfif isDefined("URL.inactive_gsu") and URL.inactive_gsu eq "true"><cflocation url="inactive_gsu.cfm" addtoken="no"></cfif>

<cfif isDefined("URL.option")><cfset Session.option=URL.option></cfif>
<cfif isDefined("URL.option") and URL.option eq 1><cflocation url="index.cfm?refresh=true"></cfif>
<!---<cfif not isDefined("URL.option")><cfset URL.option=1></cfif>--->


<!---check to see if should be resent to GPC myStatus--->
<!---instead of resending them, just log them out of eAcceptance before sending them to myStatus the first time!!
<cfif isDefined("Session.studentLevel") and isDefined("Session.student_id")>
	<cfstoredproc procedure="wwokbapi.f_get_pers" datasource="SCHOLARSHIPAPI">
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#Session.student_id#"> 
                <cfprocresult name="pers_info">
            </cfstoredproc>
	<cfstoredproc  procedure="wwokbapi.f_get_general" datasource="hsguidanceoracle">
                    <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#Session.student_id#"> 
                    <cfprocresult name="gen_info">
                    </cfstoredproc>
	<cfinvoke component="applicantStatus" method="determineCorrectSystem" pid="#Session.student_id#" birthdate="#DateFormat(pers_info.birth_date, "yyyy-mm-dd")#" lastname="#gen_info.last_name#" />
</cfif>--->
<!---end of checking to see if they should be resent to GPC myStatus--->



<cfif not isDefined("Session.app_referrer")><cfset Session.app_referrer=""></cfif>
<cfif isDefined("Form.submittedadmissionsform")><cfset Session.app_referrer="admissionsform"></cfif>
<!---<cfset referrer=cgi.http_referer>
<cfif referrer does not contain "/applicantstatus/" and referrer neq "">
	<cfset Session.app_referrer=#referrer#>
</cfif>--->


<cfif cgi.server_name eq "webdb.gsu.edu" and SERVER_PORT eq 80><cflocation url="https://webdb.gsu.edu/applicantstatus"></cfif>
<cfif cgi.server_name eq "istcfqa.gsu.edu" and SERVER_PORT eq 80><cflocation url="https://istcfqa.gsu.edu/applicantstatus"></cfif>
<cfif cgi.server_name eq "app.gsu.edu" and SERVER_PORT eq 80><cflocation url="https://app.gsu.edu/applicantstatus"></cfif>

<cfif isDefined("Form.chooseSystem") and Form.chooseSystem eq "true" and isDefined("Form.systemChoice") and Form.systemChoice neq "">
	<cfif Form.systemChoice eq "gpc">
		<cfinvoke component="applicantStatusPUTTHISBACK" method="sendStudentToGPCSystem" pid="#Form.pid#" birthdate="#Form.birthdate#" lastname="#Form.lastname#" />
		<cfabort>
	</cfif>
</cfif>

<cfif isDefined("Form.inactive_gsu")><cflocation url="inactive_gsu.cfm"></cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!---<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">--->

<cfoutput><cfif not isDefined("URL.refresh") and not isDefined("Form.submit_login") and not isDefined("URL.error_occurred")>
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
	<cfinvoke component="applicantStatusPUTTHISBACK" method="logOutOfSystem" />
</cfif>

<cfif #Find("mobile", LCase(CGI.HTTP_USER_AGENT))# gt 0>
	<cfset Session.mobile="false">
<cfelse>
	<cfset Session.mobile="false">
</cfif>



<cfif isDefined("URL.option")>
	<cfset Session.option = URL.option>
<cfelseif isDefined("Form.option")>
	<cfset Session.option = Form.option>
</cfif>
<cfif not isDefined("Session.option") or Session.option eq ""><cfset Session.option=1></cfif>
<cfif cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "glacierqa.gsu.edu" or cgi.server_name eq "istcfdev.gsu.edu" or cgi.server_name eq "istcfqa.gsu.edu">
	<cfset Session.datasource="hsguidance">
	<!---for QA: <cfset Session.odatasource="hsguidanceoracle_student">--->
    <!---for dev:<cfset Session.odatasource="hsguidanceoracle_dev"> --->
    
	
	<cfset Session.odatasource="hsguidanceoracle_B8QA">
    
    <cfset Session.odatasource="hsguidanceoracle">
<cfelse>
	<cfset Session.datasource="hsguidance">
	<!---<cfset Session.odatasource="hsguidanceoracle_student">--->
     <cfset Session.odatasource="hsguidanceoracle">
</cfif>

<cfif isDefined("Session.student_id") and Session.student_id neq "" and not isDefined("URL.logout")>
	<cfinvoke component="applicantStatusPUTTHISBACK" method="getStudentLevel" returnvariable="app" studid="#Session.student_id#" />
	<cfoutput query="app">
		<!---<cfoutput>#APP_STU_LEVEL#</cfoutput>--->
		<cfif app_stu_level eq "GS" or app_stu_level eq "GR" or app_stu_level eq "LW">
			<cfset Session.studentLevel="graduate">
		<cfelse>
			<cfset Session.studentLevel="">
		</cfif>
	</cfoutput>
</cfif>

<cfif isDefined("Session.studentLevel") and Session.studentLevel eq "graduate">
	<cflocation addtoken="no" url="/applicantstatus_graduate">
	<cfabort>
</cfif>

<head>
	<link rel="shortcut icon" href="http://www.gsu.edu/wp-content/themes/gsu-core/favicon.ico" />
	<title>Applicant Status Check</title>
    <!---css for popup box--->
	<style type="text/css">
	     p.title {
		 color:#59B747;
		 border-top:solid #59B747;
		 border-top-width: 2px;
		 padding-top:8px;
		 font-size:15px;
		 padding-bottom:0px;
		 margin-top:0px;
	     }
	     p.info {
		font-size:13px;
		margin-left:5px;
		font-weight:normal;
	     }
	     table {
		font-size:13px;
		padding: 0px;
	     }
	     table td a:hover { text-decoration:normal; }
	     
		 .ui-accordion .ui-accordion-header { margin-top: 0px !important; }
		 /*.ui-accordion-content { background: url(http://www.psdgraphics.com/file/blue-business-background.jpg) !important; }*/
		 .ui-accordion-content { background: #0066CC !important; color: white !important; padding-bottom: 45px !important; }
		 .acceptance-msg { font-family:Arial;font-size:35px;font-weight:bold;font-style:normal;text-decoration:none;color:#FFFFFF; }
		 .acceptance-msg2 { font-family:Arial;font-size:30px;font-weight:bold;font-style:normal;text-decoration:none;color:#FFFFFF; }
		 h3.acceptance { line-height: 0.8; }
		 
		 .content-section-wrapper { background: #CCE6FF; border: 1px solid #797979; padding: 5px; margin: 0px;  }
		 .content-section { background: #FFF; border: 1px solid #797979; padding: 10px; margin: 0px;  }
		 
		 .content-internal td a { font-size: 10px; }
		 
		 .accordion-message-hdr tbody { width: 100% !important; }
		
		.social-buttons-table { background: /*#66A3E0*/ url('admin/images/Semi-transparent.png'); margin: 25px; /*border-radius: 6px;*/ }		 
		 .social-buttons-table td { height: 45px; text-align: center; padding: 0px 10px; }
	
		 .twitter-share-button { width: 80px !important; } 
	</style>
    <cfif Session.mobile eq "false">
        <link href="/ApplicationTemplateCSS/css/960.css" rel="stylesheet" type="text/css">
        <link href="/ApplicationTemplateCSS/css/layout.css" rel="stylesheet" type="text/css">
        <link href="/ApplicationTemplateCSS/fonts/m_plus/stylesheet.css" rel="stylesheet" type="text/css">
        <link href="/applicantstatus/admin/tempcss.css" rel="stylesheet" type="text/css" />
    </cfif>
	<!---<link href="/applicantstatus/counselor/hsguidance.css" rel="stylesheet" type="text/css" />
	<link href="/applicantstatus/counselor/hsguidance_supplement.css" rel="stylesheet" type="text/css" />--->
	
	<!--link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" /-->
	<link href="css/jquery-gsu/jquery-ui-1.10.3.custom.css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-1.9.1.js"></script>
	<script src="https://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
	<script src="js/jquery-migrate-1.0.0.js"></script>
	<link rel="stylesheet" type="text/css" href="/cost_calculator/css/boxy.css" />
	<script type="text/javascript" src="/cost_calculator/js/jquery.form.js"></script>
	<script type="text/javascript" src="js/jquery.boxy.js"></script>
	<script type="text/javascript" src="js/calculate.js"></script>
	<script type="text/javascript" src="js_funcs.js"></script>
    
	<script language="JavaScript" type="text/javascript">
	<!--
	
	function MM_preloadImages() { //v3.0
	  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
	    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
	    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
	}
	
	function MM_swapImgRestore() { //v3.0
	  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}
	
	function MM_findObj(n, d) { //v4.01
	  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  if(!x && d.getElementById) x=d.getElementById(n); return x;
	}
	
	function MM_swapImage() { //v3.0
	  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}
	
	-->
	</script>
	
	<!--popup functions ended-->
	<script type="text/javascript" src="counselor/js_funcs.js"></script>
    <cfif  Session.mobile eq "true">
    	<link href="mobilestyles.css" rel="stylesheet" type="text/css" />
        <meta name="HandheldFriendly" content="true" />
		<meta name="viewport" content="width=device-width, height=device-height, user-scalable=no, initial-scale=1" />
    <cfelse>
    	<link href="nonmobilestyles.css" rel="stylesheet" type="text/css" />
        <!--popup functions below-->
		<script type="text/javascript">
            var GB_ROOT_DIR = "/applicantstatus/counselor/greybox/";
        </script>
        <script type="text/javascript" src="/applicantstatus/counselor/greybox/AJS.js"></script>
        <script type="text/javascript" src="/applicantstatus/counselor/greybox/AJS_fx.js"></script>
        <script type="text/javascript" src="/applicantstatus/counselor/greybox/gb_scripts.js"></script>
        <link href="/applicantstatus/counselor/greybox/gb_styles.css" rel="stylesheet" type="text/css" />
    </cfif>
    
    
    

    
</head>

<body>

<cfif isDefined("url.option") and url.option eq "1">
<div class="wrapper" width="100%" style="display:none">
<cfelse>
<div class="wrapper" width="100%">
</cfif>
  <div class="container_16" id="header" width="100%">
    <cfinvoke component="applicantStatusPUTTHISBACK" method="showBanner">
    <cfif not isDefined("Session.studentLevel")><cfset Session.studentLevel=""></cfif>
    <cfif isDefined("Session.student_id") and Session.student_id neq "" and not isDefined("URL.logout")>
		<!---<cfif Session.mobile eq "true"><br /><br /></cfif>--->
    	<cfif Session.mobile eq "false">
            <div class="grid_10 toolbar">Logged in as: <cfoutput>
            <cfinvoke component="counselor/hsguidance" method="getName" studid="#Session.student_id#" returnvariable="name" />#name#
            <cfif Session.studentLevel neq "graduate">
                <cfinvoke component="applicantStatusPUTTHISBACK" method="getStudentHS" studid="#Session.student_id#" returnvariable="hs" />
                <cfif hs neq "">, #hs#</cfif>
            </cfif>
            </cfoutput> <!---| <a href="javascript:open_window('help.html', 'Help', 'width=600,height=300,scrollbars=yes')">HELP</a>---> | <a href="index.cfm?logout=true">LOGOUT</a></div>
        </cfif>
   	</cfif>
  </div>
  <div class="clear"></div>
  
	<cfif isDefined("Session.student_id")>
		<cfinvoke component="counselor/hsguidance" method="getApps" studid="#Session.student_id#" returnvariable="apps"  />
		<cfif apps.ToString() eq "confidential">
			<p><br><br><br><i>Sorry, your application status is not available because your record is marked as "Confidential Student Information".  Thank you.</i></p></i></p>
			<script>document.write("<p><i>You will be logged out in 10 seconds.</i></p>");
			setTimeout("document.location='index.cfm?logout=true'", 10000);</script>
			<br><br><br><br><br><br><br><br><br><br><br><br><br>
			<cfreturn>
		</cfif>
		<cfset accepted_term="">
	<cfset admitted=false>
	<cfloop query="apps">
		<cfinvoke component="counselor/hsguidance" method="getAppDecision" studid="#Session.student_id#" termcode="#APP_TERM_CODE#" appnum="#APP_NO#" returnvalue="true" returnvariable="app_dec_code" />
		<cfset dec_code=#app_dec_code#>
		<cfset dec_app_no=#APP_NO#>
		<cfset dec_app_desc=#app_stat_code_desc#>

		<cfif dec_code eq "01" or dec_code eq "10" or dec_code eq "11" or dec_code eq "12" or dec_code eq "15" or dec_code eq "16" or dec_code eq "86" or dec_code eq "87">
		      <cfset accepted_term=#APP_TERM_CODE#>
		      <cfset admitted=true>
		      <cfbreak>
		</cfif>
	</cfloop>
	<cfif admitted eq false>
		<cfset Session.option=2>
		<cfset URL.option=2>
	</cfif>
	<cfset Session.admitted=admitted>
		<!---<cfset dec_code="">
		<cfloop query="apps">
			<cfif app_term_code neq accepted_term><cfcontinue></cfif>
			<cfinvoke component="counselor/hsguidance" method="getAppDecision" studid="#Session.student_id#" termcode="#APP_TERM_CODE#" appnum="#APP_NO#" returnvalue="true" returnvariable="app_dec_code" /> 
			<cfset dec_code=#app_dec_code#>
		</cfloop>
		<cfif dec_code eq "01" or dec_code eq "10" or dec_code eq "11" or dec_code eq "12" or dec_code eq "15" or dec_code eq "16" or dec_code eq "86" or dec_code eq "87">
			<cfset admitted=true>
		<cfelse>
			<cfset admitted=false>
			<!---<cfif Session.option eq 1>--->
				<cfset Session.option=2>
				<cfset URL.option=2>
			<!---</cfif>--->
		</cfif>
		<cfset Session.admitted=admitted>--->
	</cfif>
  
  
  <cfif isDefined("Session.student_id") and Session.student_id neq "" and not isDefined("URL.logout") and Session.mobile eq "false">
      <div class="container_16 tabnav">
        <ul>
          <cfif admitted eq true><cfif Session.mobile eq "false" or isDefined("URL.faq")><li <cfif Session.option eq 1 or not isDefined("Session.option")>class="current sub"</cfif>><a href="index.cfm?option=1&refresh=true"><span style="font-size:14px;">Admissions Status</span></a></li></cfif></cfif>
            <cfif not isDefined("Session.student_id") or Session.studentLevel neq "graduate">
		<li <cfif Session.option eq 2>class="current sub"</cfif>><a id="testLink"  href="<cfif Session.mobile eq "true">index.cfm?faq=true<cfelse>index.cfm?option=2</cfif>" title="Application Summary"><span style="font-size:14px;"><cfif admitted eq true>Application Summary<cfelse>Admissions Status</cfif></span></a></li>
                <li style="float: right;"><a id="testLink"  href="<cfif Session.mobile eq "true">index.cfm?faq=true<cfelse>faq/faq.cfm</cfif>" title="Student FAQ" rel="gb_page_center[1000, 525]"><span style="font-size:14px;">FAQ</span></a></li>
            </cfif>
            <cfif Session.mobile eq "true" and not isDefined("URL.faq")>
            	<li><a href="#disclaimer">Read Disclaimer</a></li>
            </cfif>
          <!---<li><a href="index.cfm?logout=true">LOGOUT</a></li>--->
        </ul>
      </div>   
       <div class="clear"></div>
      <!---<cfif Session.option eq 2 or Session.option eq 4 or Session.option eq 5>
          <div class="container_16">
            <div class="tabnavsub" id="app">
              <ul>
                <li><a href="index.cfm?option=2"><span>Residency Paragraphs</span></a></li>
                <li><a href="index.cfm?option=4"><span>Nursing Paragraph</span></a></li>
                <li><a href="index.cfm?option=5"><span>Music Paragraph</span></a></li>
              </ul>
            </div>
          </div>
          <div class="clear"></div>
        </cfif> ---> 
    </cfif>
  <div class="container_16 page" style="padding-top: 0px;">
   
   
  <div class="clear"></div>
  <div class="container_16 page" style="padding-top: 0px;">
    <div class="grid_12" id="app" style="width: 98%;">

<!---<br><div style="padding:10px;background-color: #F5E3BD;border:1px solid #990000; width:500px;">
			<p><b>Note:</b> GoSOLAR/Banner Maintenance Downtime, November 21-24</p>
			<p>Banner and GoSOLAR will be undergoing maintenance beginning Friday, November 21st through Monday, November 24th.  As a result, eAcceptance will be unavailable during this time.  The system will be available again the afternoon of Tuesday, November 25th.  Thank you.</p>
		</div><br>--->

	<script>
	endSession("returningStudentsScholStatus");
        </script>
	<cfset Session.returning_student="">
	
		<cfif isDefined("URL.faq") and URL.faq eq "true">
        	<iframe frameborder="0" src="faq/faq.cfm" width="100%"></iframe>
            <!---<div src="faq/faq.cfm"></div>--->
             <cfinvoke component="counselor/hsguidance" method="showPageFooter" />
        	<cfabort>
        <cfelseif isDefined("URL.disclaimer") and URL.disclaimer eq "true">
        	<cfinvoke component="applicantStatusPUTTHISBACK" method="showDisclaimer">
             <cfinvoke component="counselor/hsguidance" method="showPageFooter" />
        	<cfabort>
        </cfif>
    
	
 
	  	<cfif isDefined("URL.error_occurred")>
			<p>An error has occurred.  Please try again soon.</p>
			<br><br><br><br><br><br><br><br>
			<cfabort>
		</cfif>
		
		
		
		
        <cfif isDefined("Form.submit_login")>
			<cfinvoke component="applicantStatusPUTTHISBACK" method="tryLogin" />
		<cfelseif isDefined("URL.option") and URL.option eq 1 and isDefined("Session.student_id") and Session.student_id neq "">
			<cfinvoke component="applicantStatusPUTTHISBACK" method="showApplicationSummary" studentid="#Session.student_id#" studentview="true" />
		<cfelseif isDefined("URL.option") and URL.option eq 2 and isDefined("Session.student_id") and Session.student_id neq "">
			<cfinvoke component="applicantStatusPUTTHISBACK" method="showApplicationSummary2" studentid="#Session.student_id#" studentview="true" />
		<cfelseif isDefined("Session.student_id") and Session.student_id neq "">
			<cfinvoke component="applicantStatusPUTTHISBACK" method="showApplicationSummary" studentid="#Session.student_id#" studentview="true" />
		<cfelse>
			<!--- THIS DOESN'T WORK ON WEBDB <cfcache timespan="0" directory="c:/Inetpub/wwwroot/applicantstatus/">--->
			<cfinvoke component="applicantStatusPUTTHISBACK" method="showLoginPage" />
		</cfif>
	<cfset Session.dec_code="">
	<cfset Session.applicantid="">
	<cfset Session.app_term="">
	
<cfinvoke component="applicantStatusPUTTHISBACK" method="showFooter" />

<cfabort>