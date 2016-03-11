<cffunction name="insertSentLetters">

<cfset start_month=month("#Form.start_date#")>
<cfset start_day=day("#Form.start_date#")>
<cfset start_year=year("#Form.start_date#")>
<cfset end_month=month("#Form.end_date#")>
<cfset end_day=day("#Form.end_date#")>
<cfset end_year=year("#Form.end_date#")>
		
		
<cfmail from="christina@gsu.edu" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="in insert file">
	<cfoutput><B>hello</B></cfoutput>
</cfmail>

<!---HERE, INSERT SENT LETTERS--->
<cfquery name="check_for_letters" datasource="eAcceptance">
    select * from sent_templates where unique_id='#Form.try#'
</cfquery>
<cfif check_for_letters.RecordCount eq 0>
    <cfset letters_already_entered=false>
<cfelse>
    <cfset letters_already_entered=true>
    <cfabort>
</cfif>
    
    
<cfif check_for_letters.RecordCount eq 0>
	<cfif Form.student_type eq "F">
    	<cfset studtype=1>
    <cfelseif Form.student_type eq "H">
    	<cfset studtype=4>
    <cfelse>
    	<cfset studtype=2>
    </cfif>
    <cfset template_text=Replace(Form.letter_text, chr(13), '', 'all')>
    <cfset template_text=Replace(template_text, chr(10), '', 'all')>
    <cfset template_text=Replace(template_text, "'", '&acute;', 'all')>
    <cfquery name="insert_template" datasource="eAcceptance">
    	insert into sent_templates (sent_template_id, saved_template_id, student_type, app_term, sent_date, unique_id, sent_template_type, admission_type, searchstart_appdate, searchend_appdate, campus_id) values (sequence_senttemplates.NEXTVAL, #Form.template_id#, #studtype#, #Form.app_term#, #NOW()#, '#Form.try#', #Form.template_type#, 'None', #CreateDate(start_year, start_month, start_day)#, #CreateDate(end_year, end_month, end_day)#, '#Cookie.campusid#')
    </cfquery>
</cfif>
    
    
    
<cfoutput>
<h3>#Form.letter_text#</h3>

<cfset final_text=Replace('#Form.letter_text#',"'",chr(39), 'all')>
<cfset final_text=Replace('#Form.letter_text#',"@@","&acute;", 'all')>
    
 <!---<cfset final_text=Replace('#final_text#',chr(39), "&acute;", 'all')>
 
 
 <cfset final_text=Replace('#final_text#',"'", "''", 'all')>
 <cfset final_text=Replace('#final_text#',"'", "&acute;", 'all')>--->
<textarea>  <h3>#final_text#</h3></textarea>
</cfoutput>
		
<cfset unionstatement="">
<cfset count=1>
<cfset querycount=0>
<!---FIRST CHECK RESIDENCY TYPE!!!!!!!!!!!!!!!!!!!!!!!!!--->
<cfquery name="getResidencyParagraph" datasource="eAcceptance">
    select * from residency_extra_info where info_type='paragraph1'
</cfquery>
  <cfloop query="getResidencyParagraph">
    <cfset "paragraph#residency_type#"="<br>#info_text#">
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
    <cfset "#paragraph_type#Paragraph"="<br>#getCustomParagraphs.paragraph_text#">
</cfloop>

<cfoutput>#form.start_date# #form.end_date#</cfoutput>


<cfinvoke component="applicantStatusAdmin" method="getStudents" returnvariable="out_result_set_students" />
<cfif Form.student_type eq "F">
	<cfset stud_type=1>
<cfelse>
	<cfset stud_type=2>
</cfif>
<cfset letter_text=Replace('#Form.letter_text#', '@@', '&acute;', 'all')>
<cfset letter_count=1>

<cfset letters_sent=true>
<cfloop index="i" from="1" to="#int((out_result_set_students.RecordCount / 500) + 1)#">
	<cfoutput>FIRST LOOP: #i# </cfoutput>
    <cfset czquery="">
    <!---<cftry>--->
    <cfset count=1>
    <cfoutput>*******#out_result_set_students.RecordCount#*******</cfoutput>
    <cftry>
    <cfquery name="insertLetters" datasource="eAcceptance" result="my_query_result">
    
    INSERT INTO sent_letters (letter_id, letter_date, letter_order, student_id, letter_text, template_id, pdf_unique_id, student_type, appterm, appdate, student_fname, student_mi, student_lname, student_college, student_major,
    student_department, student_panthernum , residency_paragraph, appnum) select sequence_sentletters.NEXTVAL, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r from (
    <CFSET fullcount=1>
    <cfloop query="out_result_set_students">
    	
		<!---<CFOUTPUT>SECOND LOOP: #fullcount# </CFOUTPUT>
        <CFOUTPUT>#int((i-1)*500+1)# #int(i*500)#</CFOUTPUT>--->
        <cfif fullcount gte int(((i-1)*500)+1) and fullcount lte int(i*500)>
        
			<cfset residency="#APP_RES_CODE#">
            <cfif not isDefined("paragraph#residency#")>
				<cfset "paragraph#residency#"="">
			</cfif>
            <cfset nonres_sentence1a="">
            <cfset nonres_sentence2a="">
            <cfif CITIZENSHIP_CODE eq "A" and isDefined("nonres_paragraph#residency#")>
                <cfset nonres_sentence2a=variables['nonres_paragraph#residency#']>
                <cfset nonres_sentence1a=variables['nonres_sentence2']>
            <cfelse>
                <cfset nonres_sentence2a="">
            </cfif>
            
            
            
            <cfinvoke component="applicantStatusAdmin" method="replaceFields" original_text="#letter_text#" returnvariable="final_text" res_paragraph="#variables['paragraph#residency#']#"  nonres_sentence1="#nonres_sentence1a#" nonres_sentence2="#nonres_sentence2a#"  <!---nursing_paragraph="#nursingParagraph#" music_paragraph="#musicParagraph#" int_studies_paragraph="#intstudiesParagraph#" music_management_paragraph="#musicmanagParagraph#"---> studentset="#out_result_set_students#" studentsetrow="#out_result_set_students.currentrow#" />
            
            <!---<cfif letters_already_entered eq false>--->
            
				<cfset final_text=Replace('#final_text#',"'", "&acute;", 'all')>
                
                <cfset stud_fn=Replace(#FIRST_NAME#, "'", "&acute;")>
                <cfset stud_mi=Replace(#MI#, "'", "&acute;")>
                <cfset stud_ln=Replace(#LAST_NAME#, "'", "&acute;")>
                <cfset stud_co=Replace(#APP_COLL_CODE_1#, "'", "&acute;")>
                <cfset stud_mj=Replace(#APP_MAJR_CODE_1#, "'", "&acute;")>
                <cfset stud_dt=Replace(#APP_DEPT_CODE_DESC#, "'", "&acute;")>
                
                <cfset myObject = createObject( "java", "ZipUtil" )>
                <cfset final_text_compressed = myObject.compress(final_text) >
                
                <cfif count gt 1>
                
                union all 
                
                    select #NOW()#, #fullcount#, #STUDENT_ID#, <cfqueryparam value='#final_text_compressed#' cfsqltype="cf_sql_clob">, #Form.template_id#, '#Form.try#', #stud_type#, #APP_TERM_CODE#, #ParseDateTime(app_date)#, '#stud_fn#', '#stud_mi#', '#stud_ln#', '#stud_co#', '#stud_mj#', '#stud_dt#', #STUDENT_ID#, '#Replace(variables['paragraph#residency#'], "'", "&acute;", '#APP_NO#')#', '#APP_NO#' from dual 
             
                <cfelse>
                
                    select #NOW()# as a, #fullcount# as b, #STUDENT_ID# as c, <cfqueryparam value='#final_text_compressed#' cfsqltype="cf_sql_clob"> as d, #Form.template_id# as e, '#Form.try#' as f, #stud_type# as g, #APP_TERM_CODE# as h, #ParseDateTime(app_date)# as i,  '#stud_fn#' as j, '#stud_mi#' as k, '#stud_ln#' as l, '#stud_co#' as m, '#stud_mj#' as n, '#stud_dt#' as o, #STUDENT_ID# as p, '#Replace(variables['paragraph#residency#'], "'", "&acute;")#' as q, '#APP_NO#' as r from dual 
                
                </cfif>
            
            
            
            <!---</cfif>--->
            <cfset count=count+1>
        </cfif>
        <CFSET fullcount=fullcount+1>
        
    </cfloop>
    
    )		
    </cfquery>22222
    <cfcatch>
        
    <cfmail from="christina@gsu.edu" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="error inserting letters batch #i#">
    <cfoutput><B>#cfcatch.message# -> #cfcatch.detail# </B></cfoutput>
    </cfmail>
    
    <cfif isDefined("cfcatch.Sql")>
        <cfmail from="christina@gsu.edu" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="SQL batch #i#">
             <cfoutput>#cfcatch.Sql#</cfoutput>
        </cfmail>
    </cfif>
    <cfset letters_sent=false>
    </cfcatch>
    </cftry>
    <cfif letters_sent eq true>
        <cfmail from="christina@gsu.edu" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="letters sent">
        <cfoutput>letters sent #i# (500 each)</cfoutput>
        </cfmail>
    </cfif>
    <!---<cfmail from="christina@gsu.edu" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="query">
    <cfoutput>#my_query_result.sql# time: #my_query_result.ExecutionTime#</cfoutput>
    </cfmail>
    <cfoutput>#czquery#</cfoutput>--->
    <!--- <cfcatch>
    <cfoutput> !!!!<B>#cfcatch.message# -> #cfcatch.detail#</B>!!!!!</cfoutput>
    <cfmail from="christina@gsu.edu" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="error sending letters">
    <cfoutput><B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
    </cfmail>
    
    </cfcatch>
    </cftry>--->

</cfloop>
                

asdfasdf<br /><br />

<cftry>
<CFSTOREDPROC PROCEDURE = "wwokbupi.p_update_app_letter" datasource = "#Session.odatasource#" returncode = no>
    <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="application_type" type="in" value="#Form.student_type#"> 
    <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="term_code" type="in" value="#Form.app_term#"> 
    <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="start_date" type="in" value="#Form.start_date#"> 
    <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="end_date" type="in" value="#Form.end_date#"> 
    <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="admission_type" type="in" value="None">  
    <CFPROCPARAM TYPE="out" dbvarname="out_number_updated" CFSQLTYPE="cf_sql_integer" variable="num_students_updated">
    <CFPROCPARAM TYPE="out" dbvarname="out_params" CFSQLTYPE="CF_SQL_VARCHAR" variable="out_params">
    <CFPROCPARAM TYPE="out" dbvarname="out_error" CFSQLTYPE="CF_SQL_VARCHAR" variable="out_error">
</CFSTOREDPROC>
<cfcatch>
    <cfmail from="christina@gsu.edu" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="eAcceptance">
    <cfoutput><B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
    </cfmail>
</cfcatch>
</cftry>

<cfoutput>
number updated: #num_students_updated#
		
<cfif out_result_set_students.RecordCount neq num_students_updated or out_error neq "">
    <cfmail from="christina@gsu.edu" to="christina@gsu.edu" cc="gfaroux@gsu.edu, cdukuh@gsu.edu" server="mailhost.gsu.edu" subject="eAcceptance API discrepancy">
       
        
        This email is being sent out because someone created an eAcceptance report and there was either an API error or the search number and update number were not equal. Please see below for details.
        
        
        
        eAcceptance API discrepancy
        
        out params: #out_params#
        
        out error: #out_error#
        
        search parameters: #Form.student_type# | #Form.app_term# | #Form.start_date# | #Form.end_date# | None
        
        search num: #out_result_set_students.RecordCount#
        
        update num: #num_students_updated#
    </cfmail>
</cfif>

<cfmail from="christina@gsu.edu" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="eAcceptance">
	out params: #out_params#
	
	out error: #out_error#
	
	search parameters: #Form.student_type# | #Form.app_term# | #Form.start_date# | #Form.end_date# | None
	
	search num: #out_result_set_students.RecordCount#
	
	update num: #num_students_updated#
</cfmail>

</cfoutput>

</cffunction>
