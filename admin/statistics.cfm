<!---<cferror type="request" mailto="christina@gsu.edu" template="counselor/admin_error.cfm">
<cferror type="exception" mailto="christina@gsu.edu" template="counselor/admin_error.cfm">--->


<cfapplication name="applicantstatusApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>



<cfif cgi.server_name eq "webdb.gsu.edu" and SERVER_PORT eq 80><cflocation url="https://webdb.gsu.edu/applicantstatus"></cfif>
<cfif cgi.server_name eq "istcfqa.gsu.edu" and SERVER_PORT eq 80><cflocation url="https://istcfqa.gsu.edu/applicantstatus"></cfif>
<cfif cgi.server_name eq "app.gsu.edu" and SERVER_PORT eq 80><cflocation url="https://app.gsu.edu/applicantstatus"></cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!---<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">--->

<cfif isDefined("URL.logout")>
	<cfset Session.student_id="">
	<cfset Session.studentLevel="">
	<cfif cgi.server_name eq "webdb.gsu.edu">
		<cfcache action="flush" timespan="0" directory="d:/Inetpub/applicantstatus/">
	<cfelseif cgi.server_name eq "istcfdev.gsu.edu" or cgi.server_name eq "istcfqa.gsu.edu">
		<cfcache action="flush" timespan="0" directory="D:/inetpub/cf-dev/applicantstatus/">
	</cfif>
	<cfset StructClear(Session)>
	<cflogout>
</cfif>

<cfif #Find("mobile", LCase(CGI.HTTP_USER_AGENT))# gt 0>
	<cfset Session.mobile="false">
<cfelse>
	<cfset Session.mobile="false">
</cfif>




    
    <cfset Session.odatasource="eAcceptance">


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


<head>
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


<div class="wrapper" width="100%">
  <div class="container_16" id="header" width="100%">
    <cfinvoke component="/applicantStatus/applicantStatus" method="showBanner">
    <cfif not isDefined("Session.studentLevel")><cfset Session.studentLevel=""></cfif>
    <cfif isDefined("Session.student_id") and Session.student_id neq "" and not isDefined("URL.logout")>
		<!---<cfif Session.mobile eq "true"><br /><br /></cfif>--->
    	<cfif Session.mobile eq "false">
            <div class="grid_10 toolbar">Logged in as: <cfoutput>
            <cfinvoke component="counselor/hsguidance" method="getName" studid="#Session.student_id#" returnvariable="name" />#name#
            <cfif Session.studentLevel neq "graduate">
                <cfinvoke component="applicantStatus" method="getStudentHS" studid="#Session.student_id#" returnvariable="hs" />
                <cfif hs neq "">, #hs#</cfif>
            </cfif>
            </cfoutput> <!---| <a href="javascript:open_window('help.html', 'Help', 'width=600,height=300,scrollbars=yes')">HELP</a>---> | <a href="index.cfm?logout=true">LOGOUT</a></div>
        </cfif>
   	</cfif>
  </div>
  <div class="clear"></div>
  
        <div style="margin: 20px;">
            <h3>Device Statistics</h3>
        <cfquery name="GetDates" datasource="eAcceptance">
            select extract(month from click_date) "month", extract(year from click_date) "year" from student_clicks where user_agent is not null group by  extract(month from click_date),  extract(year from click_date) order by extract(year from click_date), extract(month from click_date)
        </cfquery>
        <form action="statistics.cfm" method="post">
        <select name="showMonths">
            <cfoutput query="GetDates">
                <cfset correctMonth=NumberFormat(month, "00")>
                <option value="#correctMonth##year#">#MonthAsString(month)# #year#</option>
            </cfoutput>
        </select> <input type="submit" value="GO">
        </form>
        <h3>Logins</h3>
        <cfif isDefined("Form.showMonths")>
            <br><br>
            <cfquery name="GetStats" datasource="eAcceptance">
                select * from student_clicks where extract(month from click_date)=#Left(Form.showMonths, 2)# and extract(year from click_date)=#Right(Form.showMonths, 4)# order by click_date
            </cfquery>
            <!---<cfdump var="#GetStats#">--->
            <cfset searchSystems=ListSort("Windows,Macintosh,IPad,Android,IPhone,Blackberry,Kindle", "text")>
            <cfoutput>
            <cfloop list="#searchSystems#" index="sys">
                <cfquery name="getSystems" dbtype="query">
                    select * from GetStats where click_event=1 and upper(user_agent) like '%#UCase(sys)#%'
                </cfquery>
                <b>#sys#</b> - #getSystems.RecordCount#<br>
            </cfloop>
            </cfoutput>
        </cfif>
        <br><br><Br>
        </div>




	<script>
	endSession("returningStudentsScholStatus");
        </script>
	<cfset Session.returning_student="">
	
	
	
<cfinvoke component="/applicantStatus/applicantStatus" method="showFooter" />

<cfabort>