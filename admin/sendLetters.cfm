<cfapplication name="applicantstatusAppAdmin" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<!---this file can be combined with previewStudent.cfm...just trying to use simpler files--->
<!---<cflock timeout="5">--->


<cfdocument format="pdf"  marginBottom="0" marginTop="0" marginLeft="0" marginRight="0" pagewidth="8.5" pageheight="11.75" pageType="custom"> <!---making the page .5 inches taller so that blank pages aren't created in the middle--->

<cfif Form.student_type eq 11>
	<cfset topmargin=275>
<cfelse>
	<cfset topmargin=145>
</cfif>

<cftry>
<style type="text/css"> 
body{font-family:"Times New Roman", Times, serif; margin: 0px .3in 0px .3in; padding: 0px; font-size:14px;}
#letter p {margin-bottom: 13px; margin-top:0px; line-height:17px; }
#letter br {margin-bottom:0px; margin-top:0px; line-height:13px; }
#letter {margin-top:<cfoutput>#topmargin#</cfoutput>px;margin-bottom:0px;}
</style>
		<!---FIRST CHECK RESIDENCY TYPE!!!!!!!!!!!!!!!!!!!!!!!!!--->
        		<cfquery name="getResidencyParagraph" datasource="eAcceptance">
				select * from residency_extra_info where info_type='paragraph1'
			</cfquery>
			  <cfloop query="getResidencyParagraph">
            	<cfset "paragraph#residency_type#"="#info_text#">
            </cfloop>
            <cfquery name="getAlienSentence" datasource="eAcceptance">
				select * from residency_extra_info where info_type='paragraph2'
			</cfquery>
			  <cfloop query="getAlienSentence">
            	<cfset "nonres_paragraph#residency_type#"="#info_text#">
            </cfloop>
            <cfquery name="getAlienSentence" datasource="eAcceptance">
				select * from residency_extra_info where info_type='paragraph3'
			</cfquery>
            <cfset nonres_sentence2=getAlienSentence.info_text>
            <!---GET OTHER CUSTOM PARAGRAPHS!!!!!!!!!!!!!!!!!!!!!!!!!--->
        		<cfquery name="getCustomParagraphs" datasource="eAcceptance">
				select * from custom_paragraphs
			</cfquery>
            <cfloop query="getCustomParagraphs">
 				<cfset "#paragraph_type#Paragraph"=getCustomParagraphs.paragraph_text>
            </cfloop>
		 <!---<cftry>
            <cfstoredproc  procedure="wwokbapi.f_search_apps" datasource="hsguidanceoracle">
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="application_type" type="in" value="#Form.student_type#"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="term_code" type="in" value="#Form.app_term#"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="start_date" type="in" value="#Form.start_date#"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="end_date" type="in" value="#Form.end_date#"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="admission_type" type="in" value="None"> 
            <cfprocresult name="out_result_set_students">
            </cfstoredproc>
        <cfcatch>
            <cfset query=QueryNew("")>
             <cfoutput><B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
            <cfreturn false>
        </cfcatch>
        
        </cftry>--->
        <cfinvoke component="applicantStatusAdmin" method="getStudents" returnvariable="out_result_set_students" />
           <cfquery name="getStudentType" datasource="eAcceptance">
                select * from student_types where db_id='#Form.student_type#'
            </cfquery>
            
	    <cfset studtype=getStudentType.type_id>
           <cfset numstudents=out_result_set_students.RecordCount>
           <cfoutput>#numstudents#</cfoutput>
           <cfset count=1>
             <cfset letter_text=Replace('#Form.letter_text#', '@@', '&acute;', 'all')>
             <cfset from=int(((Form.studentsectionnum-1)*1000)+1)>
             <cfset to=int(from + 999)>
             <cfoutput>#from# -> #to#</cfoutput>
		<cfloop query="out_result_set_students">
        	<cfif count gte from and count lte to>
            	<cfset residency="">
				<cfset residency="#APP_RES_CODE#">
                <cfset residency_paragraph="">
                <cfif isDefined("paragraph#residency#")><cfset residency_paragraph=variables['paragraph#residency#']></cfif>
                <cfset nonres_sentence1a="">
                <cfset nonres_sentence2a="">
                <cfif CITIZENSHIP_CODE eq "A" and isDefined("nonres_paragraph#residency#")>
            		<cfset nonres_sentence2a=variables['nonres_paragraph#residency#']>
                     <cfset nonres_sentence1a=variables['nonres_sentence2']>
                <cfelse>
                	<cfset nonres_sentence2a="">
                </cfif>
				<!---<cfset residency_paragraph=#Replace(variables['paragraph#residency#'], "<p>", "", "all")#>
                <cfset residency_paragraph=#Replace(residency_paragraph, "</p>", "", "all")#>--->
                
                <!---<cfset final_text=Replace('#letter_text#', '[RESIDENCY PARAGRAPH]', '#residency_paragraph#', 'all')>
                 <cfset final_text=Replace('#final_text#', '[NURSING PARAGRAPH]', '#nursingParagraph#', "all")>
                  <cfset final_text=Replace('#final_text#', '[MUSIC PARAGRAPH]', '#musicParagraph#<br><br>', "all")>
                 <cfset final_text=Replace('#final_text#', '[DATE]', '#DateFormat(NOW(), "mmmm d, yyyy")#', 'all')>
                <cfset final_text=Replace('#final_text#', '[STUDENT NAME]', '#out_result_set_students.first_name# #out_result_set_students.mi# #out_result_set_students.last_name#', "all")>
                <cfset final_text=Replace('#final_text#', '[COLLEGE]', '#out_result_set_students.APP_COLL_CODE_1_DESC#', 'all')>
                <cfset final_text=Replace('#final_text#', '[MAJOR]', '#out_result_set_students.APP_MAJR_CODE_1#', 'all')>
                <cfset final_text=Replace('#final_text#', '[DEPARTMENT]', '#out_result_set_students.APP_DEPT_CODE_DESC#', 'all')>
                <cfset final_text=Replace('#final_text#', '[PANTHER NUMBER]', '#out_result_set_students.STUDENT_ID#', 'all')>
                <cfset final_text=Replace('#final_text#', '[APPLICATION TERM]', '#out_result_set_students.APP_TERM_CODE#', 'all')>
                  <cfset final_text=Replace('#final_text#', '<p>', '', "all")>
                <cfset final_text=Replace('#final_text#', '</p>', '', "all")>--->
                
                <cfinvoke component="applicantStatusAdmin" method="replaceFields" original_text="#letter_text#" returnvariable="final_text" res_paragraph="#residency_paragraph#" nonres_sentence1="#nonres_sentence1a#"  nonres_sentence2="#nonres_sentence2a#"  <!---nursing_paragraph="#nursingParagraph#" music_paragraph="#musicParagraph#" int_studies_paragraph="#intstudiesParagraph#" music_management_paragraph="#musicmanagParagraph#"---> studentset="#out_result_set_students#" studentsetrow="#out_result_set_students.currentrow#" />
                
                <cfset final_text=#Replace(final_text, "&acute;", "'", "all")#>
                <!--- <cfset final_text = replace(final_text,'#Chr(10)##Chr(13)#','<br>',"All")>--->
                
                <cfoutput><div id="letter">#final_text#</div></cfoutput>
                <cfif count lt #to# and count lt #numstudents#><cfdocumentitem type="pagebreak"></cfdocumentitem></cfif>
            </cfif>
            <cfset count=count+1>
		</cfloop>
		
<cfcatch>
	 <cfoutput><B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
</cfcatch>
</cftry>
</cfdocument>


<!---</cflock>--->