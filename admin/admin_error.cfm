<cftry>
	<cfmail from="ApplicantStatusApp <christina@gsu.edu>" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="Error Occurred in Applicant Status App" failto="admcmz@langate.gsu.edu">
		#error.remoteAddress#
		#error.browser#
	    #error.dateTime#
	    referrer: #error.HTTPReferer#
		<cfif isDefined("error.queryString")>#error.queryString#</cfif>
		<cfif isDefined("cookie.campusid")>#cookie.campusid#</cfif>
		<cfif isDefined("Cookie.first_name")>#Cookie.first_name#</cfif>
		<cfif isDefined("Cookie.last_name")>#Cookie.last_name#</cfif>
		<cfif isDefined("Session.gsu_student_id")>#Session.gsu_student_id#</cfif>
		#error.diagnostics#
		#error.generatedContent#
		<cfif not FindNoCase("Session",error.diagnostics) eq 0>User was notified of session error and redirected to start page</cfif>
		#DateFormat(NOW(), "mm/dd/yyyy")# #TimeFormat(NOW(), "hh:mm tt")#
	</cfmail>
<cfcatch></cfcatch>
</cftry>
	<p>Sorry, an error occurred.  Please try again in a few minutes.</p>
<cfabort>