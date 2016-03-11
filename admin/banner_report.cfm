<cfheader name="Content-Disposition" value="inline; filename=applicants.xls">
<cfcontent type="application/vnd.msexcel">

<cftry>     
<cfquery name="test2" datasource="eAcceptance">

		select * from scholarship_forms_archive where ((scholarship_code='HSR2' or scholarship_code='HSR' or scholarship_code='EXA' or scholarship_code='AF1SCH' or scholarship_code='AF2SCH') and form_date between to_date('12/14/2012', 'mm/dd/yyyy') and to_date('03/14/2013', 'mm/dd/yyyy')) order by scholarship_id, student_last_name

</cfquery>



<!---<cfdump var="#test2#">--->

<table width="100%" border="1" color="black" cellspacing="0" cellpadding="5">
	<tr><th>Scholarship Name</th><th>Panther ID</th><th>Student Name</th><th>Form Signed Date</th><th>Form Type</th></tr>
	
	<cfquery name="getForms" datasource="eAcceptance">
        	select * from scholarship_forms_types order by formtype_id
        </cfquery>
        <cfset formlist=ValueList(getForms.form_type)>
        <cfset formarray=ListToArray(formlist)>
	
	<cfoutput query="test2">
		<cfset scholtitle="">
		 <cfset curscholcode = scholarship_code>
		    <cfif curscholcode eq "" and form_type eq 3><cfset curscholcode = "OSTWO"></cfif>
			<cfif trim(scholtitle) eq "" and (curscholcode neq "" and panther_id neq "" and appterm neq "")>
				<cftry>
						<cfstoredproc  procedure="wwokbapi.f_get_sch_cohort" datasource="hsguidanceoracle">
						<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#panther_id#"> 
						<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="app_term_code" type="in" value="#appterm#"> 
						<cfprocresult name="out_result_set_cohort_temp">
						</cfstoredproc> 
						<cfcatch>
						   <cfoutput>11<B>#cfcatch.message# -> #cfcatch.detail#</B>11<br /><br /></cfoutput>
						</cfcatch>
					    </cftry>
				<cfloop query="out_result_set_cohort_temp">
					<cfif scholarship_code eq curscholcode>
						<cfset scholtitle="#scholarship_description#">
					</cfif>
				</cfloop>
			</cfif>
	
		<tr><td><cfif isDefined("scholtitle")>#scholtitle#</cfif></td><td>#panther_id#</td><td>#student_last_name#, #student_first_name#</td><td>#DateFormat(form_date, "mm/dd/yyyy")#</td><td>#formarray[form_type]#</td></tr>
	</cfoutput>
	
</table>

<cfcatch><cfoutput>#cfcatch.message# -> #cfcatch.detail#</cfoutput></cfcatch>


            


</cftry>  