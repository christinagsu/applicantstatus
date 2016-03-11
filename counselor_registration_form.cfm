<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<title>High School Counselor Registration Form</title>
    
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
	     }
	</style>
    
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
      <span class="appname" style="display:inline;">Undergraduate<br>
        Admissions</span>
        
        		
    </div>

    
    
  </div>
  <div class="clear"></div>
  
  <div class="container_16 page">
   
  <div class="clear"></div>
  <div class="container_16 page" style="padding-left:30px;">
  
  
  
  
  
  <H2>High School Counselor<br>Registration Form</H2>
	
	
	<br>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


<cfif cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "glacierqa.gsu.edu">
	<cfset Session.datasource="hsguidance_dev">
	<cfset Session.odatasource="hsguidanceoracle_dev">
<cfelse>
	<cfset Session.datasource="hsguidance">
	<cfset Session.odatasource="hsguidanceoracle">
</cfif>


	
	<style type="text/css">
	body {background-color:white;}
	</style>
	<script type="text/javascript" language="JavaScript">
		var xmlHttp;
		var count;
		var responseText;
		count=0;
		function display_schools(selbox, selState, ds){
			count=Math.floor(Math.random()*999999999999999999999);
			var url="/applicantstatus/makeChanges.cfm";
			url=url+"?count="+count;
			url=url+"&show_schools=true&state_code="+selState+"&ds="+ds;
			//alert(url);
			xmlHttp=createResponseObject();
			count=Math.floor(Math.random()*999999999999999999999);
			xmlHttp.open("GET",url,false);
			xmlHttp.onreadystatechange = handleAjaxResponse;
			xmlHttp.send(null);
			
			var ajaxmessage=trim(xmlHttp.responseText);
			if (ajaxmessage != ""){
				var arrSchools = ajaxmessage.split(",");
				arrSchools.sort();
				for (i=0;i<arrSchools.length;i++){
					var arrInfo = arrSchools[i].split("|");
					selbox.options[selbox.options.length] = new Option(arrInfo[0],arrInfo[1]+" - "+arrInfo[0]);
				}
			}	
		
		}
		function handleAjaxResponse() {
			if(xmlHttp.readyState == 4){
				responseText = trim(xmlHttp.responseText);
			}
		}
		function trim (str) {
			var	str = str.replace(/^\s\s*/, ''),
				ws = /\s/,
				i = str.length;
			while (ws.test(str.charAt(--i)));
			return str.slice(0, i + 1);
		}
		function createResponseObject()
		{
			var tempobject=GetXmlHttpObject()
			if (tempobject==null)
			{
				alert ("Browser does not support HTTP Request")
				return false;
			}
			return tempobject;
		}
		function GetXmlHttpObject()
		{ 
		var objXMLHttp=null;
		if (window.ActiveXObject)
		{
		//alert("ms");
		objXMLHttp=new ActiveXObject("Microsoft.XMLHTTP");
		}
		else if (window.XMLHttpRequest)
		{
		//alert("other");
		objXMLHttp=new XMLHttpRequest()
		}
		return objXMLHttp
		}
		function show_schools(dropdown, ds){
			var selState = dropdown.options[dropdown.selectedIndex].value;
			var schoolStyle = document.getElementById("schooldiv").style;
			var display="";
			if (selState != ""){
				//fill in states
				var selbox = document.getElementById("school_name");
				selbox.options.length = 0;
				selbox.options[selbox.options.length] = new Option("- Select One -","");
				//use ajax to get schools
				display_schools(selbox, selState, ds);
				//make visible
				var browser=navigator.appName.toLowerCase();
		     	if (browser.indexOf("netscape")>-1) var display="table-row";
		     	else display="block";
				schoolStyle.display = schoolStyle.display? display:display;
			}
     		else schoolStyle.display = "none";
		}
		function validate_form(theForm){
			if (theForm.first_name.value==""){
				theForm.first_name.focus();
				alert("Please fill in your first name.");
				return false;
			}
			if (theForm.last_name.value==""){
				theForm.last_name.focus();
				alert("Please fill in your last name.");
				return false;
			}
			if (theForm.email_address.value=="" || theForm.email_address_confirm.value==""){
				theForm.email_address.focus();
				alert("Please fill in both email address fields before submitting.");
				return false;
			}
			if (theForm.email_address.value != theForm.email_address_confirm.value){
				theForm.email_address.focus();
				alert("Both email address fields must match.");
				return false;
			}
			if (theForm.email_address.value.indexOf("@") == -1 || theForm.email_address.value.indexOf(".") == -1){
				theForm.email_address.focus();
				alert("Please fill in a valid e-mail address.  The correct form of an e-mail address is 'example@gsu.edu'.");
				return false;
			}
			if (theForm.office_phone.value==""){
				theForm.office_phone.focus();
				alert("Please fill in your office phone.");
				return false;
			}
			if (theForm.state.value==""){
				theForm.state.focus();
				alert("Please fill in your state.");
				return false;
			}
			if (theForm.school_name.value==""){
				theForm.school_name.focus();
				alert("Please fill in your school name.");
				return false;
			}
			return true;
		}
	</script>
</head>

