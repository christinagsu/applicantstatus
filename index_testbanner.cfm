<!---<cferror type="request" mailto="christina@gsu.edu" template="counselor/admin_error.cfm">
<cferror type="exception" mailto="christina@gsu.edu" template="counselor/admin_error.cfm">--->

<cfif cgi.server_name eq "webdb.gsu.edu" and SERVER_PORT eq 80><cflocation url="https://webdb.gsu.edu/applicantstatus"></cfif>

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

<cfapplication name="applicantstatusApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<cfif isDefined("URL.logout")>
	<cfset Session.student_id="">
	<cfset Session.studentLevel="">
	<cfcache action="flush" timespan="0" directory="c:/Inetpub/wwwroot/applicantstatus/">
</cfif>

<cfif isDefined("URL.option")>
	<cfset Session.option = URL.option>
<cfelseif isDefined("Form.option")>
	<cfset Session.option = Form.option>
</cfif>
<cfif not isDefined("Session.option") or Session.option eq ""><cfset Session.option=1></cfif>
<cfif cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "glacierqa.gsu.edu">
	<cfset Session.datasource="hsguidance_dev">
	<cfset Session.odatasource="hsguidanceoracle_student">
<cfelse>
	<cfset Session.datasource="hsguidance">
	<cfset Session.odatasource="hsguidanceoracle_student">
</cfif>

<cfif isDefined("Session.student_id") and Session.student_id neq "" and not isDefined("URL.logout")>
	<cfinvoke component="applicantStatus" method="getStudentLevel" returnvariable="app" studid="#Session.student_id#" />
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
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Applicant Status Check</title>
	<link href="/applicantstatus/counselor/hsguidance.css" rel="stylesheet" type="text/css" />
	<link href="/applicantstatus/counselor/hsguidance_supplement.css" rel="stylesheet" type="text/css" />
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
	<!--popup functions below-->
	<script type="text/javascript">
	    var GB_ROOT_DIR = "/applicantstatus/counselor/greybox/";
	</script>
	<script type="text/javascript" src="/applicantstatus/counselor/greybox/AJS.js"></script>
	<script type="text/javascript" src="/applicantstatus/counselor/greybox/AJS_fx.js"></script>
	<script type="text/javascript" src="/applicantstatus/counselor/greybox/gb_scripts.js"></script>
	<link href="/applicantstatus/counselor/greybox/gb_styles.css" rel="stylesheet" type="text/css" />
	<!--popup functions ended-->
	<script type="text/javascript" src="/applicantstatus/counselor/js_funcs.js"></script>
</head>

<body>

<div id="wrapper">
  <!-- Banner Start -->
  <div id="header">
    <div id="topbar">
      <div id="logo"><a href="http://www.gsu.edu/"><img src="counselor/images/head_logo.gif" alt="Georgia State University" border="0" /></a></div>
      <div id="homebutton"> <a href="http://www.gsu.edu/"><img src="counselor/images/bannerhomelink.gif" alt="Georgia State Home" name="homebutton" width="151" height="25" border="0" id="Image1" onMouseOver="MM_swapImage('Image1','','counselor/images/bannerhomelink2.gif',1)" onMouseOut="MM_swapImgRestore()" /></a></div>
    </div>
  </div>
  <cfif not isDefined("Session.studentLevel")><cfset Session.studentLevel=""></cfif>
  <cfoutput>
  <cfif isDefined("Session.student_id") and Session.student_id neq "" and not isDefined("URL.logout")>
	  <div id="tools"> <span class="title"><cfif isDefined("Session.student_id") and not isDefined("URL.error_occurred")><cfinvoke component="counselor/hsguidance" method="getName" studid="#Session.student_id#" returnvariable="name" />#name#<cfif Session.studentLevel neq "graduate"><cfinvoke component="applicantStatus" method="getStudentHS" studid="#Session.student_id#" returnvariable="hs" /><cfif hs neq "">: #hs#</cfif></cfif> </cfif><!--<span class="happystephen"><a href="##"></a></span>--></span><ul class="tabs"><li <cfif Session.option eq 1>class="selected"</cfif>><a href="index.cfm?option=1">Home</a></li>
	  
	  
	  <!---<li <cfif Session.option eq 2>class="selected"</cfif>><a href="index.cfm?option=2">second</a></li>--->
   <cfif not isDefined("Session.student_id") or Session.studentLevel neq "graduate">
  	 <li><a id="testLink"  href="https://webdb.gsu.edu/applicantstatus/faq/high_school_students_FAQ.htm" title="Student FAQ" rel="gb_page_center[900, 525]">FAQ</a></li>
	</cfif>

      <li><a href="logout.html">Logout</a></li></ul></div>
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
      <div id="content" style="width:63%">
	  	<cfif isDefined("URL.error_occurred")>
			<p>An error has occurred.  Please try again soon.</p>
			<br><br><br><br><br><br><br><br>
			<cfabort>
		</cfif>
        <cfif isDefined("Form.submit_login")>
			<cfinvoke component="applicantStatus" method="tryLogin" />
		<cfelseif isDefined("URL.option") and URL.option eq 1 and isDefined("Session.student_id") and Session.student_id neq "">
			<cfinvoke component="applicantStatus" method="showApplicationSummary" studentid="#Session.student_id#" studentview="true" />
		<cfelse>
			<!--- THIS DOESN'T WORK ON WEBDB <cfcache timespan="0" directory="c:/Inetpub/wwwroot/applicantstatus/">--->
			<cfinvoke component="applicantStatusTestBanner" method="showLoginPage" />
		</cfif>
      </div>
      <!--Content End-->
      <!--Right Rail Start-->
      <div id="rightrail" style="width:30%;">
        <!--	  Release Status Box and Form Start-->
		<!---<cfif isDefined("URL.option")>
		<div id="release">
		  <cfinvoke component="counselor/hsguidance" method="showCommonRequestsForm" student="true" />
		</div>
		</cfif>--->
		<cfif isDefined("Session.student_id") and Session.studentLevel eq "graduate">
		<div id="release">
		  <cfinvoke component="applicantStatus" method="showAddlInfo" student="true" />
		</div>
		<cfelseif isDefined("Session.student_id") and Session.student_id neq "">
		<div id="release">
		  <cfinvoke component="applicantStatus" method="contactAdmissions" student="true" />
		</div>
		</cfif>
        <!--	  Release Status Box and Form End-->
      	
      <!--Right Rail End-->
    </div>
    <!--Core Page End-->
  </div>
  <!-- Page End -->
  <!-- Footer Start -->
  <cfinvoke component="counselor/hsguidance" method="showPageFooter" />
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
