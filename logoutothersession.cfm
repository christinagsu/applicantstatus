<cfapplication name="#URL.sessionName#" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,0,0)#>
<cfset Session.student_id="">
<cfset Session.scholarship_letter_id="">
<cfset Session.student_id="">
	<cfset Session.studentLevel="">
	<cfif cgi.server_name eq "webdb.gsu.edu"><cfcache action="flush" timespan="0" directory="d:/Inetpub/applicantstatus/"></cfif>
	<cfset StructClear(Session)>
	<!---<cflogout>--->