<!---<cfif isDefined("Form.send_email")>
	<body>
<cfelse>
	<body onload="document.getElementById('reg_form').first_name.focus();">
</cfif>--->

<cfif isDefined("Form.send_email")>
	<cfoutput>
	<cfmail from="#Form.email_address#"
		replyto = "#Form.email_address#"
		to="admissions@gsu.edu"
        cc="cperez14@gsu.edu"
		bcc="christina@gsu.edu"
		subject="High School Counselor Request"
		SERVER="mailhost.gsu.edu"
		failto="christina@gsu.edu">
		A counselor has requested approval to be given access to the high school counselor system.
		First Name: #Form.first_name#
		Last Name: #Form.last_name#
		E-mail Address: #Form.email_address#
		Office Phone ##: #Form.office_phone#
		State: #Form.state#
		High School: #Form.school_name#
	</cfmail>
	</cfoutput>
	<script language="javascript">
		setTimeout("document.location='http://www.gsu.edu/admissions/hs_counselor_thankyou.html';",3000);
	</script>
	<h3>Thank you for requesting access. Your request has been received.</h3>
	<!--<cflocation addtoken="No" url="http://www.gsu.edu/admissions/hs_counselor_thankyou.html" />--->
	<!---<br><br><h1>Thank you for requesting access.  You will receive a response within 2 business days.</h1>
	<script language="javascript">
		setTimeout("parent.parent.GB_hide();",3000);
	</script>--->
<cfelse>

	<!---<h1>Registration Form:</h1>--->
	<p>If you would like to track your students in our Online Admissions Tracking System, please fill out this form.  We will confirm your information and send you an e-mail <br>with instructions on using our system shortly.</p>
	<form method="post" action="<cfoutput>#cgi.script_name#</cfoutput>" name="reg_form" id="reg_form" onSubmit="return validate_form(this);">
	<table class="usermatrix">
	<tr>
		<td>First Name:</td>
		<td><input type="text" name="first_name" id="first_name"></td>
	</tr>
	<tr>
		<td>Last Name:</td>
		<td><input type="text" name="last_name"></td>
	</tr>
	<tr>
		<td nowrap>E-mail Address:</td>
		<td><input type="text" name="email_address"></td>
	</tr>
	<tr>
		<td nowrap>E-mail Address (confirm):</td>
		<td><input type="text" name="email_address_confirm"></td>
	</tr>
	<tr>
		<td>Office Phone #:</td>
		<td><input type="text" name="office_phone"></td>
	</tr>
	<tr>
		<td valign="top">State:</td>
		<td style="white-space:nowrap">
			<cfoutput>
			 <select name="state" onChange="show_schools(this, '#Session.odatasource#');">
	            <OPTION value="" selected>No Selection</OPTION>
				<cfstoredproc  procedure="wwokbapi.f_get_hs_states" datasource="#Session.odatasource#">
				<cfprocresult name="out_result_set">
				</cfstoredproc> 
	 		<!---<cfquery name="states" datasource="inforeq">
	          SELECT state, abbre
	           FROM states order by state
	        </cfquery>
	          <cfloop query="states">
			<OPTION value="#states.abbre#">#states.state#</OPTION>
	          </cfloop>--->
			  	<cfset stateArray = ArrayNew(1)>
			  	<cfloop query="out_result_set">
					<cfset response=ArrayAppend(stateArray, "#state_code#,#state_desc#")>
					<!---<option value="#state_code#">#state_desc#</option>--->
				</cfloop>

				<cfset isSuccessful=ArraySort(stateArray, "text", "asc")>
				<cfset myList = ArrayToList(stateArray, "; ")>
				<cfloop index="i" from="1" to="#ArrayLen(stateArray)#">
					<cfset abbr=GetToken(stateArray[i], 1, ",")>
					<cfset desc=GetToken(stateArray[i], 2, ",")>
					<option value="#abbr#">#desc#</option>
				</cfloop>
			</select>
			</cfoutput>
		 <div id="schooldiv" style="display:none;"><br>&nbsp;&nbsp;<b>School: </b>
			<select name="school_name" id="school_name">
				<option value="">- Select One -</option>
			</select>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="2"><br><br><input type="Submit" value="Submit" name="send_email"> &nbsp; <input type="button" value="Cancel" onClick="document.location='http://www.gsu.edu/admissions/hs_counselor_cancel.htm';"></td>
	</tr>
	<tr><td colspan="2"><i>NOTE: If your school is not listed, please contact the <a href="mailto:admissions@gsu.edu;cperez14@gsu.edu">Guidance Counselor Hotline</a> at (404) 413-2049 for assistance.</i></td></tr>
	</table>
	</form>

</cfif>

</div>




	
	
	
  
  
  
  
  
    <div class="grid_12" id="app">



	
 
	  	
        
			
			
















	
	


	
	
	

		
      </div>
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
     
     
	 
     	
	 		
			&#169; 2012 Georgia State University | <a href="http://www.gsu.edu/gastate_legal_statement.html">View legal statement</a> | <a href="http://www.gsu.edu/contact.html">Contact us</a> | <a href="http://www.gsu.edu/feedback.html">Send feedback</a>
        
	
     
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
