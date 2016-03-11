<cfapplication name="applicantstatusApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
<style type="text/css">
body{font-family:Arial, Helvetica, sans-serif;}
</style>
</head>
<body>

<script>

//var letter_id=top.getLetterId();
//alert(letter_id);
//var applicantid=parent.document.applicantidform.applicantid.value;alert(applicantid);

function trim (str) {
	var	str = str.replace(/^\s\s*/, ''),
		ws = /\s/,
		i = str.length;
	while (ws.test(str.charAt(--i)));
	return str.slice(0, i + 1);
}

function validateEmailForm(){
	var thisform=document.emailForm;
	
	if (thisform.emails.value ==""){
		alert("Please enter the emails to which you would like to send your admissions letter.");
		thisform.emails.focus();
		return false;
	}
	else {
		var emailarray=thisform.emails.value.split(",");
		for (var num=0;   num<emailarray.length;   num++)
		{	
			var toemail=trim(emailarray[num]);
			var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
			if (!filter.test(toemail)) {
				alert("Please enter a valid email (format is xxxxxx@xxx.xxx).  If you list emails separated by commas, each must be a valid email.");
				thisform.emails.focus();
				return false;
			}
		}
	}
	
	if (thisform.subject.value ==""){
		alert("Please fill out the subject of your email.");
		thisform.subject.focus();
		return false;
	}
	
	if (thisform.message.value == ""){
		alert("Please fill out the message to be sent with your email.");
		thisform.message.focus();
		return false;
	}
}
</script>



<meta http-equiv="Content-Type" content="text/html;charset=utf-8" /> 
 
<script type="text/javascript"> 
function go_saveas() {
    if (!!window.ActiveXObject) {
	        document.execCommand("SaveAs");
	}
	else if (!!window.netscape) {
	        var r=document.createRange();
			r.setStartBefore(document.getElementsByTagName("head")[0]);
			var oscript=r.createContextualFragment('<script id="scriptid" type="application/x-javascript" src="chrome://global/content/contentAreaUtils.js"><\/script>');
			document.body.appendChild(oscript);        
			r=null;        
			try {
			            netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");            
						saveDocument(document);        
			} catch (e) {
			            //no further notice as user explicitly denied the privilege        
			} finally {            
						var oscript=document.getElementById("scriptid");    //re-defined            
						oscript.parentNode.removeChild(oscript);       
			}    
		}
}
function ShowSaveComplete() {
if (document.all) {
var OLECMDID_SAVEAS = 4;
var OLECMDEXECOPT_DONTPROMPTUSER = 2;
var OLECMDEXECOPT_PROMPTUSER = 1;
var WebBrowser = "<OBJECT ID=\"WebBrowser1\" WIDTH=0 HEIGHT=0 CLASSID=\"CLSID:8856F961-340A-11D0-A96B-00C04FD705A2\"></OBJECT>";
document.body.insertAdjacentHTML("beforeEnd", WebBrowser);
WebBrowser1.ExecWB(OLECMDID_SAVEAS, OLECMDEXECOPT_PROMPTUSER);
WebBrowser1.outerHTML = "";
} else {
alert("This is only applicable to Internet Explorer");
}
} 
 
 function saveImageAs (imgOrURL) {    if (typeof imgOrURL == 'object')      imgOrURL = imgOrURL.src;    window.win = open (imgOrURL);    setTimeout('win.document.execCommand("SaveAs")', 500);  }
var isReady = false;
 
function doSaveAs(){
if (document.execCommand){
if (isReady){document.execCommand("SaveAs", false, "letter.html");}
}else{
alert('Feature available only in Internet Exlorer 4.0 and later.');
}
}
 
 
 
