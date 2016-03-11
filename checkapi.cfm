
			<cftry>
				<cfstoredproc  procedure="wwokbapi.f_get_app_chkl" datasource="hsguidanceoracle">
				<!---<cfstoredproc  procedure="wwokbapi.f_get_app_chkl" datasource="#Session.odatasource#">--->
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="002109990">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_term_code" type="in" value="201408">
				<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_app_num" type="in" value="1">
				<cfprocresult name="out_result_set">
				</cfstoredproc>
			<cfcatch>
				<cfset out_result_set=QueryNew("")>
			</cfcatch>
			
			</cftry> 
		<cfdump var="#out_result_set#">