<cfheader name="Content-Disposition" value="inline; filename=applicants.xls">
<cfcontent type="application/vnd.msexcel">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>



<cfquery name="getTemplates" datasource="eAcceptance">
	select * from sent_templates where sent_template_id=#URL.pdf#
</cfquery>
<cfif isDefined("URL.numbatch")>
    <cfquery name="getLetters" datasource="eAcceptance">
        <!---select * from sent_letters where pdf_unique_id='#getTemplates.unique_id#' <cfif isDefined("URL.numbatch")>and rownum >= #int(((URL.numbatch-1)*1000)+1)# and rownum < #int((URL.numbatch*1000)+1)#</cfif> order by letter_order --->
        select * 
        from 
        ( select rownum rnum, a.* 
        from (select * from sent_letters where pdf_unique_id='#getTemplates.unique_id#') a 
        where rownum < #int((URL.numbatch*1000)+1)# ) 
        where rnum >= #int(((URL.numbatch-1)*1000)+1)#
      <!---because order by breaks rownum--->
    </cfquery>
<cfelse>
	<cfquery name="getLetters" datasource="eAcceptance">
		select * from sent_letters where pdf_unique_id='#getTemplates.unique_id#' order by letter_order
    </cfquery>
</cfif>

<table>
<cfoutput query="getLetters">
	<tr><td>
	<!---#NumberFormat(student_id, "000000009")#--->
	<cftry>
	<cfstoredproc procedure="wwokbapi.f_get_general" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#NumberFormat(student_id, "000000009")#"> 
		<cfprocresult name="out_result_set">
	</cfstoredproc>
	<cfcatch>
		#cfcatch.message# #cfcatch.detail#
	</cfcatch>
	</cftry>
	#out_result_set.first_name# #out_result_set.mi# #out_result_set.last_name#
	
	<br style="mso-data-placement:same-cell;" />

	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_addr" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#NumberFormat(student_id, "000000009")#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="address_type" type="in" value="MA"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfset address=out_result_set.STREET_LINE1>
		<cfif out_result_set.street_line2 neq ""><cfset address=address&" "&#out_result_set.street_line2#></cfif>
		<cfif out_result_set.street_line3 neq ""><cfset address=address&" "&#out_result_set.street_line3#></cfif>
		#address#
	<cfcatch>
		#cfcatch.message# #cfcatch.detail#
	</cfcatch>
	</cftry>
	
	<br style="mso-data-placement:same-cell;" />
	<cftry>
		<cfstoredproc procedure="wwokbapi.f_get_addr" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#NumberFormat(student_id, "000000009")#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="address_type" type="in" value="MA"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfset address1="">
		<cfset address1=address1&"#out_result_set.CITY#, #out_result_set.STATE# #out_result_set.ZIP#">
		#address1#
	<cfcatch>
		#cfcatch.message# #cfcatch.detail#
	</cfcatch>
	</cftry>
	</td></tr>
</cfoutput>
</table>

</body>
</html>
