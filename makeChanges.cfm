<cfif isDefined("URL.show_schools")>
		<cfstoredproc  procedure="wwokbapi.f_get_state_schools" datasource="#URL.ds#">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_state_code" type="in" value="#URL.state_code#"> 
		<cfprocresult name="out_result_set">
		</cfstoredproc> 
		<cfset count=0>
		<cfset returnedresult="">
		<cfoutput query="out_result_set">
			<cfif count gt 0><cfset returnedresult=returnedresult&","></cfif>
			<cfset returnedresult=returnedresult&"#HS_NAME#|#HS_CODE#">
			<cfset count=count+1>
		</cfoutput>
		<cfoutput>#returnedresult#</cfoutput>
</cfif>