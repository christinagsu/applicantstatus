<meta http-equiv="Content-Type" content="text/html;charset=utf-8" /> 
<style type="text/css"> 
body{font-family:"Times New Roman", Times, serif; font-size:15px;}
</style>


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
<body onLoad="isReady=true">
<cfquery name="getPrevLetter" datasource="eAcceptance">
select letter_text from sent_letters where letter_id=#letter_id#
</cfquery>
<cfoutput>
<div width="100%" align="right"><a href="javascript:window.print();"><img border="0" alt="Print" title="Print" src="/applicantstatus/counselor/images/Print.gif"></a> &nbsp; 
<a href="../viewPDFLetter.cfm?letter_id=#letter_id#" target="_blank"><img border="0" alt="Open As PDF" title="Open As PDF" src="/applicantstatus/counselor/images/pdf_icon.png"></a>
<script>
var browserName=navigator.appName;
if (browserName=="Microsoft Internet Explorer") document.write(' &nbsp; <a href="javascript:doSaveAs();"><img border="0" alt="Save" title="Save" src="/applicantstatus/counselor/images/Save.gif"></a><br><br>');
</script></div>
<cfset myObject = createObject( "java", "ZipUtil" )>
<cfset decompressed_letter = myObject.decompress( getPrevLetter.letter_text ) >
<cfset decompressed_letter=Replace('#decompressed_letter#', '<img src="file:///d:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', '<img src="/applicantstatus/admin/images/scott_sig.gif" />', 'ALL')>
<cfset decompressed_letter=Replace('#decompressed_letter#', '<img src="file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', '<img src="/applicantstatus/admin/images/scott_sig.gif" />', 'ALL')>
<cfif cgi.server_name eq "istcfdev.gsu.edu">
		<cfset sigpath="D:\inetpub\cf-dev\applicantstatus\admin\images\scott_sig.gif">
		<cfset sigpath2="D:\inetpub\cf-dev\applicantstatus\admin\images\dean_berman_sig.gif">
<cfelseif cgi.server_name eq "istcfqa.gsu.edu">
		<cfset sigpath="D:\inetpub\cf-qa\applicantstatus\admin\images\scott_sig.gif">
		<cfset sigpath2="D:\inetpub\cf-qa\applicantstatus\admin\images\dean_berman_sig.jpg">
<cfelse>
		<cfset sigpath="D:\inetpub\applicantstatus\admin\images\scott_sig.gif">
		<cfset sigpath2="D:\inetpub\applicantstatus\admin\images\dean_berman_sig.gif">
</cfif>
<cfset newsigpath="/applicantstatus/admin/images/scott_sig.gif">
<cfset newsigpath2="/applicantstatus/admin/images/dean_berman_sig.jpg">
<cfset decompressed_letter=Replace('#decompressed_letter#', '<img src="file:///#sigpath#" />', '<img src="/applicantstatus/admin/images/scott_sig.gif" />', 'ALL')>
<cfset decompressed_letter=Replace('#decompressed_letter#', '<img src="file:///#sigpath2#" />', '<img src="/applicantstatus/admin/images/dean_berman_sig.jpg" />', 'ALL')>
<DIV style="border-width:thin; border-style:solid; height:1600px;padding:10px;">#decompressed_letter#</div>
</cfoutput>
</body>