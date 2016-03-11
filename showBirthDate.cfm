<cfstoredproc procedure="wwokbapi.f_get_pers" datasource="SCHOLARSHIPAPI">
<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="002179335"> 
<cfprocresult name="out_result_set">
</cfstoredproc>
<cfdump var="#out_result_set#">

<cfstoredproc procedure="wwokbapi.f_get_general" datasource="SCHOLARSHIPAPI">
<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="002179335"> 
<cfprocresult name="out_result_set">
</cfstoredproc>
<cfdump var="#out_result_set#">

<cfstoredproc  procedure="wwokbapi.f_get_app" datasource="hsguidanceoracle">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="002179335"> 
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_term_code" type="in" value="201508"> 
		<cfprocresult name="out_result_set">
		</cfstoredproc>
<cfdump var="#out_result_set#">

<cfstoredproc  procedure="wwokbapi.f_get_sch_cohort" datasource="hsguidanceoracle">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="002179335"> 
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_term_code" type="in" value="201508"> 
		<cfprocresult name="out_result_set">
		</cfstoredproc>
<cfdump var="#out_result_set#">

<cfstoredproc  procedure="wwokbapi.f_get_sch_forms" datasource="hsguidanceoracle">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="002179335"> 
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_term_code" type="in" value="201508">
                          <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="scholarship_code" type="in" value="OSTW50"> 
		<cfprocresult name="out_result_set">
		</cfstoredproc>
<cfdump var="#out_result_set#">