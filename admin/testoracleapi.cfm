<cfstoredproc  procedure="WWOKEACC.F_FIND_ACCEPTED" datasource="eAcceptanceBanner">
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="application_type" type="in" value="F">  <!---change this when honors students have been added to the API (#Form.student_type#)--->
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="term_code" type="in" value="201408"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="start_date" type="in" value="07/15/2014"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="end_date" type="in" value="07/17/2014"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_sort_column" type="in" value="STUDENT_ID"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_sort_order" type="in" value="ASC"> 
            <cfprocresult name="out_result_set_students">
            </cfstoredproc>


<cfdump var="#out_result_set_students#">
<cfoutput>#out_result_set_students.RecordCount#</cfoutput>