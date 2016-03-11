<cfif isDefined("URL.deleteUser")>
	<cfquery name="deleteUser" datasource="eAcceptance">
    	delete from users where campus_id='#URL.deleteUser#'
    </cfquery>
<cfelseif isDefined("URL.addUser")>
	<cfquery name="checkForUser" datasource="eAcceptance">
    	select * from users where campus_id='#URL.addUser#'
    </cfquery>
    <cfif checkForUser.RecordCount gt 0>
    	already exists
        <cfabort>
    <cfelse>
    	<cfinvoke component="ldapAuthentication" method="verifyCampusID" uid="#URL.addUser#" returnonly="true" returnvariable="validated" />
        <cfcontent reset="true">
        <cfif validated eq false>invalid campusid<cfabort></cfif>
	<cftransaction>
	<cfquery name="getUsers" datasource="eAcceptance">
            select max(user_id) as lastuserid from users
        </cfquery>
	<cfset newuserid=int(#getUsers.lastuserid# + 1)>
        <cfquery name="addUsers" datasource="eAcceptance">
            insert into users (campus_id, user_id) values ('#URL.addUser#', #newuserid#)
        </cfquery>
	</cftransaction>
     </cfif>
</cfif>
<cfif isDefined("URL.deleteUser") or isDefined("URL.addUser")>
	<cfquery name="getUsers" datasource="eAcceptance">
    	select * from users where campus_id<>'christina' order by campus_id
    </cfquery>
    <cfset count=1>
    <cfoutput query="getUsers">
    	<cfinvoke component="ldapAuthentication" method="getName" uid="#campus_id#" system="prod" return="true" returnvariable="username" />
        <cfif count gt 1> | </cfif>
    	#campus_id# * #username#
		<cfset count=count+1>
    </cfoutput>
</cfif>
<cfif isDefined("URL.getParagraphs")>
	<cfquery name="getParagraphs" datasource="eAcceptance">
    	select * from degree_custom_paragraphs order by paragraph_type
    </cfquery>
    <cfset degreeinfo="">
    <cfoutput query="getParagraphs">
    	<cfif degreeinfo neq ""><cfset degreeinfo=degreeinfo&"|"></cfif>
    	<cfset degreeinfo=degreeinfo&"#paragraph_type#^#banner_value#">
    </cfoutput>
    <cfoutput>#degreeinfo#</cfoutput>
</cfif>