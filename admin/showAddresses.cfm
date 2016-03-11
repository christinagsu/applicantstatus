<cfapplication name="applicantstatusAppAdmin" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<cfheader name="Content-Disposition" value="inline; filename=applicants.xls">
<cfcontent type="application/vnd.msexcel">

<cftry>
<table>
<!---<style type="text/css"> 
body{font-family:"Times New Roman", Times, serif; font-size:15px;}
</style>--->
        <cftry>
	<cfinvoke component="applicantStatusAdmin" method="getStudents" returnvariable="out_result_set_students" />
	<cfcatch>
	    The letters have not finished inserting into the database.  Please click the link again.
	</cfcatch>
	</cftry>
           <cfset numstudents=out_result_set_students.RecordCount>
	
           <cfset count=1>
           <cfset from=int(((Form.studentsectionnum-1)*1000)+1)>
             <cfset to=int(from + 999)>
		<cfloop query="out_result_set_students">
		    
		    <cfoutput>
            <cfif count gte from and count lte to>
		<tr><td>#NumberFormat(student_id, "000000009")#</td><td>
		<cftry>
	<cfstoredproc procedure="wwokbapi.f_get_general" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#NumberFormat(student_id, "000000009")#"> 
		<cfprocresult name="out_result_set">
	</cfstoredproc>
	<cfcatch>
		The letters have not finished inserting into the database.  Please click the link again.
	</cfcatch>
	</cftry>
	#out_result_set.first_name#</td><td>#out_result_set.mi#</td><td>#out_result_set.last_name#</td>
	
	<td>
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_addr" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#NumberFormat(student_id, "000000009")#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="address_type" type="in" value="MA"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfset address=out_result_set.STREET_LINE1>
		<cfif out_result_set.street_line2 neq ""><cfset address=address&" "&#out_result_set.street_line2#></cfif>
		<cfif out_result_set.street_line3 neq ""><cfset address=address&" "&#out_result_set.street_line3#></cfif>
		#address#
	<cfcatch>
		The letters have not finished inserting into the database.  Please click the link again.
	</cfcatch>
	</cftry>
	</td>
	<td>
	
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_addr" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#NumberFormat(student_id, "000000009")#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="address_type" type="in" value="MA"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfset address1="">
		#out_result_set.CITY#</td><td>#out_result_set.STATE#</td><td>#out_result_set.ZIP#
	<cfcatch>
		The letters have not finished inserting into the database.  Please click the link again.
	</cfcatch>
	</cftry>
	</td></tr>
            </cfif>
            <cfset count=count+1>
	
		    </cfoutput>
		</cfloop>
		
</table>

<cfcatch>
	 <cfoutput><B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
</cfcatch>
</cftry>