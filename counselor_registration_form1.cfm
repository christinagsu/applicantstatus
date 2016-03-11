<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfif cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "glacierqa.gsu.edu">
	<cfset Session.datasource="hsguidance_dev">
	<cfset Session.odatasource="hsguidanceoracle_dev">
<cfelse>
	<cfset Session.datasource="hsguidance">
	<cfset Session.odatasource="hsguidanceoracle">
</cfif>

<html>
<head>
	<title>High School Counselor Registration Form</title>
	<link href="counselor/hsguidance.css" rel="stylesheet" type="text/css" />
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
<body>
<div id="wrapper">
<div id="page">
<div id="core-full">
<div id="content">

<cfif isDefined("Form.send_email")>

	<cfmail from="#Form.email_address#"
		replyto = "#Form.email_address#"
		to="blahey@gsu.edu"
		bcc="christina@gsu.edu"
		subject="High School Counselor Request"
		SERVER="mail.gsu.edu">
		A counselor has requested approval to be given access to the high school counselor system.
		First Name: #Form.first_name#
		Last Name: #Form.last_name#
		E-mail Address: #Form.email_address#
		Office Phone ##: #Form.office_phone#
		State: #Form.state#
		High School: #Form.school_name#
	</cfmail>
	<cflocation addtoken="No" url="http://www.gsu.edu/admissions/hs_counselor_thankyou.htm" />
	<!---<br><br><h1>Thank you for requesting access.  You will receive a response within 2 business days.</h1>
	<script language="javascript">
		setTimeout("parent.parent.GB_hide();",3000);
	</script>--->
<cfelse>

	<h1>Registration Form:</h1>
	<p>If you would like to track your students in our Online Admissions Tracking System, please fill out this form.  We will confirm your information and send you an e-mail with instructions on using our system shortly.</p>
	<form method="post" action="/applicantstatus/counselor_registration_form.cfm" name="reg_form" id="reg_form" onsubmit="return validate_form(this);">
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
			 <select name="state" onchange="show_schools(this, '#Session.odatasource#');">
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
		<td colspan="2"><br><br><input type="Submit" value="Submit" name="send_email"> &nbsp; <input type="button" value="Cancel" onclick="document.location='http://www.gsu.edu/admissions/hs_counselor_cancel.htm';"></td>
	</tr>
	<tr><td colspan="2"><i>NOTE: If your school is not listed, please contact the <a href="mailto:blahey@gsu.edu">Guidance Counselor Hotline</a> at (404) 413-2039 for assistance.</i></td></tr>
	</table>
	</form>

</cfif>

</div>
</div>
</div>
</div>
</body>