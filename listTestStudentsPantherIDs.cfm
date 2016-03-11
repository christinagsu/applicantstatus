<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Applicant Status Test Students</title>
    <style type="text/css">
		body{font-family:Arial, Helvetica, sans-serif}
	</style>
</head>

<body>


<cftry>
<cfstoredproc  procedure="wwokbapi.f_search_apps" datasource="hsguidanceoracle_B8QA">
<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="application_type" type="in" value="F"> 
<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="term_code" type="in" value="201201"> 
<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="start_date" type="in" value="06/01/2011"> 
<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="end_date" type="in" value="08/31/2011"> 
<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="admission_type" type="in" value="None"> 
<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_sort_column" type="in" value="STUDENT_ID"> 
<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_sort_order" type="in" value="ASC"> 
<cfprocresult name="out_result_set_students">
</cfstoredproc>
<cfcatch>
<B>ERROR</B>
<cfoutput>#cfcatch.Detail# -> #cfcatch.Message#</cfoutput>
</cfcatch>
</cftry>
<!---<cfoutput><i>#out_result_set_students.RecordCount# students</i></cfoutput><br>
Accepted for term 201201, application type F, from 6/1/2011 to 8/31/2011<br>
<table cellspacing="10">
<tr><th>Panther ID</th></tr>
<cfoutput query="out_result_set_students">
	<tr><td>#student_id#</td></tr>
</cfoutput>
</table>--->

           
</body>
</html>
