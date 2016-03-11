<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>View Degree Paragraphs</title>
<style type="text/css">
body{font-family:Arial, Helvetica, sans-serif}
</style>
</head>

<body>

<cfquery name="getCustomParagraphs" datasource="eAcceptance">
	select * from degree_custom_paragraphs
</cfquery>
<table cellspacing="10">
	<tr><th nowrap>Paragraph Type</th><th>Field</th><th>Value</th><th>Paragraph</th></tr>
<cfoutput query="getCustomParagraphs">
	<tr><td valign="top">#paragraph_type#</td><td valign="top">#banner_field#</td><td valign="top">#banner_value#</td><td valign="top">#paragraph_text#<br /><br /></td></tr>
</cfoutput>
</table>

</body>
</html>
