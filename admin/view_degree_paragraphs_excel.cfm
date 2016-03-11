<cfheader name="Content-Disposition" value="inline; filename=applicants.xls">
<cfcontent type="application/vnd.msexcel">


<cfquery name="getCustomParagraphs" datasource="eAcceptance">
	select * from degree_custom_paragraphs
</cfquery>
<table>
	<tr><td>Paragraph</td><td>Field</td><td>Value</td><td>Text</td></tr>
	<cfoutput query="getCustomParagraphs">
		<tr><td>#paragraph_type#</td><td>#banner_field#</td><td>#banner_value#</td><td>#paragraph_text#</td></tr>
	</cfoutput>
</table>
