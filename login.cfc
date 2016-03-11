<cffunction name="loginForm">
		
		
		<!---<cfif not isDefined("cookie.UserAuth") or cookie.UserAuth eq false> --->
<!---<cfinvoke component="diningPlans" method="loginForm"> --->
<!---</cfif> --->

 <cfif isDefined("Session.campusid") and Session.campusid neq "false" and Session.campusid neq "">
<cfset campusid=Trim(LCase(Session.campusid))>
<cftry> 
<cfstoredproc procedure="wwokbapi.f_get_stud_id" datasource="SCHOLARSHIPAPI"> 
<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="campus_id" type="in" value="#Session.campusid#"> 
<cfprocresult name="out_result_set"> 
</cfstoredproc> 
<cfif isDefined("URL.message") and URL.message eq "timedout"> 
<h2>Your session has timed out. Please log in again.</h2> 
</cfif> 
<cfif isDefined("out_result_set.RecordSet") and out_result_set.RecordCount eq 0> 
<h2>Your campus ID was not found. Please contact the <a href="http://www.gsu.edu/help/">help originalAttribute="href" originalPath=""http://www.gsu.edu/help/">help" center</a> for help.</h2> 
<cfexit> 
<cfelse>
<!---<cfcookie name = "gsu_student_id" value = "#out_result_set.student_id#" expires = "NOW">
<cfcookie name = "UserAuth" value = "true" expires = "NOW">--->
<cfset Session.gsu_student_id=out_result_set.student_id>
<cfset Session.UserAuth="true">
</cfif> 
<cfcatch> 
<p><i>A server error has occurred. Please try again later.</i></p>
<!---<cfcookie name = "gsu_student_id" value = "111111111" expires = "NOW">--->
<cfset Session.gsu_student_id="111111111">
<!---<cfoutput>#cfcatch.message# -> #cfcatch.detail#</cfoutput>--->
</cfcatch> 
</cftry>
 </cfif>
<script type="text/javascript" src="js_funcs.js"></script>
		
		
		
		<cfoutput><cfif isDefined("URL.message")><h2>
					
					</h2></cfif></cfoutput>
				
				<cfset system="prod">
		
		<cfif isDefined("Form.username") and isDefined("Form.new_password")>
		
			<cfif isDefined("Form.password")><cfset password=#Form.password#>
		<cfelseif isDefined("Form.old_password")><cfset password=#Form.old_password#>
		</cfif>
		
		
		
			<cfinvoke component="ldapAuthentication" method="resetPassword" uid="#Trim(username)#" userpassword="#password#" system="#system#" />
		<cfelseif isDefined("Form.username") and isDefined("Form.password")>
			
			<cfinvoke component="ldapAuthentication" method="checkExpiration" uid="#Trim(username)#" userpassword="#password#" system="#system#" />
		<cfelseif isDefined("expired_password")>
			
			Your password has expired.  Please change your password before accessing this system.
		<cfelse>
			<cfinvoke component="ldapAuthentication" method="loginForm" system="#system#" />
			<script language="javascript">document.login.username.focus();</script>
		</cfif>
</cffunction>