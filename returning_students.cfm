<cflocation addtoken="no" url="\applicantstatus_graduate\returning_students.cfm">
<cfabort>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 
<head>
	<title>Scholarship Status Check</title>
    
        <link href="/ApplicationTemplateCSS/css/960.css" rel="stylesheet" type="text/css">
        <link href="/ApplicationTemplateCSS/css/layout.css" rel="stylesheet" type="text/css">
        <link href="/ApplicationTemplateCSS/fonts/m_plus/stylesheet.css" rel="stylesheet" type="text/css">
        <link href="/applicantstatus/admin/tempcss.css" rel="stylesheet" type="text/css" />
    
	
	
    
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
    
    	<link href="nonmobilestyles.css" rel="stylesheet" type="text/css" />
        <!--popup functions below-->
		<script type="text/javascript">
            var GB_ROOT_DIR = "/applicantstatus/counselor/greybox/";
        </script>
        <script type="text/javascript" src="/applicantstatus/counselor/greybox/AJS.js"></script>
        <script type="text/javascript" src="/applicantstatus/counselor/greybox/AJS_fx.js"></script>
        <script type="text/javascript" src="/applicantstatus/counselor/greybox/gb_scripts.js"></script>
        <link href="/applicantstatus/counselor/greybox/gb_styles.css" rel="stylesheet" type="text/css" />
    
    
    
    
 
    
</head>
 
<body>
 
 
<div class="wrapper" width="100%">
  <div class="container_16" id="header" width="100%">
    
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
	
	<div class="grid_6"  style="white-space:nowrap">
    	
        
        <span class="logo" style="display:inline;"><a href="index.cfm?option=1"><img src="/ApplicationTemplateCSS/images/gsulogo_departonlybanner.gif" width="109" height="84" alt="Georgia State University"  border="0"></a></span>
      <span class="appname" style="display:inline;">Scholarship<br>
        Status Check</span>
        
        		
    </div>
 
    
    
  </div>
  <div class="clear"></div>
  
  <div class="container_16 page">
   
  <div class="clear"></div>
  <div class="container_16 page">
    <div class="grid_12" id="app">
 
 
   
 
  
		
    
	
 
	  	
        <script>
	endSession("applicantstatusApp");
        </script>
   
 
                
                
                
                <cfapplication name="returningStudentsScholStatus" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<cfif cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "glacierqa.gsu.edu">
	<cfset Session.datasource="hsguidance_dev">
        <cfset Session.odatasource="hsguidanceoracle">
<cfelse>
	<cfset Session.datasource="hsguidance">
        <cfset Session.odatasource="hsguidanceoracle">
</cfif>


<br><div style="padding:10px;background-color: #F5E3BD;border:1px solid #990000; width:500px;">
			<p><b>Note:</b> GoSOLAR/Banner Maintenance Downtime, November 22-26</p>
			<p>Banner and GoSOLAR will be undergoing maintenance beginning Friday, November 22nd until Tuesday, November 26th. As a result, eScholarships will be unavailable during this time.  The system will be available again the afternoon of Tuesday, November 26th.  Thank you.</p>
		</div><br>

<cfset Session.returning_student="true">
<cfif not isDefined("Session.studentLevel")><cfset Session.studentLevel=""></cfif>
<cfset Session.mobile="false">
<cfif isDefined("URL.logout")>
    <cfinvoke component="returningStudents" method="logout" />
</cfif>
<!---<cftry><cfoutput>#Session.campusid#</cfoutput>
    <cfcatch>not found</cfcatch>
</cftry>--->
<cfif not isDefined("Session.UserAuthRetStudAppStatus") or not isDefined("Session.campusid") or Session.UserAuthRetStudAppStatus eq "false" or Session.campusid eq "false">
    <cfcookie name = "UserAuthRetStudAppStatus" value = "false" expires = "NOW">
    <cfcookie name = "gsu_student_id_retstudappstatus" value = "false" expires = "NOW">
    <cfinvoke component="login" method="loginForm" />
<cfelse>
    
    <div width="100%" align="right"><input type="button" value="Log Out" onclick="document.location='returning_students.cfm?logout=true';"></div>
    <cfinvoke component="returningStudents" method="showPage" />
    <!---<cfinvoke component="applicantStatus" method="showApplicationSummary" studentid="#Session.student_id#" />--->
</cfif>
                
                
                
                
    
 
 <!--Content End-->
      <!--Right Rail Start-->
      <div class="grid_4">
        <!--	  Release Status Box and Form Start-->
		
		
        <!--	  Release Status Box and Form End-->
      	
      <!--Right Rail End-->
    </div>
    <div class="clear"></div>
  </div>
  <div class="clear"></div>
  <div class="container_16 footer">
    
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
	<div class="grid_16" style="width:100%;" align="center">
	
	 <br />
	 <div id="footer">
     
     
	 
     	<br><br><br><br><br>
	 		
			<cfoutput>&##169; #Year(NOW())# Georgia State University | <a href="http://www.gsu.edu/gastate_legal_statement.html">View legal statement</a> | <a href="http://www.gsu.edu/contact.html">Contact us</a> | <a href="http://www.gsu.edu/feedback.html">Send feedback</a></cfoutput>
        
	
     
	 </div>
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
