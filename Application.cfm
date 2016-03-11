<cffunction name="cleanVariable">
<cfargument name="b">
	<cfset b=trim(b)>
	<cfset b=replace(b, "select ", "", "all")>
	<cfset b=replace(b, "select%20", "", "all")>
	<cfset b=replace(b, "update ", "", "all")>
	<cfset b=replace(b, "update%20", "", "all")>
	<cfset b=replace(b, "insert into ", "", "all")>
	<cfset b=replace(b, "insert%20", "", "all")>
	<cfset b=replace(b, "delete ", "", "all")>
	<cfset b=replace(b, "delete%20", "", "all")>
	<cfset b=replace(b, "drop ", "", "all")>
	<cfset b=replace(b, "drop%20", "", "all")>
	<cfset b=replace(b, "create ", "", "all")>
	<cfset b=replace(b, "create%20", "", "all")>
	<cfset b=replace(b, "alter table", "", "all")>
	<cfset b=replace(b, "alter%20table", "", "all")>
	<cfset b=replace(b, "grant ", "", "all")>
	<cfset b=replace(b, "grant%20", "", "all")>
	<cfset b=replace(b, "revoke ", "", "all")>
	<cfset b=replace(b, "revoke%20", "", "all")>
	<cfset b=replace(b, "truncate ", "", "all")>
	<cfset b=replace(b, "truncate%20", "", "all")>
	<cfset b=ReReplaceNoCase (b, "<script.*?>.*?</script>", "", "all")>
	<cfset b=replace (b, "<script", "", "all")>
	<cfset b=ReReplaceNoCase (b, '<[^>]*="javascript:[^"]*"[^>]*>', '', 'all')>
	<cfreturn b>
</cffunction>

<cfoutput>
<cfif isdefined("Form.FieldNames")>
	<cfif NOT len(cgi.http_referer) 
	   OR (NOT findnocase(cgi.http_host,cgi.http_referer) AND findnocase("www.gsu.edu",cgi.http_referer) eq 0 AND findnocase("spidey1dev.gsu.edu",cgi.http_referer) eq 0 AND findnocase("admissions.gsu.edu",cgi.http_referer) eq 0)>
	      Post from foreign host detected
	      <cfabort>
	</cfif>
	<cfloop list="#Form.FieldNames#" index="a">
		<cfset b=#form["#a#"]#>
		<cfinvoke method="cleanVariable" b="#b#" returnvariable="b" />
		<cfif a neq "stud_last_name"><cfset "Form.#a#"=Trim(b)></cfif>
	</cfloop>
</cfif>
<cfloop collection="#URL#" item="key">
	<cfset b=#url[key]#>
	<cfinvoke method="cleanVariable" b="#b#" returnvariable="b" />
	<cfset "URL.#key#"=Trim(b)>
</cfloop>
 </cfoutput>

<cferror type="request" mailto="christina@gsu.edu" template="admin/admin_error.cfm">
<cferror type="exception" mailto="christina@gsu.edu" template="admin/admin_error.cfm">