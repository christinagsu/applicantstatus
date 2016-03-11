<cfheader name="Content-Disposition" value="inline; filename=applicants.xls">
<cfcontent type="application/vnd.msexcel">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>

<cfquery name="getForms" datasource="eAcceptance">
	select * from scholarship_forms_types order by formtype_id
</cfquery>
<cfset formlist=ValueList(getForms.form_type)>
<cfset formarray=ListToArray(formlist)>

<cfinvoke component="applicantStatusAdmin" method="showSignedFormsTable" formarray="#formarray#" />

</body>
</html>
