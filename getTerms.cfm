<cfstoredproc  procedure="wwokbapi.f_get_app_terms" datasource="hsguidanceoracle">
   <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="level_code" type="in" value="US">
   <cfprocresult name="out_result_set_students">
   </cfstoredproc>
<cfdump var="#out_result_set_students#">