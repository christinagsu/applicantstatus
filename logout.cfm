<cfapplication name="applicantstatusApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,1,00)#>

<cfset logoutpage="">
<cfif isDefined("Session.app_referrer") and Session.app_referrer eq "admissionsform">
	<cfset logoutpage="http://www.gsu.edu/admissions/check_status.html"> <!---used to use the referrer, but now using a hidden form field because referrers can be blocked by computer or network firewalls.  So I am hard-coding the URL, which is not preferable--->
<cfelse>
	<cfset logoutpage="index.cfm?logout=true">
</cfif>

<cfset Session.student_id="">
<cfset Session.app_referrer="">
<cfset Session.studentLevel="">
<cfif cgi.server_name eq "webdb.gsu.edu"><cfcache action="flush" timespan="0" directory="d:/Inetpub/applicantstatus/"></cfif>

<cflocation url="#logoutpage#" addToken="No">