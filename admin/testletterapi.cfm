<cftry>
            <cfstoredproc  procedure="WWOKEACC.F_FIND_ACCEPTED" datasource="eAcceptanceBanner">
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="application_type" type="in" value="DEFEA "> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="term_code" type="in" value="201408"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="start_date" type="in" value="01/01/2014"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="end_date" type="in" value="01/15/2014"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_sort_column" type="in" value="STUDENT_ID"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_sort_order" type="in" value="ASC"> 
            <cfprocresult name="out_result_set_students">
            </cfstoredproc>
        <cfcatch>
            <cfset query=QueryNew("")>
            <cfoutput>#cfcatch.message# #cfcatch.Detail#</cfoutput>
            <cfreturn false>
        </cfcatch>
        </cftry>


<cfdump var="#out_result_set_students#">

DEFEA 201408 01/01/2014 01/15/2014 