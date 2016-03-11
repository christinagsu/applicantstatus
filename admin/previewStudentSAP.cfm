<!---this file can be combined with sendLetters.cfm...just trying to use simpler files--->

<cfapplication name="applicantstatusAppAdmin" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">


<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>

<!---only allow access if from within admin system--->
<cfif not isDefined("Session.admin_appstatus_user") or Session.admin_appstatus_user eq "" or not isDefined("cookie.UserAuth") or cookie.UserAuth eq false or isDefined("URL.logout")>
	<cfset Session.admin_appstatus_user="">
    <cfset cookie.UserAuth=false>
	<cfcache action="flush" timespan="0" directory="d:/Inetpub/wwwroot/applicantstatus/">
    <cflocation url="login.cfm" addtoken="no">
    <cfabort>
</cfif>
<!---done checking access
<cfif URL.student_id neq "001090797" and URL.student_id neq "001090798" and URL.student_id neq "001153485">
	<p>Sorry, the specified student ID is not one of the preview students allowed.</p>
    <cfabort>
</cfif>--->

<cfheader name="Content-Disposition" value="inline; filename=myAdmissionsLetter.pdf">
<cfcontent type="application/pdf">


<cfdocument format="pdf"  marginBottom="0" marginTop="0" marginLeft="0" marginRight="0" pagewidth="8.5" pageheight="11.75" pageType="custom"> <!---making the page .5 inches taller so that blank pages aren't created in the middle--->
<cftry>
<style type="text/css"> 
body{font-family:"Times New Roman", Times, serif; margin: 0px .3in 0px .3in; padding: 0px; font-size:14px;}
#letter p {margin-bottom: 18px; margin-top:0px; line-height:17px; }
#letter br {margin-bottom:0px; margin-top:0px; line-height:13px; }
#letter {margin-top:275px;margin-bottom:0px;}
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
            <cfset nonres_secondsentence=getAlienSentence.info_text>
            <!---GET OTHER CUSTOM PARAGRAPHS!!!!!!!!!!!!!!!!!!!!!!!!!--->
        		<cfquery name="getCustomParagraphs" datasource="eAcceptance">
				select * from custom_paragraphs
			</cfquery>
            <cfloop query="getCustomParagraphs">
 				<cfset "#paragraph_type#Paragraph"=getCustomParagraphs.paragraph_text>
            </cfloop>
		    <!---DONE--->

       		<!---get app num
        	<cftry>
                <cfstoredproc  procedure="wwokbapi.f_get_app" datasource="#Session.odatasource#">
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#URL.student_id#"> 
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_term_code" type="in" value="TERM"> 
                <cfprocresult name="out_result_set_student">
                </cfstoredproc> 
            <cfcatch>
                <cfoutput>#cfcatch.Detail# -> #cfcatch.Message#</cfoutput>
            </cfcatch>
            
            </cftry> 
            <cfset appnum=0> 
            <cfset appterm=""> 
            <cfloop query="out_result_set_student">
            	<cfif app_stu_type eq "F">
					<cfset appnum=APP_NO>
                    <cfset appterm=APP_TERM_CODE>
				</cfif>
            </cfloop>   
            <cfif appnum eq 0>
            	<p>No freshman applications have been found for this student id.</p>
                <cfabort>
            </cfif>--->
           
            <!---get decision date
            
            <cftry>
                <cfstoredproc  procedure="wwokbapi.f_get_app_dec" datasource="#Session.odatasource#">
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#URL.student_id#"> 
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_term_code" type="in" value="#appterm#">
                <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_application_number" type="in" value="#appnum#"> 
                <cfprocresult name="out_result_set_date">
                </cfstoredproc> 
            <cfcatch>
            	<cfoutput>#cfcatch.Detail# -> #cfcatch.Message#</cfoutput>
            </cfcatch>
            
            </cftry>--->
       
       		
       
        <cfif isDefined("Form.letter_text")>
			<cfset letter_text=Replace('#Form.letter_text#', '@@', '&acute;', 'all')>
        <cfelse>
        	
            	<cfset curtemplatetype=11>
           
            <cfquery name="getCurrentTemplate" datasource="eAcceptance">
                select * from saved_templates where template_type=#curtemplatetype# order by template_date desc
            </cfquery>
            <cfset letter_text=Replace('#getCurrentTemplate.template_text#', '@@', '&acute;', 'all')>
        </cfif>
        
        <!---<cfoutput query="out_result_set_date">
        	<cfif not isDefined("dec_date")><cfset dec_date=APP_DEC_DATE></cfif>
            <cfif DateCompare(dec_date, APP_DEC_DATE, "d") eq 1><cfset dec_date=APP_DEC_DATE></cfif>
        </cfoutput>
        
        <cfset decdate=DateFormat(dec_date, 'mm/dd/yyyy')>
        <cfset startdate= DateFormat(DateAdd('d', -1, decdate), 'mm/dd/yyyy')>
        <cfset endDate=  DateFormat(DateAdd('d', 1, decdate), 'mm/dd/yyyy')>
        
		<cftry>
            <cfstoredproc  procedure="wwokbapi.f_search_apps" datasource="#Session.odatasource#">
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="application_type" type="in" value="F"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="term_code" type="in" value="#appterm#"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="start_date" type="in" value="#startdate#"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="end_date" type="in" value="#enddate#"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="admission_type" type="in" value="None"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_sort_column" type="in" value="STUDENT_ID"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_sort_order" type="in" value="ASC"> 
            <cfprocresult name="out_result_set_students">
            </cfstoredproc>
        <cfcatch>
             <cfoutput><B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
        </cfcatch>
        </cftry>
       
		<cfloop query="out_result_set_students">
        	<cfif APP_NO eq #appnum# and STUDENT_ID eq #URL.student_id#>--->
				<cfset residency="R">
                <cfset residency_paragraph=variables['paragraph#residency#']>
                <cfset nonres_sentence1a="">
                <cfset nonres_sentence2a="">
		<cfset citizenship_code ="A">
                <cfif CITIZENSHIP_CODE eq "A">
            		<cfset nonres_sentence2a=variables['nonres_paragraph#residency#']>
                    <cfset nonres_sentence1a=variables['nonres_secondsentence']>
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
                
                <cfinvoke component="applicantStatusAdminPreviewTest" method="replaceFields" original_text="#letter_text#" returnvariable="final_text" res_paragraph="#residency_paragraph#" nonres_sentence1="#nonres_sentence1a#"  nonres_sentence2="#nonres_sentence2a#"  <!---nursing_paragraph="#nursingParagraph#" music_paragraph="#musicParagraph#" int_studies_paragraph="#intstudiesParagraph#" music_management_paragraph="#musicmanagParagraph#" studentset="#out_result_set_students#" studentsetrow="#out_result_set_students.currentrow#"---> />
                
                <cfset final_text=#Replace(final_text, "&acute;", "'", "all")#>
                <!--- <cfset final_text = replace(final_text,'#Chr(10)##Chr(13)#','<br>',"All")>--->
                
                <cfoutput><div id="letter">#final_text#</div></cfoutput>
           <!--- </cfif>
		</cfloop>--->
		
<cfcatch>
	 <cfoutput><B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
</cfcatch>
</cftry>
</cfdocument>




</body>
</html>
