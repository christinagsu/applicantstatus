<cfstoredproc procedure="wwokbapi.f_get_pers" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="002174171"> 
		<cfprocresult name="out_result_set">
	</cfstoredproc>
	<cfdump var="#out_result_set#">
	
	<cfstoredproc procedure="wwokbapi.f_get_general" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="002174171"> 
		<cfprocresult name="out_result_set">
	</cfstoredproc>
	<cfdump var="#out_result_set#">   