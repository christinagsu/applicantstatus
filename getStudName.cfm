<cfstoredproc  procedure="wwokbapi.f_get_general" datasource="hsguidanceoracle">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="001826991"> 
		<cfprocresult name="out_result_set">
		</cfstoredproc>
<cfdump var="#out_result_set#">