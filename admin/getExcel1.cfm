<cfheader name="Content-Disposition" value="inline; filename=applicants.xls">
<cfcontent type="application/vnd.msexcel">

<cftry>
            <cfstoredproc  procedure="wwokbapi.f_search_apps" datasource="hsguidanceoracle_B8QA">
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="application_type" type="in" value="F">  <!---change this when honors students have been added to the API (#Form.student_type#)--->
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="term_code" type="in" value="201208"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="start_date" type="in" value="02/08/2012"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="end_date" type="in" value="02/09/2012"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="admission_type" type="in" value="None"> 
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
<table>
<cfoutput>
    <cfloop query="out_result_set_students">
        <tr><td>#student_id#</td></tr>
    </cfloop>
</cfoutput>
</table>