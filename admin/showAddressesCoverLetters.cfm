<cfapplication name="applicantstatusAppAdmin" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<cftry>
<cfdocument format="pdf">
<!---<style type="text/css"> 
body{font-family:"Times New Roman", Times, serif; font-size:15px;}
</style>--->
        <cfinvoke component="applicantStatusAdmin" method="getStudents" returnvariable="out_result_set_students" />
           <cfset numstudents=out_result_set_students.RecordCount>
           <cfset count=1>
           <cfset from=int(((Form.studentsectionnum-1)*1000)+1)>
             <cfset to=int(from + 999)>
		<cfloop query="out_result_set_students">
            <cfif count gte from and count lte to>
                <cfinvoke component="applicantStatusAdmin" method="replaceFields" original_text="#letter_text#" returnvariable="final_text" justaddresses="true" studentset="#out_result_set_students#" studentsetrow="#out_result_set_students.currentrow#" residency="" CITIZENSHIP_CODE="#CITIZENSHIP_CODE#" />
                
                <cfset final_text=#Replace(final_text, "&acute;", "'", "all")#>
                <!--- <cfset final_text = replace(final_text,'#Chr(10)##Chr(13)#','<br>',"All")>--->
                
                <cfoutput><div style='font-family:"Times New Roman", Times, serif; font-size:15px;margin-left:50px;margin-top:120px;'>#final_text#</div></cfoutput>
                <cfif count lt to and count lt #numstudents#><cfdocumentitem type="pagebreak"></cfdocumentitem></cfif>
            </cfif>
            <cfset count=count+1>
		</cfloop>
		

</cfdocument>
<cfcatch>
	 <cfoutput><B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
</cfcatch>
</cftry>