</script>
<style>table td{padding:5px;c}</style>
<cfif not isDefined("Session.mobile")><cfset Session.mobile="false"></cfif>
<body onload="isReady=true">
 <cfif Session.mobile eq "true">
 	<link href="/applicantstatus/mobilestyles.css" rel="stylesheet" type="text/css" />
    <meta name="HandheldFriendly" content="true" />
	<meta name="viewport" content="width=device-width, height=device-height, user-scalable=no, initial-scale=1" />
    <cfinvoke component="applicantStatus" method="showBanner">
 </cfif>
 <cfif isDefined("URL.getEmail")>
 <form name="emailForm" action="viewSentLetterIntro.cfm" method="post" onsubmit="return validateEmailForm();">
 Email admission letter should be sent to:<br />
 <span style="font-size:12px"><i>Note: If sending to multiple email addresses, please separate addresses with a comma.</i></span><br />
 <input type="text" name="emails" size="60" /><br /><br />
 Subject<br />
 <input type="text" name="subject" size="60" /><br /><br />
 Message:<br /><textarea name="message" rows="5" cols="40"></textarea><br /><br />
 <input type="submit" value="Send Email" /> <cfoutput><input type="button" value="Cancel" onclick="document.location='viewSentLetterIntro.cfm?letter_id=#URL.letter_id#';" /></cfoutput>
 <cfoutput><cfif isDefined("URL.letter_id")><input type="hidden" name="letter_id" value="#URL.letter_id#"></cfif></cfoutput>
 </form>
	<cfinvoke component="applicantStatus" method="addZeros" panther_id="#Session.student_id#" returnvariable="panther_no" />
    <cfquery name="insertLogin" datasource="eAcceptance">
        insert into student_clicks (click_id, panther_id, click_event, click_date, user_agent) values (studentclicks_seq.NEXTVAL, '#panther_no#', 5, #NOW()#, '#Left(CGI.HTTP_USER_AGENT, 499)#')
    </cfquery>
 <cfelse>
 <cfif not isDefined("Session.letterid")><p>Sorry, you have timed out.  Please <a target="_top" href="index.cfm">login again</a>.</p><cfabort></cfif>
 <cfif isDefined("URL.letter_id")>
	<cfset letterid=URL.letter_id>
<cfelseif isDefined("Form.letter_id")>
	<cfset letterid=Form.letter_id>
<cfelse>
	<cfset letterid=Session.letterid>
 </cfif>
 <cfquery name="getSentLetter" datasource="eAcceptance">
	select * from sent_letters where letter_id=#letterid# order by letter_date desc
</cfquery>
 
<cfif isDefined("Form.emails")>
	<cfif cgi.server_name eq "glacierqa.gsu.edu" or cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "app.gsu.edu">
    	<cfset drive="d">
    <cfelse>
    	<cfset drive="c">
    </cfif>

	<!---<cffile action="write"
	file="#drive#:\inetpub\wwwroot\applicantstatus\admin\uploaded_files\try.pdf"
	output="#getSentLetter.letter_text#">--->
    <cfset myObject = createObject( "java", "ZipUtil" )>
	<cfset decompressed_letter = myObject.decompress( getSentLetter.letter_text ) >
    <cfif cgi.server_name eq "webdb.gsu.edu">
	<cfset decompressed_letter=Replace('#decompressed_letter#', '<img src="/applicantstatus/admin/images/scott_sig.gif" />', '<img src="file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', 'ALL')>
	<cfset decompressed_letter=Replace('#decompressed_letter#', '/applicantstatus/admin/images/scott_sig.gif', 'file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif', 'ALL')>
    <cfelseif cgi.server_name eq "istcfqa.gsu.edu">
	<cfset decompressed_letter=Replace('#decompressed_letter#', '<img src="/applicantstatus/admin/images/scott_sig.gif" />', '<img src="file:///D:\inetpub\cf-qa\applicantstatus\admin\images\scott_sig.gif" />', 'ALL')>
	<cfset decompressed_letter=Replace('#decompressed_letter#', '/applicantstatus/admin/images/scott_sig.gif', 'file:///D:\inetpub\cf-qa\applicantstatus\admin\images\scott_sig.gif', 'ALL')>
	<cfset decompressed_letter=Replace('#decompressed_letter#', 'file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif', 'file:///D:\inetpub\cf-qa\applicantstatus\admin\images\scott_sig.gif', 'ALL')>
    <cfelseif cgi.server_name eq "app.gsu.edu">
	<cfset decompressed_letter=Replace('#decompressed_letter#', '<img src="file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', '<img src="file:///d:\inetpub\applicantstatus\admin\images\scott_sig.gif" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;', 'ALL')>
	<!---doesn't work anymore?1/5/2015, worked yesterday!  <cfset decompressed_letter=Replace('#decompressed_letter#', '<img src="file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', '<img src="/applicantstatus/admin/images/scott_sig.gif" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;', 'ALL')>--->
    <!---<cfset decompressed_letter=Replace('#decompressed_letter#', 'file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" ', 'file:///d:\inetpub\applicantstatus\admin\images\scott_sig.gif"', 'ALL')>--->
    
    </cfif>
    <cfset decompressed_letter=Replace('#decompressed_letter#', 'width:800px', '', 'all')>
		<cfset decompressed_letter=Replace('#decompressed_letter#', '</span><a', '</span>&nbsp;<a', 'ALL')>
	<cfset decompressed_letter=Replace('#decompressed_letter#', '</a><span ', '</a>&nbsp;<span', 'ALL')>
	<cfset decompressed_letter=Replace('#decompressed_letter#', ' <a', ' &nbsp;<a', 'ALL')>
    <cfif cgi.server_name eq "istcfqa.gsu.edu">
	<cfset letterfilepath="D:\inetpub\cf-qa\applicantstatus\admin\uploaded_files\admissionsLetter_#getSentLetter.student_lname#.pdf">
     <cfelseif cgi.server_name eq "app.gsu.edu">
	<cfset letterfilepath="D:\inetpub\applicantstatus\admin\uploaded_files\admissionsLetter_#getSentLetter.student_lname#.pdf">
     <cfelse>
		<cfset letterfilepath="#drive#:\inetpub\wwwroot\applicantstatus\admin\uploaded_files\admissionsLetter_#getSentLetter.student_lname#.pdf">
    </cfif>
    <cfdocument filename="#letterfilepath#" format="PDF" overwrite="true" marginBottom="0" marginTop="0.25" marginLeft=".25" marginRight=".2" pagewidth="8.5" pageheight="11.75" pageType="custom">
	<style type="text/css"> 
	body{font-family:"Times New Roman", Times, serif; margin: 0px; padding: 0px 10px; font-size: 10pt;}
	#letter p {margin-bottom: 9px; margin-top:0px; font-size: 9pt; line-height:13px;}
	#letter br {margin-bottom:0px; margin-top:0px; line-height:10px; }
	#letter {margin-top:0px;margin-bottom:0px;}
	</style>
    <!---<cfif cgi.server_name eq "glacierqa.gsu.edu" or cgi.server_name eq "glacier.gsu.edu">
    	<img src="admin/images/header2.png" width="600" />--->
	<cfif getSentLetter.student_type eq 41>
		<cfset header_image="HonorsLetterhead.png">
	<cfelse>
		<cfset header_image="header2.png">
	</cfif>
    <cfif cgi.server_name eq "app.gsu.edu">
	<cfoutput>
	<!---doesn't work anymore?1/5/2015, worked yesterday!  <cfoutput><img src="admin/images/#header_image#" width="600" /></cfoutput>--->
	<img src="file:///d:\inetpub\applicantstatus\admin\images\#header_image#" width="600" /></cfoutput>
    
    <cfelseif cgi.server_name eq "istcfqa.gsu.edu">
	<cfoutput><img src="file:///D:\inetpub\cf-qa\applicantstatus\admin\images\#header_image#" width="600" /></cfoutput>
    <!---<cfelse>
    	<img src="file:///c:\inetpub\wwwroot\applicantstatus\admin\images\header2.png" width="600" />--->
    </cfif>
    
    <div style="font-size:10pt;"><cfoutput>#decompressed_letter#</cfoutput></div>
    </cfdocument>
	


 	<cfoutput>
    <cfset numchars=#Len(getSentLetter.student_id)#>
  	<cfset zerosneeded=int(9-numchars)>
    <cfset tempstudid=getSentLetter.student_id>
    <cfloop index="i" from="1" to="#zerosneeded#">
    	<cfset tempstudid="0"&tempstudid>
    </cfloop>
    <cftry>
		<cfstoredproc  procedure="wwokbapi.f_get_email" datasource="hsguidanceoracle">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#tempstudid#"> 
		<cfprocresult name="out_result_set">
		</cfstoredproc> 
	<cfcatch>
		 #cfcatch.message# #cfcatch.Detail#
	</cfcatch>
	</cftry>
    <cfset studemailaddress=out_result_set.email_address>
    <cfif studemailaddress eq "">
	<cfstoredproc  procedure="wwokbapi.f_get_all_email" datasource="hsguidanceoracle">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_studentid" type="in" value="#tempstudid#"> 

	 <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_emailcode" type="in" value="IND"> 
	<cfprocresult name="out_result_set">
	</cfstoredproc>
	<cfset studemailaddress=out_result_set.email_address>
    </cfif>
    <cfif studemailaddress eq ""><cfset studemailaddress="admissions@gsu.edu"></cfif>
    </cfoutput>
   
    <cfmail to="#Form.emails#"
    	replyto="#studemailaddress#"
        from="#studemailaddress#"
        bcc="christina@gsu.edu"
        subject="#Form.subject#"
        type="text"
        mimeattach="#letterfilepath#"
        server="mailhost.gsu.edu">
        #Form.message#
    </cfmail>

	<h3 style="color:red;">Thank you, your email has been sent!</h3>
	<cfinvoke component="applicantStatus" method="addZeros" panther_id="#Session.student_id#" returnvariable="panther_no" />
    <cfquery name="insertLogin" datasource="eAcceptance">
        insert into student_clicks (click_id, panther_id, click_event, click_date, user_agent) values (studentclicks_seq.NEXTVAL, '#panther_no#', 6, #NOW()#, '#Left(CGI.HTTP_USER_AGENT, 499)#')
    </cfquery>
 </cfif>
<cfinvoke component="applicantStatus" method="addZeros" panther_id="#Session.student_id#" returnvariable="panther_no" />
<cfquery name="insertLogin" datasource="eAcceptance">
    insert into student_clicks (click_id, panther_id, click_event, click_date, user_agent) values (studentclicks_seq.NEXTVAL, '#panther_no#', 4, #NOW()#, '#Left(CGI.HTTP_USER_AGENT, 499)#')
</cfquery>
<div width="100%" align="right"><cfoutput><cfif Session.mobile eq "false"><a href="viewYourLetter.cfm?letter_id=#letterid#" target="_blank"><img name="printbutton" alt="Print Admissions Letter" title="Print Admissions Letter" border="0" src="admin/images/buttonicons/pdforig.png" onmouseover="printbutton.src='admin/images/buttonicons/pdfmouseover.png'" onMouseout="printbutton.src='admin/images/buttonicons/pdforig.png'" /></a></cfif><a href="viewSentLetterIntro.cfm?getEmail=true&letter_id=<cfif isDefined('URL.letter_id')>#URL.letter_id#<cfelse>#Session.letterid#</cfif>"><img name="emailbutton" alt="E-mail Admissions Letter" title="E-mail Admissions Letter" border="0" src="admin/images/buttonicons/emailorig.gif" onmouseover="emailbutton.src='admin/images/buttonicons/emailmouseover.gif'" onMouseout="emailbutton.src='admin/images/buttonicons/emailorig.gif'" /></a><!---<a href="javascript:window.print();"><img alt="Print" title="Print" border="0" src="counselor/images/Print.gif" /></a> &nbsp; 
<a href="viewYourLetter.cfm?letter_id=#Session.letterid#" target="_blank"><img alt="Open As PDF" title="Open As PDF" border="0" src="counselor/images/pdf_icon.png" /></a>
<script> 
var browserName=navigator.appName;
if (browserName=="Microsoft Internet Explorer") document.write(' &nbsp; <a href="javascript:doSaveAs();"><img alt="Save" title="Save" border="0" src="counselor/images/Save.gif"></a><br><br>');
</script></div>---></cfoutput></div>
<DIV style="border-width:thin; border-style:solid; height:2000px;padding:10px; border-color:#BFBEBE" align="left">

<cfset myObject = createObject( "java", "ZipUtil" )>
<cfset decompressed_letter = myObject.decompress( getSentLetter.letter_text ) >
<cfset decompressed_letter=Replace('#decompressed_letter#', '<img src="file:///d:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', '<img src="/applicantstatus/admin/images/scott_sig.gif" />', 'ALL')>
<cfset decompressed_letter=Replace('#decompressed_letter#', '<img src="file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', '<img src="/applicantstatus/admin/images/scott_sig.gif" />', 'ALL')>
<cfset decompressed_letter=Replace(decompressed_letter, "<a ", "<a target='blank' ", "all")>
<cfset decompressed_letter=Replace('#decompressed_letter#', 'width:800px', '', 'all')>

<cfset decompressed_letter=Replace('#decompressed_letter#', 'file:///D:\inetpub\cf-dev\applicantstatus\admin\images\scott_sig.gif', '/applicantstatus/admin/images/scott_sig.gif', 'ALL')>
	<cfset decompressed_letter=Replace('#decompressed_letter#', 'file:///D:\inetpub\cf-dev\applicantstatus\admin\images\dean_berman_sig.jpg', '/applicantstatus/admin/images/dean_berman_sig.jpg', 'ALL')>
	<cfset decompressed_letter=Replace('#decompressed_letter#', 'file:///D:\inetpub\cf-qa\applicantstatus\admin\images\scott_sig.gif', '/applicantstatus/admin/images/scott_sig.gif', 'ALL')>
	<cfset decompressed_letter=Replace('#decompressed_letter#', 'file:///D:\inetpub\cf-qa\applicantstatus\admin\images\dean_berman_sig.jpg', '/applicantstatus/admin/images/dean_berman_sig.jpg', 'ALL')>
	<cfset decompressed_letter=Replace('#decompressed_letter#', 'file:///D:\inetpub\applicantstatus\admin\images\scott_sig.gif', '/applicantstatus/admin/images/scott_sig.gif', 'ALL')>
	<cfset decompressed_letter=Replace('#decompressed_letter#', 'file:///D:\inetpub\applicantstatus\admin\images\dean_berman_sig.jpg', '/applicantstatus/admin/images/dean_berman_sig.jpg', 'ALL')>

<cfoutput>#decompressed_letter#</cfoutput>

</div>
</cfif> 

<cfinvoke component="counselor/hsguidance" method="showPageFooter" />

</body>
</html>
