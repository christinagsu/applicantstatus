<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>
 
<cfquery name="test" datasource="hsguidanceoracle">
select * from user_tables
</cfquery>

<cfquery name="testa" datasource="trainingreg">
  commit
</cfquery>
<cfoutput>num records: #test.RecordCount#!!</cfoutput>
<table>
<tr>
<cfoutput>
<cfloop index="column" list="#test.columnlist#">
	<th>#column#</th>
</cfloop>
</cfoutput>

<cfoutput query="test">
	<tr>
		<cfloop index="column" list="#test.columnlist#">
			<td>#Evaluate("test.#column#")#</td>
		</cfloop>
	</tr>
</cfoutput>
</tr>
</table>

</body>
</html>
