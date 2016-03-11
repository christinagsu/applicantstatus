<cffunction name="showHome">
	<cfif cgi.server_name eq "istcfdev.gsu.edu" or cgi.server_name eq "glacier.gsu.edu">
		  <cfset system_type="Development">
		<cfelseif cgi.server_name eq "istcfqa.gsu.edu" or cgi.server_name eq "glacierqa.gsu.edu">
		  <cfset system_type="QA">
		<cfelseif cgi.server_name eq "app.gsu.edu" or cgi.server_name eq "webdb.gsu.edu">
		  <cfset system_type="Production">
		</cfif>
	<h1><cfoutput>#system_type#</cfoutput> Admissions Status Check | Home</h1>
	<p>The Admissions Status Check enables you to generate eAcceptance letters for accepted students.  You may view the current letter, edit the current letter, and generate an acceptance letter below.</p>
	<p>Click on the <i>Previous Mailings</i> tab to view all the previous letters sent out by application cycle.</p>
	
    
   
	<cfif isDefined("Form.student_type")>
		<cfinvoke method="generateLetters" />  
	<cfelse>
		<!---don't allow a send a minute after last send--->
		<cfquery name="getLastSent" datasource="eAcceptance">
		select * from sent_templates order by sent_date desc
		</cfquery>
		<cfset sentdate=DateAdd("s", 60, #getLastSent.sent_date#)>
		<!---<cfoutput>#getLastSent.sent_date#<br>#sentdate#<br>#NOW()#</cfoutput>--->
		<cfif DateCompare(NOW(), #sentdate#, "s") eq -1>
		    <p><span style="color:red;">You have sent a letter less than a minute ago.  Please try again in a minute.</span></p>
		<cfelse>
			<cfinvoke method="showGenLetterForm" />
		</cfif>
	</cfif>  
	  
</cffunction>            
<cffunction name="showGenLetterForm">
	<div id="release" style="width:650px;">
	<h3 style="margin-top:0px;">Generate Letters</h3><br>  
	<p style="margin-left:5px;"><i>NOTE: All fields are required.</i></p>
	<form method="post" action="index.cfm" onsubmit="return validate_genletter_form(this);">
	<table class="matrix" cellspacing="10px">
		<tr style="border-bottom:solid 1px black">
			<td>Admit Type:</td>
			<td colspan="2">
				<select name="admit_type" id="admit_type">
					<option value="a">Accepted</option>
					<option value="d" <cfif isDefined("URL.admit_type") and URL.admit_type eq "d">selected</cfif>>Denied</option>
					<option value="df" <cfif isDefined("URL.admit_type") and URL.admit_type eq "df">selected</cfif>>Deferred</option>
					<option value="w" <cfif isDefined("URL.admit_type") and URL.admit_type eq "w">selected</cfif>>Withdrawn</option>
					<option value="wl" <cfif isDefined("URL.admit_type") and URL.admit_type eq "wl">selected</cfif>>Wait List</option>
				</select> <input type="button" value="Choose" onclick="document.location='index.cfm?option=1&admit_type='+document.getElementById('admit_type').options[document.getElementById('admit_type').selectedIndex].value"></p>
			</td>
		</tr>
		<cfif isDefined("URL.admit_type") and URL.admit_type eq "a">
			<tr style="border-bottom:solid 1px black">
				<td>Student Type Category:</td>
				<td colspan="2">
					<select name="studenttype_cat" id="studenttype_cat">
						<option value="int">International</option>
						<option value="other" <cfif isDefined("URL.studenttype_cat") and URL.studenttype_cat eq "other">selected</cfif>>Other</option>
					</select> <input type="button" value="Choose" onclick="document.location='index.cfm?option=1&admit_type='+document.getElementById('admit_type').options[document.getElementById('admit_type').selectedIndex].value+'&studenttype_cat='+document.getElementById('studenttype_cat').options[document.getElementById('studenttype_cat').selectedIndex].value"></p>
				</td>
			</tr>
		</cfif>
		<cfif isDefined("URL.admit_type") and (URL.admit_type neq "a" or isDefined("URL.studenttype_cat"))>
			<cfoutput><tr><td>Open Panther ID section?</td><td colspan="2">
			<select name="open_pantherid_section" id="open_pantherid_section">
				<option value="false">No</option>
				<option value="true">Yes</option>
			</select> <input type="button" value="Choose" onclick="var newLocation='index.cfm?option=1&admit_type='+document.getElementById('admit_type').options[document.getElementById('admit_type').selectedIndex].value; if (document.getElementById('studenttype_cat')) newLocation+='&studenttype_cat='+document.getElementById('studenttype_cat').options[document.getElementById('studenttype_cat').selectedIndex].value; newLocation+='&open_pantherid_section='+document.getElementById('open_pantherid_section').options[document.getElementById('open_pantherid_section').selectedIndex].value; document.location=newLocation;">
			<!---<a href="index.cfm?<cfif isDefined("URL.option")>option=#URL.option#&</cfif><cfif isDefined("URL.admit_type")>admit_type=#URL.admit_Type#&</cfif><cfif isDefined("URL.studenttype_cat")>studenttype_cat=#URL.studenttype_cat#&</cfif><cfif (isDefined("URL.open_pantherid_section") and URL.open_pantherid_section eq false) or not isDefined("URL.open_pantherid_section")>open_pantherid_section=true">
				<cfelseif isDefined("URL.open_pantherid_section") and URL.open_pantherid_section eq true>">Close Panther ID section
				<cfelse>">
				</cfif>
				</a>--->
				<!---<script>
					var testlink='<a href="index.cfm?<cfif isDefined("URL.option")>option=#URL.option#&</cfif>admit_type='&'&">test link</a>';
					document.write(testlink);
				</script>--->
			</td></Tr></cfoutput>
		</cfif>
		<cfquery name="getStudentTypes" datasource="eAcceptance">
					select * from student_types where type_id <> 4 and db_id<>'PAR' and deleted_column is null <cfif isDefined("URL.admit_type")>and admit_type='#URL.admit_type#'</cfif> <cfif isDefined("URL.studenttype_cat")>and type_category='#URL.studenttype_cat#'</cfif> order by all_semesters,semester,student_type
		</cfquery>
		<cfif isDefined("URL.admit_type") and (URL.admit_type neq "a" or isDefined("URL.studenttype_cat")) and (isDefined("URL.open_pantherid_section"))>
			<cfset chose_admit_type=true>
		<cfelse>
			<cfset chose_admit_type=false>
		</cfif>
		<cfif getStudentTypes.RecordCount eq 0>
			<tr><td colspan="3">None Yet.</td></tr>
			<cfset chose_admit_type=false>
		</cfif>
		<tr <cfif chose_admit_type eq false>style="display:none;"</cfif>>  
			<td>Student Type:</td>    
			<td>
				<cfif getStudentTypes.RecordCount gt 0>
					<select name="student_type">  
					<cfoutput query="getStudentTypes">
						<option value="#type_id#" <cfif isDefined("Form.student_type") and Form.student_type eq db_id>selected</cfif>><cfif <!---(db_id neq "K" and db_id neq "B" and db_id neq "C" and db_id neq "X"  and db_id neq "PEP"  and db_id neq "DXF" and db_id neq "DXT" and db_id neq "DXX" and db_id neq "DXB" and db_id neq "DXDE" and db_id neq "FI" and db_id neq "TI")---> all_semesters eq ""><cfif semester eq "08">Fall<cfelseif semester eq "05">Summer<cfelse>Spring</cfif> </cfif>#student_type# <cfif admit_type eq "a">(Accepted)<cfelseif admit_type eq "d">(Denied)<cfelseif admit_type eq "df">(Deferred)<cfelseif admit_type eq "w">(Withdrawn)<cfelseif admit_type eq "wl">(Wait List)</cfif></option>
					</cfoutput> 
					</select>
				<cfelse>
					<p>None yet</p>
				</cfif>
			</td>  
            <input type="hidden" name="template_type" value="1">
			<!---<td>Offer Code:</td>  
			<td> 
				<select name="template_type">
				<cfquery name="getTemplateTypes" datasource="eAcceptance">
					select * from template_types
				</cfquery>
				<cfoutput query="getTemplateTypes">
					<option value="#type_id#">#template_type#</option>
				</cfoutput>
				</select> 
			</td>     --->
			<td>Application Term:</td>
			<td>   
				<select name="app_term">
                	<cftry>
                       <cfstoredproc  procedure="wwokbapi.f_get_app_terms" datasource="#Session.odatasource#">
                       <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="level_code" type="in" value="US">
                       <cfprocresult name="out_result_set_terms">
                       </cfstoredproc>
                    <cfcatch>
                       <cfoutput><B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
		       </select></td></tr></table>
		       <p><b>Sorry, there is an issue with <cfif cgi.server_name eq "istcfqa.gsu.edu">QA</cfif> Oracle/Banner right now.</b></p>
		       <cfinvoke method="showFooter"/>
                    <cfabort>
		    </cfcatch>
                    </cftry> 
                    <cfoutput query="out_result_set_terms">
                    	<option <cfif isDefined("Form.app_term") and Form.app_term eq APP_TERM>selected</cfif>>#APP_TERM#</option>
                    </cfoutput>
				</select>
			</td>
           </tr>
           <tr <cfif chose_admit_type eq false>style="display:none;"</cfif>>
			<td>Date Range:</td>
			<td nowrap> 
		<SCRIPT LANGUAGE="JavaScript">
		var cal1 = new CalendarPopup("popupcalendaradd"); 
		//cal1.showNavigationDropdowns();
		</SCRIPT> 
		<cfoutput><input  type="text" name="start_date" id="start_date" size="8" onfocus="alert('Please choose the date by clicking on the calendar to the right of the field.');this.blur();" <cfif isDefined("Form.start_date")>value="#Form.start_date#"<cfelse>value="mm/dd/yyyy"</cfif>></cfoutput>
		 <img src="images/cal.gif" onClick="cal1.select(document.getElementById('start_date'),'anchor1','MM/dd/yyyy'); return false;" TITLE="start date calendar" NAME="anchor1" ID="anchor1">
		<div id="popupcalendaradd" STYLE="position:absolute;visibility:hidden;background-color:white;layer-background-color:white;font-family: Arial, Helvetica, sans-serif;font-size: 12px;"></div>
		<!--&nbsp; -->
        <td  colspan="2">
	 to 
	  &nbsp; 
	<SCRIPT LANGUAGE="JavaScript">
	var cal2 = new CalendarPopup("popupcalendar2add"); 
	//cal2.showNavigationDropdowns();
	</SCRIPT>
	<cfoutput><input  type="text" name="end_date" id="end_date" size="8" onfocus="alert('Please choose the date by clicking on the calendar to the right of the field.');this.blur();"  onchange="" <cfif isDefined("Form.end_date")>value="#Form.end_date#"<cfelse>value="mm/dd/yyyy"</cfif>></cfoutput>
	<img src="images/cal.gif" onclick="cal2.select(document.getElementById('end_date'),'anchor2','MM/dd/yyyy');" name="anchor2" id="anchor2">
	<div id="popupcalendar2add" STYLE="position:absolute;visibility:hidden;background-color:white;layer-background-color:white;font-family: Arial, Helvetica, sans-serif;font-size: 12px;"></div></td>
		</tr>
		<!---<tr>
			<td>Admission Type:</td>
			<td>
				<select name="admission_type">
					<option value="fr">FR</option>
					<option value="fla">FLA</option>
					<option value="fl">FL</option>
				</select>
			</td>
			<td colspan="2">&nbsp;</td>
		</tr>--->
		<cfoutput>
		
		<tr id="panther_id_section1" <cfif (isDefined("URL.open_pantherid_section") and URL.open_pantherid_section eq false) or not isDefined("URL.open_pantherid_section")>style="display:none;"</cfif>>
			<td valign="Top">Panther IDs</td>
			<td colspan="2">
			 (only use this section if you want to send individual letters out to a few students)<br><br>
			<cfloop from="1" to="10" index="i">
				<input type="text" name="send_pantherid_#i#" style="margin-bottom:5px;" maxlength="9"><br>
			</cfloop>
		</td></tr>
		<tr <cfif chose_admit_type eq false>style="display:none;"</cfif>><td><input type="submit" value="GO"></td><td colspan="3">&nbsp;</td></tr>
		</cfoutput>
	</table>
	</form>
	</div>
</cffunction>
<cffunction name="showFooter">
	</div></div>
    <div class="clear"></div>
  </div>
  <div class="clear"></div>
  <div class="container_16 footer">
    <div class="grid_16" style="width:100%;" align="center">
	
	 <cfinvoke component="/applicantstatus/counselor/hsguidance" method="showPageFooter" />
	
	</div>
  </div>
  <div class="clear"></div>
</div>	
		
		

      
 
  <!-- Footer End -->
  <script type="text/javascript">
	var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
	document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
	</script>
	<script type="text/javascript">
	try {
	var pageTracker = _gat._getTracker("UA-411467-1");
	pageTracker._trackPageview();
	} catch(err) {}</script>
</div>

</body>
</html>
</cffunction>
<cffunction name="generateLetters">
	<!---CHECK JUST TO LET THEM KNOW IF THERE ARE ANY STUDENTS THAT FIT THEIR CRITERIA OR NOT--->
	<cfquery name="getStudentType" datasource="eAcceptance">
                select * from student_types where type_id='#Form.student_type#' and deleted_column is null
            </cfquery>
	<cftry>
            <cfstoredproc  procedure="WWOKEACC.F_FIND_ACCEPTED" datasource="eAcceptanceBanner">
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="application_type" type="in" value="#trim(getStudentType.db_id)#">  <!---change this when honors students have been added to the API (#Form.student_type#)--->
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="term_code" type="in" value="#Form.app_term#"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="start_date" type="in" value="#Form.start_date#"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="end_date" type="in" value="#Form.end_date#"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_sort_column" type="in" value="STUDENT_ID"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_sort_order" type="in" value="ASC"> 
            <cfprocresult name="out_result_set_students">
            </cfstoredproc>
        <cfcatch>
            <cfset query=QueryNew("")>
            <cfoutput>#cfcatch.message# #cfcatch.Detail#</cfoutput>
            <cfreturn false>
        </cfcatch>
        </cftry>
	
    	<cfif out_result_set_students.RecordCount eq 0>
        	<h3>Sorry, no students fit your entered criteria.  Please <a href="index.cfm">try again</a>.</h3><br><br><br><br><br>
            <cfreturn false>
        </cfif>
	<!---CHECK IF SEMESTERS MATCH--->
	<cfquery name="getSemester" datasource="eAcceptance">
	select * from student_types where type_id=#Form.student_type#
	</cfquery>
	<cfset app_semester=Right(Form.app_term, 2)>
	<cfif getSemester.all_semesters neq "X" and getSemester.semester neq app_semester>
		<h3>Sorry, your "Student Type" semester must match your "Application Term". Please <a href="index.cfm">try again</a>.</h3><br><br><br><br><br>
		<cfreturn false>
	</cfif>
	<!---DONE CHECKING--->

	<cfset individual_pantherids=false>
	<cfset myArray=ArrayNew(1)>
	<cfset array_index=1>
	<cfset fullArray=ArrayNew(1)>
	<cfset full_array_index=1>
	<cfloop index="i" from="1" to="10">
		<cfif isDefined("Form.send_pantherid_#i#") and Form["send_pantherid_#i#"] neq "">
			<cfset individual_pantherids=true>
			<cfset pantherid_found=false>
			<cfloop query="out_result_set_students">
				<cfif student_id eq Form["send_pantherid_#i#"]>
					<cfset pantherid_found=true>
				</cfif>
			</cfloop>
			<cfif pantherid_found eq false>
				<cfset myArray[array_index]=Form["send_pantherid_#i#"]>
				<cfset array_index=array_index+1>
			</cfif>
		</cfif>
		<cfset pantherid_found=false>
		<CFIF Form["send_pantherid_#i#"] neq "">
			<cfset fullArray[full_array_index]=Form["send_pantherid_#i#"]>
			<cfset full_array_index=full_array_index+1>
		</CFIF>
	</cfloop>
	<cfif ArrayLen(myArray) gte 1 and myArray[1] neq "">
		<cfoutput><p><cfif ArrayLen(myArray) gt 1>These students<cfelse>This student</cfif> (<cfloop from="1" to="#ArrayLen(myArray)#" index="o"><cfif o gt 1>,</cfif>#myArray[o]#</cfloop>) <cfif ArrayLen(myArray) gt 1>do<cfelse>does</cfif> not meet the criteria of being sent a letter using the app term, student type, and acceptance dates you entered.  Please try again.</p></cfoutput>
		<cfreturn false>
	</cfif>
	
	
	<cfif isDefined("Form.save_template")>
		<cfset template_text=#Replace(template_text, "</p>", "", "all")#>
		<cftransaction>
			<cfquery name="getid" datasource="eAcceptance">
				SELECT MAX(template_id) as template_id FROM saved_templates
			</cfquery>
			<cfif getid.template_id eq "">
				<cfset new_template_id=1>
			<cfelse>
				<cfset new_template_id=int(#getid.template_id# + 1)>
			</cfif>
			<cfquery name="submitResidencyParagraph" datasource="eAcceptance">
				insert into saved_templates(template_id, template_date, template_text, template_type) values (#new_template_id#, #NOW()#, '#Form.template_text#', '#Form.student_type#')
			</cfquery>
		</cftransaction>
	</cfif>
	
    
	<cfoutput>
	<!---insert into saved_templates(template_id, template_date, template_text, template_type) values (#new_template_id#, #NOW()#, '#Form.template_text#', '#Form.student_type#')--->
    
    <cfif individual_pantherids eq true>
	<cfset numstudentsselected=ArrayLen(fullArray)>
    <cfelse>
	<cfset numstudentsselected=out_result_set_students.RecordCount>
    </cfif>
    <p><b><cfif numstudentsselected gt 2900><span style="color:red"></cfif><span style="color:red">#numstudentsselected# students</span></span></b> have been selected.</p>
    <cfif numstudentsselected gt 2900>
    	<p><i>Please limit the number of your students in each job to 2900.  Please select a tighter date range to limit the number of your students.  Thank you!</i></p>
    	<cfinvoke method="showGenLetterForm" />
    <cfelse>
        <div id="release" style="width:740px;">
            <h3 style="margin-top:0px;">Generate Default Letters</h3>
            <div style="padding-left:20px; padding-right:20px; padding-bottom:10px;padding-top:10px;">
            
            
            
	    <cfset studtype=getStudentType.type_id>
            <cfset curtemplatetype=studtype>
            
            <cfquery name="getTemplateType" datasource="eAcceptance">
                select * from template_types where type_id=#curtemplatetype#
            </cfquery>
            
            
            <p>This is the current <b><!---#getTemplateType.template_type#--->#getStudentType.student_type#</b> eAcceptance Letter.  By clicking the "SEND" icon, you will send eAcceptance Letters to <cfif individual_pantherids eq true>the students you specified<cfelse>all  <b>#getStudentType.student_type#</b> accepted for the <b>#Form.app_term#</b> term between <b>#Form.start_date#</b> and <b>#Form.end_date#</b></cfif>.  Click the "EDIT" icon to change the wording of the letter.  Click the "CANCEL" icon if you do not wish to proceed.
    
            <cfquery name="getResidencyParagraphs" datasource="eAcceptance">
                select * from residency_extra_info where info_type='paragraph1' and (info_text is null or to_char(info_text) = '')
            </cfquery>
            <cfif getResidencyParagraphs.RecordCount gt 0>
                <p style="color:red;">Some of the residency paragraphs have no text.  Please note, if you have included the residency paragraph tag, this will be blank for <span style="white-space: nowrap;">type(s): <cfset count=0><cfloop query="getResidencyParagraphs"> <cfif count gt 0>, </cfif>#residency_type#<cfset count=count+1></cfloop>.</span>  If you would like to place text for these residency paragraphs, you may do that <a href="index.cfm?option=2">here</a>.</p>
            </cfif>
            
            <!---<script language="javascript" src="/FCKeditor/fckeditor.js"></script>
            <script type="text/javascript">
                <!--
                var editorName="email_body";
                var oFCKeditor = new FCKeditor( editorName ) ;
                oFCKeditor.BasePath = '/FCKeditor/' ;
                oFCKeditor.Width = "700px";
                oFCKeditor.Height = "500px";
                var texteditorvalue = '' ;
                oFCKeditor.Value = texteditorvalue;
                oFCKeditor.Create() ;
                //-->
            </script>--->
            
            <cfquery name="getTemplate" datasource="eAcceptance">
            select * from saved_templates where template_type=#curtemplatetype# order by template_date desc
            </cfquery>
	    <cfquery name="getSemester" datasource="eAcceptance">
	    select * from student_types where type_id=#curtemplatetype#
	    </cfquery>
            <cfif getSemester.semester eq "08">
		<cfset sendsemester="Fall">
		<cfelseif getSemester.semester eq "05">
		<cfset sendsemester="Summer">
		<cfelse>
		<cfset sendsemester="Spring">
		</cfif>
	    
            <!--- Create a Random number so that duplicate letters won't be stored --->
            <!--- Assign the current date and time to a variable. --->
            <cfset tdstamp="#DateFormat(Now(),'mmddyyyy')##TimeFormat(Now(),'hhmmss')#">
            <!--- Create a random number. --->
            <cfset randomnum1=RAND()*100000000>
            <!--- Create another random number. --->
            <cfset randomnum2=RAND()*100000000>
            <!--- Concatenate the first random number, the time and date stamp, and the second random number. --->
            <cfset uniquenumber="#randomnum1##tdstamp##randomnum2#">
		<cfset pantherid_list=ArrayToList(fullArray)>
    
            
    
            <form action="index.cfm?try=#uniquenumber#" method="post">
            <div width="100%" align="right"><cfif getTemplate.RecordCount gt 0><input type="submit" value="Send" name="send_letters" onclick="return confirm_send();"></cfif> <input type="submit" value="Edit" name="edit_letter"> <input type="button" value="Cancel" name="cancel" onclick="document.location='index.cfm';"></div><br>
            <cfif getTemplate.RecordCount eq 0>
		<input type="hidden" name="TEMPLATE_TEXT" value="">
                <p>There is no current  <b>#sendsemester# #getStudentType.student_type#</b> template. Please click Edit to create the template.</p>
            <cfelse>
                <cfset temp_template_text=#Replace(getTemplate.template_text, "</p>", "</p><br>", "all")#>
                <cfset temp_template_text=Replace(temp_template_text, "scott_sig.jpg", "scott_sig_blue.jpg")>
                <cfset temp_template_text=Replace(temp_template_text, "scott_sig.gif", "scott_sig_blue.gif")>
                <cfoutput>#temp_template_text#</cfoutput>
		<input type="hidden" name="TEMPLATE_TEXT" value='#temp_template_text#'>
            </cfif>
            <!---because I have to save all values for after they save the template--->
            <br><br><cfif getTemplate.RecordCount gt 0><input type="submit" value="Send" name="send_letters" onclick="return confirm_send();"></cfif> <input type="submit" value="Edit" name="edit_letter"> <input type="button" value="Cancel" name="cancel" onclick="document.location='index.cfm';">
            <input type="hidden" name="template_id" value="#getTemplate.template_id#">
            <input type="hidden" name="template_type" value="#Form.template_type#">
            <input type="hidden" name="student_type" value="#Form.student_type#">
            <!---<input type="hidden" name="admission_type" value="#Form.admission_type#">--->
            <input type="hidden" name="app_term" value="#Form.app_term#">
            <input type="hidden" name="start_date" value="#Form.start_date#">
            <input type="hidden" name="end_date" value="#Form.end_date#">
            <input type="hidden" name="letter_text" value='#Replace(getTemplate.template_text, "'", '&acute;', 'all')#'>
            <input type="hidden" name="num_students_selected" value="#numstudentsselected#">
		<input type="hidden" name="individual_pantherids" value="#pantherid_list#">
            </form>
            </div>  
        </div>
    </cfif>
	</cfoutput>
</cffunction> 
<cffunction name="sendLetters">

	<cfoutput>
	<cfset newlettertext=Replace("#Form.letter_text#", "'", "@@", "all")>
   <cfset newlettertext=Replace(newlettertext,chr(39),"@@","All")>
	<cfset newlettertext=Replace(newlettertext,chr(13),"","All")>
	<cfset newlettertext=Replace(newlettertext,chr(10),"","All")>
	<cfset newlettertext=Replace(newlettertext,chr(160)," ","All")>
    
   <!---<cftry>
	<script>
	var http = new XMLHttpRequest();
	var url = "insertSentLetters.cfm";
	var params = 'try=#URL.try#&letter_text=#newlettertext#&template_id=#Form.template_id#&student_type=#Form.student_type#&app_term=#Form.app_term#&template_type=#Form.template_type#&start_date=#Form.start_date#&end_date=#Form.end_date#&batch=1';
    //admission_type=##Form.admission_type##
    //alert(params);
	http.open("POST", url, true);
    <cfcatch>
        
        <cfmail from="christina@gsu.edu" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="error sending letters">
            <cfoutput><B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
            </cfmail>
        
        </cfcatch>
        </cftry>
	
	//Send the proper header information along with the request
	http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	http.setRequestHeader("Content-length", params.length);
	http.setRequestHeader("Connection", "close");
	
	http.onreadystatechange = function() {//Call a function when the state changes.
		if(http.readyState == 4 && http.status == 200) {
			//alert(http.responseText);
		}
	}
	http.send(params);
	</script>--->
	
	
	
	
	
	</cfoutput>


	<!---<script language="javascript" type="text/javascript">
		var load = window.open('sendLetters.cfm','sending_letters','width=300, height=200, resizable=yes, scrollbars=yes, toolbar=no, location=no, directories=no, status=yes, menubar=no, copyhistory=no')
	</script>--->
	<!---first launch PDF--->
	<cfoutput>
	<script>
	/*function redirectOutput(myForm) {
	var w = window.open("sendLetters.cfm?try=#URL.try#",'Popup_Window','sendLetters.cfm','sending_letters','width=300, height=200, resizable=yes, scrollbars=yes, toolbar=no, location=no, directories=no, status=yes, menubar=no, copyhistory=no');
	myForm.target = 'Popup_Window';
	return true;
	}*/
	</script>
	
	<form id="openPdfForm" name="openPdfForm" action="sendLetters.cfm" method="post" target="_blank">
	<input type="hidden" name="try" value="#URL.try#">
	<input type="hidden" name="template_id" value="#Form.template_id#">
	<input type="hidden" name="student_type" value="#Form.student_type#">
	<input type="hidden" name="app_term" value="#Form.app_term#">
	<input type="hidden" name="template_type" value="#Form.template_type#">
	<!---<input type="hidden" name="admission_type" value="#Form.admission_type#">--->
	<input type="hidden" name="start_date" value="#Form.start_date#">
	<input type="hidden" name="end_date" value="#Form.end_date#">
    <input type="hidden" name="letter_text" value='#Replace("#Form.letter_text#", "'", "&acute;", "all")#'>
    <input type="hidden" name="studentsectionnum" value="1">
	<cfif isDefined("Form.individual_pantherids")><input type="hidden" name="individual_pantherids" value="#Form.individual_pantherids#"></cfif>
	</form>
    
    <form id="openEnvelopeAddresses" name="openEnvelopeAddresses" action="showAddresses.cfm" method="post" target="_blank">
	<input type="hidden" name="try" value="#URL.try#">
	<input type="hidden" name="letter_text" value='[STUDENT NAME]<br>[ADDRESS 1]<br>[ADDRESS 2]'>
	<input type="hidden" name="template_id" value="#Form.template_id#">
	<input type="hidden" name="student_type" value="#Form.student_type#">
	<input type="hidden" name="app_term" value="#Form.app_term#">
	<input type="hidden" name="template_type" value="#Form.template_type#">
	<!---<input type="hidden" name="admission_type" value="#Form.admission_type#">--->
	<input type="hidden" name="start_date" value="#Form.start_date#">
	<input type="hidden" name="end_date" value="#Form.end_date#">
    <input type="hidden" name="studentsectionnum" value="1">
	<cfif isDefined("Form.individual_pantherids")><input type="hidden" name="individual_pantherids" value="#Form.individual_pantherids#"></cfif>
	</form>
	</cfoutput>
	
	
	<!---then continue--->

	
	<!---HERE, UPDATE STUDENTS--->
	
	<h2>Letters Created</h2>
	<!---<p>First, please send out each batch of students individually.</p><br>--->
	<!---<p>The links below may not work if you click on them too quickly before all the students are sent out.  Please remember that you can always access the letters and addresses from the Previous Mailings tab.</p>--->
	

	
	
	<cfoutput>
	<cfloop index="studcount" from="1" to="#int((Form.num_students_selected / 500) + 1)#">
	<cftry>
		<cfset mytry='#URL.try#&letter_text=#URLEncodedFormat(newlettertext)#&template_id=#Form.template_id#&student_type=#Form.student_type#&app_term=#Form.app_term#&template_type=#Form.template_type#&start_date=#Form.start_date#&end_date=#Form.end_date#&batch=#studcount#'>
		<cfif isDefined("Form.individual_pantherids") and Form.individual_pantherids neq ""><cfset mytry=mytry & '&individual_pantherids=#Form.individual_pantherids#'></cfif>

	<script type="text/javascript">

	var http = new XMLHttpRequest();
	var url = "insertSentLetters.cfm";
	var params = 'try=#URL.try#&letter_text=#URLEncodedFormat(newlettertext)#&template_id=#Form.template_id#&student_type=#Form.student_type#&app_term=#Form.app_term#&template_type=#Form.template_type#&start_date=#Form.start_date#&end_date=#Form.end_date#&batch=#studcount#';
	<cfif isDefined("Form.individual_pantherids") and Form.individual_pantherids neq "">var params=params+'&individual_pantherids=#Form.individual_pantherids#';</cfif>
	http.open("POST", url, true);
	<cfcatch>
        
	
        <!---<cfmail from="christina@gsu.edu" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="error sending letters">--->
            <cfoutput><B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
        <!---</cfmail>--->
        
        </cfcatch>
        </cftry>
	
	//Send the proper header information along with the request
	http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	http.setRequestHeader("Content-length", params.length);
	http.setRequestHeader("Connection", "close");
	
	http.onreadystatechange = function() {//Call a function when the state changes.
		if(http.readyState == 4 && http.status == 200) {
			//alert(http.responseText);
		}
	}
	http.send(params);
	</script>

	<cfif studcount gt 5>
	
	</cfif>
	</cfloop>
	</cfoutput>
	
	<cfmail from="christina@gsu.edu" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="mail1">
			test2
		    </cfmail>
	<cfquery name="getStudentType" datasource="eAcceptance">
                select * from student_types where type_id='#Form.student_type#'
            </cfquery>
	<!---<cftry>
	<CFSTOREDPROC PROCEDURE = "WWOKEACC.F_UPDATE_LETTERS" datasource = "eAcceptanceBanner" returncode = no>
	    <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="application_type" type="in" value="#getStudentType.db_id#"> 
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
	</cftry>--->
	
	
	
    <!---<h3>Launch Admission Letters</h3>
    <cfset numsections = ceiling(Form.num_students_selected / 1000)>
    <cfloop index="i" from="1" to="#numsections#">
		<cfoutput>
        <p><b>Students #int(((i-1)*1000)+1)# - <cfif Form.num_students_selected lt i*1000>#Form.num_students_selected#<cfelse>#int(i*1000)#</cfif></b></p>
        <p><a href="javascript:document.openPdfForm.studentsectionnum.value=#i#;document.openPdfForm.submit();">Admission Letters</a></p>
        <p><a href="javascript:document.openEnvelopeAddresses.studentsectionnum.value=#i#;document.openEnvelopeAddresses.submit();">Envelope Addresses</a></p><br><br><br>
        </cfoutput>
    </cfloop>--->
    <p>Please access your sent letters and address files from the <a href="index.cfm?option=3">Previous Mailings</a> tab.  Please note that it may take a minute for large batches of letters to be sent out.</p>
	  <!--- <cftry>
	  <cfhttp url="insertSentLetters.cfm" method="post" timeout="120" throwOnError="yes">
	  	 <CFHTTPPARAM TYPE="Formfield"
        VALUE="#URL.try#"
        NAME="try">
			 <CFHTTPPARAM TYPE="Formfield"
        VALUE="#Replace('#Form.letter_text#', "'", "&acute;", "all")#"
        NAME="letter_text">
			 <CFHTTPPARAM TYPE="Formfield"
        VALUE="#Form.template_id#"
        NAME="template_id">
			 <CFHTTPPARAM TYPE="Formfield"
        VALUE="#Form.student_type#"
        NAME="app_term">
			 <CFHTTPPARAM TYPE="Formfield"
        VALUE="#Form.app_term#"
        NAME="emailaddress">
			 <CFHTTPPARAM TYPE="Formfield"
        VALUE="#Form.template_type#"
        NAME="template_type">
					 <CFHTTPPARAM TYPE="Formfield"
        VALUE="#Form.admission_type#"
        NAME="admission_type">
					 <CFHTTPPARAM TYPE="Formfield"
        VALUE="#Form.start_date#"
        NAME="start_date">
			<CFHTTPPARAM TYPE="Formfield"
        VALUE="#Form.end_date#"
        NAME="end_date">
	  </cfhttp>
	  <cfcatch><cfoutput>#cfcatch.message# -> #cfcatch.detail#</cfoutput></cfcatch>
	   </cftry>--->
       
	<script>
	/*commenting this out on 2/2/12 because they may not want the student letters opened...they may want to open the parent letters
	 document.openPdfForm.studentsectionnum.value=1;
	setTimeout("document.getElementById('openPdfForm').submit();",1000);*/
	</script>
</cffunction>     
<cffunction name="editLetter">
	<h1>Admissions Status Check | Edit Current Letter</h1>
	<p>The Admissions Status Check enables you to generate eAcceptance letters for accepted students.  You may view the current letter, edit the current letter, and generate an acceptance letter below.</p>
	<p>Click on the <i>Previous Mailings</i> tab to view all the previous letters sent out by application cycle.</p>
	
	<!---<cfquery name="getStudentTypes" datasource="eAcceptance">
		select * from student_types where deleted_column is null <cfif isDefined("URL.admit_type")> and admit_type='#URL.admit_type#'</cfif> order by all_semesters,semester,student_type
	</cfquery>--->
    
    
    <p>Please choose which template you would like to edit:
	<div>
	<select name="admit_type" id="admit_type">
		<option value="a" <cfif isDefined("URL.admit_type") and URL.admit_type eq "a">selected</cfif>>Accepted</option>
		<option value="d" <cfif isDefined("URL.admit_type") and URL.admit_type eq "d">selected</cfif>>Denied</option>
		<option value="df" <cfif isDefined("URL.admit_type") and URL.admit_type eq "df">selected</cfif>>Deferred</option>
		<option value="w" <cfif isDefined("URL.admit_type") and URL.admit_type eq "w">selected</cfif>>Withdrawn</option>
		<option value="wl" <cfif isDefined("URL.admit_type") and URL.admit_type eq "wl">selected</cfif>>Wait List</option>
	</select>&nbsp; <input type="button" value="Choose" onclick="document.location='index.cfm?option=6&admit_type='+document.getElementById('admit_type').options[document.getElementById('admit_type').selectedIndex].value"></p>

		
		
		<cfif isDefined("URL.admit_type") and URL.admit_type eq "a">
			<p>Student Type Category:</p>
				
					<select name="studenttype_cat" id="studenttype_cat">
						<option value="int">International</option>
						<option value="other" <cfif isDefined("URL.studenttype_cat") and URL.studenttype_cat eq "other">selected</cfif>>Other</option>
					</select> <input type="button" value="Choose" onclick="document.location='index.cfm?option=6&admit_type='+document.getElementById('admit_type').options[document.getElementById('admit_type').selectedIndex].value+'&studenttype_cat='+document.getElementById('studenttype_cat').options[document.getElementById('studenttype_cat').selectedIndex].value"></p>
			
		</cfif>
		<cfquery name="getStudentTypes" datasource="eAcceptance">
					select * from student_types where type_id <> 4 and db_id<>'PAR' and deleted_column is null <cfif isDefined("URL.admit_type")>and admit_type='#URL.admit_type#'</cfif> <cfif isDefined("URL.studenttype_cat")>and type_category='#URL.studenttype_cat#'</cfif> order by all_semesters,semester,student_type
		</cfquery>
		
			
		
		
	<cfif isDefined("URL.admit_type") and URL.admit_type eq "a">
		<cfset label="admit">
	<cfelseif isDefined("URL.admit_type") and URL.admit_type eq "d">
		<cfset label="deny">
	<cfelseif isDefined("URL.admit_type") and URL.admit_type eq "df">
		<cfset label="defer">
	<cfelseif isDefined("URL.admit_type") and URL.admit_type eq "w">
		<cfset label="withdrawn">
	<cfelseif isDefined("URL.admit_type") and URL.admit_type eq "wl">
		<cfset label="wait list">
	<cfelse>
		<cfset label="">'
	</cfif>
	<!---<cfif  isDefined("URL.admit_type") and URL.admit_type neq "" and getStudentTypes.RecordCount gt 0>--->
	<cfif isDefined("URL.admit_type") and (URL.admit_type neq "a" or isDefined("URL.studenttype_cat"))>
		<p>Student Types:</p>
		<cfoutput><select name="template_type_#label#" id="template_type_#label#"></cfoutput>
			<!---<option <cfif (isDefined("URL.template_type") and URL.template_type eq "1") or (isDefined("Form.template_type") and Form.template_type eq "1")>selected</cfif> value="1">Freshmen</option>
			<option <cfif (isDefined("URL.template_type") and URL.template_type eq "4") or (isDefined("Form.template_type") and Form.template_type eq "4")>selected</cfif> value="4">Honors</option>
			<option <cfif (isDefined("URL.template_type") and URL.template_type eq "5") or (isDefined("Form.template_type") and Form.template_type eq "5")>selected</cfif> value="5">Parents</option>
			<option <cfif (isDefined("URL.template_type") and URL.template_type eq "10") or (isDefined("Form.template_type") and Form.template_type eq "10")>selected</cfif> value="10">SA</option>
			<option <cfif (isDefined("URL.template_type") and URL.template_type eq "11") or (isDefined("Form.template_type") and Form.template_type eq "11")>selected</cfif> value="11">SAP</option>
			<option <cfif (isDefined("URL.template_type") and URL.template_type eq "15") or (isDefined("Form.template_type") and Form.template_type eq "15")>selected</cfif> value="15">Spring Defer Letter</option>
			<option <cfif (isDefined("URL.template_type") and URL.template_type eq "16") or (isDefined("Form.template_type") and Form.template_type eq "16")>selected</cfif> value="16">PATH Defer Letter</option>--->
			
			<cfoutput query="getStudentTypes">
				<option <cfif (isDefined("URL.template_type") and URL.template_type eq "#type_id#") or (isDefined("Form.template_type") and Form.template_type eq "#type_id#")>selected</cfif> value="#type_id#"><cfif <!---db_id neq "K" and db_id neq "B" and db_id neq "C" and db_id neq "X" and db_id neq "PEP" and db_id neq "DXF" and db_id neq "DXT" and db_id neq "DXX" and db_id neq "DXB" and db_id neq "DXDE" and db_id neq "FI" and db_id neq "TI"---> all_semesters eq ""><cfif semester eq "08">Fall<cfelseif semester eq "05">Summer<cfelse>Spring</cfif> </cfif>#student_type# <cfif isDefined("URL.admit_type")><cfif URL.admit_type eq "a">(Accepted)<cfelseif URL.admit_type eq "d">(Denied)<cfelseif URL.admit_type eq "w">(Withdrawn)<cfelseif URL.admit_type eq "wl">(Wait List)</cfif></cfif></option>
			</cfoutput>
			<!---<option <cfif (isDefined("URL.template_type") and URL.template_type eq "5") or (isDefined("Form.template_type") and Form.template_type eq "5")>selected</cfif> value="5">Parents</option>--->
		</select>
		<cfoutput><input type="button" value="Choose" onclick="document.location='index.cfm?option=6&template_type='+document.getElementById('template_type_#label#').options[document.getElementById('template_type_#label#').selectedIndex].value + '&admit_type=<cfif isDefined("URL.admit_type")>#URL.admit_type#</cfif>'<cfif isDefined("URL.admit_type") and URL.admit_type eq "a">+'&studenttype_cat='+document.getElementById('studenttype_cat').options[document.getElementById('studenttype_cat').selectedIndex].value</cfif> "></cfoutput>
	<cfelseif getStudentTypes.RecordCount eq 0>
		<p>There are none of this admit type yet.</p>
	</cfif>
	</div>
	<cfif isDefined("URL.template_type") or isDefined("Form.template_type")>
		<cfif isDefined("Form.template_type")>
        	<cfset template_text=#Replace(Form.template_text, "<p>", "", "all")#>
			<cfset template_text=#Replace(template_text, "</p>", "", "all")#>
			<cftransaction>
				<cfquery name="getid" datasource="eAcceptance">
					SELECT MAX(template_id) as template_id FROM saved_templates
				</cfquery>
				<cfif getid.template_id eq "">
					<cfset new_template_id=1>
				<cfelse>
					<cfset new_template_id=int(#getid.template_id# + 1)>
				</cfif>
				<cfquery name="submitResidencyParagraph" datasource="eAcceptance">
					insert into saved_templates(template_id, template_date, template_text, template_type) values (#new_template_id#, #NOW()#, '#Form.template_text#', '#Form.student_type#')
				</cfquery>
			</cftransaction>
		</cfif>
		<cfif isDefined("Form.template_type")><p style="color:red;">Thank you, your template has been submitted!</p></cfif>
		<h2>
		<cfif (isDefined("URL.student_type") and URL.student_type eq "1") or (isDefined("Form.student_type") and Form.student_type eq "1")>Freshmen
		<cfelseif (isDefined("URL.student_type") and URL.student_type eq "4") or (isDefined("Form.student_type") and Form.student_type eq "4")>Honors
		</cfif>
		</h2>
    
    
    
    
    
    <cfset plugin_name="tokens">
    <cfif (isDefined("URL.template_type") and URL.template_type eq 5) or (isDefined("Form.template_type") and Form.template_type eq 5)>
	<cfset plugin_name="tokens_parents">
<cfelse>
	<cfset plugin_name="tokens">
    </cfif>
    
    <div id="release">
	<h3>Edit Current Letter</h3>
	<p>NOTE:<br>
	This eAcceptance letter was saved on <b>[CREATION DATE]</b>.  Edit the letter below and click the "SAVE" icon to generate a new eAcceptance letter.  The current eAcceptance letter will be saved in the <i>Previous Mailings</i> tab.  If you wish to send a previous eAcceptance letter, click on the <i>Previous Mailings</i> tab and choose the appropriate letter.</p>
	<p>All variables will be inserted when you choose an option from the combo box in the text editor labelled "Custom Information".</p>
	</div>    
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	
	<form action="index.cfm" method="post">
	<cfif isDefined("Form.template_id") and Form.template_id neq "">
		<cfquery name="getCurrentTemplate" datasource="eAcceptance">
			select * from saved_templates where template_id=#Form.template_id#
		</cfquery>
    <cfelseif Session.option eq 6>
    	<cfquery name="getCurrentTemplate" datasource="eAcceptance">
			select * from saved_templates where template_type=#URL.template_type# order by template_date desc
		</cfquery>
	</cfif>
		<div width="100%" align="right">
         <cfif Session.option eq 6>
        	<input type="submit" value="Save" name="save_template_option6"> <input type="button" onclick="document.location='index.cfm?option=1';" value="Cancel" name="cancel_template">
         <cfelse>
         	<input type="submit" value="Save" name="save_template"> <input type="submit" value="Cancel" name="cancel_template">
        </cfif>
        </div>
			<cfoutput><textarea cols="80" id="template_text" name="template_text" rows="10"><cfif isDefined("getCurrentTemplate.template_text")>#getCurrentTemplate.template_text#</cfif></textarea></cfoutput>
			<cfoutput>
			<script type="text/javascript">
			//<![CDATA[

				// This call can be placed at any point after the
				// <textarea>, or inside a <head><script> in a
				// window.onload event handler.

				// Replace the <textarea id="editor"> with an CKEditor
				// instance, using default configurations.
				/*CKEDITOR.replace( 'template_text',{    
skin : 'v2',
toolbar :     
[        
['Source','-','Save','NewPage','Preview','-','Templates'],
	['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker'],
	['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
	'/',
	['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
	['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
	['BidiLtr', 'BidiRtl' ],
	['Link','Unlink','Anchor'],
	['Image','HorizontalRule','SpecialChar','PageBreak'],
	['Styles','Format','Font','FontSize','#plugin_name#'],
	['TextColor','BGColor']
],   
extraPlugins: '#plugin_name#'
}    
);*/

			//]]>
			
			  
			CKEDITOR.replace( 'template_text', {
	skin : 'moono',
	toolbar: [
		{ name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },	// Defines toolbar group with name (used to create voisdce label) and items in 3 subgroups.
		[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],			// Defines toolbar group without name.
		['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
	'/',
	['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
	['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
	['BidiLtr', 'BidiRtl' ],
	['Link','Unlink','Anchor'],
	['Image','Table','HorizontalRule','SpecialChar','PageBreak'],
	['TextColor','BGColor'],
	'/',
	['Styles','Format',<!---'Font',--->'FontSize','#plugin_name#']
	],
	extraPlugins: '#plugin_name#,colorbutton,font'
})
	//config.extraPlugins='#plugin_name#,justify,colorbutton';
	//config.colorButton_colors = 'CF5D4E,454545,FFF,CCC,DDD,CCEAEE,66AB16';
			</script>
			</cfoutput>
<!--- full toolbar is:

['Source','-','Save','NewPage','Preview','-','Templates'],
	['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker', 'Scayt'],
	['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
	['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField'],
	'/',
	['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
	['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
	['BidiLtr', 'BidiRtl' ],
	['Link','Unlink','Anchor'],
	['Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak'],
	'/',
	['Styles','Format','Font','FontSize'],
	['TextColor','BGColor'],
	['Maximize', 'ShowBlocks','-','About'],
	['tokens']
	
	--->
	<cfoutput>
    <cfif Session.option eq 6>
    	<input type="hidden" name="template_id" value="#getCurrentTemplate.template_id#">
        <!---<input type="hidden" name="template_type" value="<cfif isDefined('URL.template_type')>#URL.template_type#<cfelseif isDefined('Form.template_type')>#Form.template_type#</cfif>">--->
	<input type="hidden" name="template_type" value="<cfif isDefined("Form.student_type")>#Form.student_type#<cfelseif isDefined('URL.template_type')>#URL.template_type#<cfelseif isDefined('Form.template_type')>#Form.template_type#</cfif>">
        <input type="hidden" name="option" value="1">
    <cfelse>
        <input type="hidden" name="template_id" value="#Form.template_id#">
        <input type="hidden" name="template_type" value="#Form.template_type#">
        <input type="hidden" name="student_type" value="#Form.student_type#">
        <!---<input type="hidden" name="admission_type" value="#Form.admission_type#">--->
        <input type="hidden" name="app_term" value="#Form.app_term#">
        <input type="hidden" name="start_date" value="#Form.start_date#">
        <input type="hidden" name="end_date" value="#Form.end_date#">
    </cfif>
	</cfoutput>
      <cfif Session.option eq 6>
        	<input type="submit" value="Save" name="save_template_option6"> <input type="button" onclick="document.location='index.cfm?option=1';" value="Cancel" name="cancel_template">
         <cfelse>
         	<input type="submit" value="Save" name="save_template"> <input type="submit" value="Cancel" name="cancel_template">
        </cfif>
	</form>
	 </cfif>
</cffunction>  
<cffunction name="saveTemplate">
	<cftransaction>
		<cfquery name="getid" datasource="eAcceptance">
			SELECT MAX(template_id) as template_id FROM saved_templates
		</cfquery>
		<cfif getid.template_id eq "">
			<cfset new_template_id=1>
		<cfelse>
			<cfset new_template_id=int(#getid.template_id# + 1)>
		</cfif>
		<cfquery name="save_template" datasource="eAcceptance">
			insert into saved_templates (template_id, template_date, template_text, template_type) values (#new_template_id#, #NOW()#, <cfqueryparam value="#Form.template_text#">, <cfif isDefined("Form.student_type")>#Form.student_type#<cfelse>#Form.template_type#</cfif>)
		</cfquery>
	</cftransaction>
    <cfif isDefined("Form.save_template_option6")>
    	<h2 style="color:red;">Thank you, the template has been saved!</h2>
        <cfinvoke method="previewStudentsTab" />
        <cfset Session.option=1>
        <cfinvoke method="showHome" />
    <cfelse>
		<cfinvoke method="generateLetters" />
    </cfif>
</cffunction>
<cffunction name="showPrevMailings">
	<h1>Admissions Status Check | Previous Mailings</h1>
	<p>To find a previous eAcceptance Letter,</p>
	<ul>
		<li>Use any combination of filters (Student Type, Application Term, and Date Range) to limit the view of previous eAcceptance Letters</li>
		<li>Use the Panther # to find a specific Student</li>
	</ul>  
	<p>Click on the eAcceptance Letter Date in the results table to view the previous eAcceptance Letter.</p>
	<cfif isDefined("Form.start_date") and (Form.start_date eq "mm/dd/yyyy" or Form.end_date eq "mm/dd/yyyy")>
		<cfset incorrectinput="true">
		<span style="color:red;"><b><i>Please choose both dates before performing  your search.</i></b></span><br><br>
	<cfelseif isDefined("Form.panther_num") and Form.panther_num eq "">
		<cfset incorrectinput="true">
		<span style="color:red;"><b><i>Please specify the Panther # before performing your search.</i></b></span><br><br>
	</cfif>
	<div id="release">
		<h3>Filter Previous Letters</h3>
		<form method="post" action="index.cfm?option=3" style="margin-bottom:0px;">
		<table class="matrix" width="100%" cellspacing="25"<cfif isDefined("Form.student_type") or isDefined("URL.student_type")> style="background-color: #CBCBCB;"</cfif> style="margin-bottom:0px;">
			<tr>
				<td width="80px;">Student Type:</td>
				<td><select name="student_type">
				<cfquery name="getStudentTypes" datasource="eAcceptance">
					select * from student_types where db_id<>'PAR' and deleted_column is null order by all_semesters, semester,student_type <!---student_type='Freshman' or student_type='Honors'--->
				</cfquery>
				<cfoutput query="getStudentTypes">
					<option value="#type_id#" <cfif (isDefined("Form.student_type") and Form.student_type eq type_id) or (isDefined("URL.student_type") and URL.student_type eq type_id)>selected</cfif>><cfif isDefined("Form.student_type") and Form.student_type eq db_id>selected</cfif><cfif db_id neq "K" and db_id neq "B" and db_id neq "C" and db_id neq "X" and db_id neq "PEP"  and db_id neq "DXF" and db_id neq "DXT" and db_id neq "DXX" and db_id neq "DXB" and db_id neq "DXDE" and db_id neq "FI" and db_id neq "TI"><cfif semester eq "08">Fall<cfelseif semester eq "05">Summer<cfelse>Spring</cfif> </cfif>#student_type#</option>
				</cfoutput>
				</select></td>
				
			<td>Application Term:</td>
			<td>   
				<select name="app_term">
				<cfquery name="getAppTerms" datasource="eAcceptance">
					<!---select distinct(appterm) from sent_letters order by appterm--->
                    select distinct(app_term) from sent_templates where app_term is not null order by app_term 
                    <!---USE sent_templates because it is quicker than sent_letters!!!--->
                    <!---select distinct(appterm) from sent_letters where appterm is not null order by appterm--->
                    <!---select appterm from sent_letters order by appterm--->
				</cfquery>
				<cfoutput query="getAppTerms"><option <cfif (isDefined("Form.app_term") and Form.app_term eq #getAppTerms.app_term#) or (isDefined("URL.app_term") and URL.app_term eq #getAppTerms.app_term#)>selected</cfif>>#getAppTerms.app_term#</option></cfoutput>
				</select>
			</td>
			</tr>
			<tr>
			
			
			<cfoutput>
				<td align="right">Date Range:</td>
				<td colspan="3"> 
				<SCRIPT LANGUAGE="JavaScript">
				var cal1 = new CalendarPopup("popupcalendaradd"); 
				//cal1.showNavigationDropdowns();
				</SCRIPT> 
				<input  type="text" name="start_date" id="start_date" size="8" onfocus="alert('Please choose the date by clicking on the calendar to the right of the field.');this.blur();" value="<cfif isDefined('Form.start_date')>#Form.start_date#<cfelseif isDefined('URL.start_date')>#URL.start_date#<cfelse>mm/dd/yyyy</cfif>">
				 <img src="images/cal.gif" onClick="cal1.select(document.getElementById('start_date'),'anchor1','MM/dd/yyyy'); return false;" TITLE="start date calendar" NAME="anchor1" ID="anchor1">
				<div id="popupcalendaradd" STYLE="position:absolute;visibility:hidden;background-color:white;layer-background-color:white;font-family: Arial, Helvetica, sans-serif;font-size: 12px;"></div>
				&nbsp; 
			 	to 
			  	&nbsp; 
				<SCRIPT LANGUAGE="JavaScript">
				var cal2 = new CalendarPopup("popupcalendar2add"); 
				//cal2.showNavigationDropdowns();
				</SCRIPT>
				<input  type="text" name="end_date" id="end_date" size="8" onfocus="alert('Please choose the date by clicking on the calendar to the right of the field.');this.blur();"  onchange="" value="<cfif isDefined('Form.end_date')>#Form.end_date#<cfelseif isDefined('URL.end_date')>#URL.end_date#<cfelse>mm/dd/yyyy</cfif>">
				<img src="images/cal.gif" onclick="cal2.select(document.getElementById('end_date'),'anchor2','MM/dd/yyyy');" name="anchor2" id="anchor2">
				<div id="popupcalendar2add" STYLE="position:absolute;visibility:hidden;background-color:white;layer-background-color:white;font-family: Arial, Helvetica, sans-serif;font-size: 12px;"></div>
				</td>
				</cfoutput>
			
			
			<td align="right"><input type="submit" value="Search"></td></tr>
			</table>
			</form>
			<hr>
			<cfoutput>
			<form method="post" action="index.cfm?option=3">
			<table class="matrix" width="100%" cellspacing="25" <cfif isDefined("Form.panther_num") or isDefined("URL.panther_num")> style="background-color: ##CBCBCB;"</cfif>><!---D7D7D7--->
			<tr>
			<td style="width:80px;">Panther ##:</td>
			<td colspan="5"><input type="text" name="panther_num" value="<cfif isDefined('Form.panther_num')>#Form.panther_num#<cfelseif isDefined('URL.panther_num')>#URL.panther_num#</cfif>"></td>
			<tr><td colspan="6" align="right"><input type="submit" value="Search"></td></tr>
			</table>
			</form>
			</cfoutput>
	</div>
    <cfif not isDefined("Form.start_date") and not isDefined("Form.panther_num") and not isDefined("URL.pdf_id") and not isDefined("URL.start_date") and not isDefined("URL.panther_num")><cfinvoke method="showDefaultPrevLetters" /><cfreturn false></cfif>
	<cfif not isDefined("incorrectinput") or isDefined("URL.pdf_id")>
    	<cfif isDefined("URL.pdf_id")>
        	<cfquery name="getLetterDate" datasource="eAcceptance">
            select * from sent_templates where unique_id='#URL.pdf_id#'
            </cfquery>
            <cfoutput><h3>Letters Sent On #DateFormat(getLetterDate.sent_date, "m/dd/yyyy")# #TimeFormat(getLetterDate.sent_date, "h:mm tt")#</h3></cfoutput>
        </cfif>
        
		<cfset querystring="excel=true">
        <cfif isDefined("URL.option")><cfset querystring=querystring&"&option=#URL.option#"></cfif>
        <cfif isDefined("URL.pdf_id")><cfset querystring=querystring&"&pdf_id=#URL.pdf_id#"></cfif>
        <cfoutput><div width="100%" align="right"><a target="_blank" href="viewExcelLetters.cfm?#querystring#">Export to Excel</a></div></cfoutput>
		<cfinvoke method="showSentLetters">
	</cfif><br><br>
</cffunction>
<Cffunction name="showSentLetters">
	<cfquery name="getStudentTypes" datasource="eAcceptance">
        select * from student_types  where deleted_column is null
    </cfquery>
    <cfset rowcolor=1>
		<cfset rownum=0>
		<cfif not isDefined("URL.page")><cfset curPage=1>
		<cfelse><cfset curPage=URL.page></cfif>
	<table class="matrix" width="100%">
		<caption>Previous Letters</caption>
		<tr>
			<th>Student Type</th>
			<th>Application Term</th>
            <th>First Name</th>
            <th>Middle Initial</th>
            <th>Last Name</th>
			<th>Panther ID</th>
			<th>DOB</th>
			<th>eAcceptance Letter Date </th>
       
		</tr>
        <cfset student_types=ValueList(getStudentTypes.student_type, ",")>
	<cfset student_type_ids=ValueList(getStudentTypes.type_id, ",")>
         <cfif isDefined("URL.page")>
			<cfset fromnum= ((URL.page - 1) * 20 + 1)>
            <cfset tonum=URL.page * 20>
          <cfelse>
            <cfset fromnum= 1>
            <cfset tonum=20>
        </cfif>
        <cfif isDefined("URL.pdf_id")>      
        	<cfquery name="getSentLetters" datasource="eAcceptance">
            	<!---select * from sent_letters where pdf_unique_id='#URL.pdf_id#' order by letter_order--->
                 select * from (       
                    SELECT  x.*, rownum as r FROM (           
                    select APPDATE, APPTERM, LETTER_DATE, LETTER_ID, LETTER_TEXT, PDF_UNIQUE_ID, STUDENT_ID, STUDENT_TYPE, TEMPLATE_ID , rownum , student_fname, student_mi , student_lname      
                    from sent_letters  where pdf_unique_id='#URL.pdf_id#'            
                    order by letter_order       
                    ) x     
                    )     
                    <cfif not isDefined("URL.excel")>where r between #fromnum# AND #tonum#</cfif>
            </cfquery>
            <cfquery name="getLetterCount" datasource="eAcceptance">
            	select count(*) as lettercount from sent_letters  where pdf_unique_id='#URL.pdf_id#'<!--- order by letter_order--->
            </cfquery>
            <cfoutput query="getSentLetters">
            	<cfif rowcolor eq 2><cfset rowcolor=1>
				<cfelse><cfset rowcolor=2></cfif>
				<cfset rownum = rownum + 1>
				<!---<cfif rownum gte ((curPage - 1) * 20 + 1) and rownum lte (curPage * 20)>--->
                 <cfset tempstudentid=student_id>
                <cfloop index="i" from="1" to="5">
                	<cfif len(tempstudentid) lt 9>
                    	<cfset tempstudentid="0"&tempstudentid>
                    </cfif>
				</cfloop>
				<tr class="matrixrow#rowcolor#">
					<td>
						<cfquery dbtype="query" name="getStudentType">
							select * from getStudentTypes where type_id=#student_type#
						</cfquery> <!---#ListGetAt(student_types, student_type)#--->
						<cfif getStudentType.all_semesters eq ""><cfif #getStudentType.semester# eq "08">Fall<cfelseif getStudentType.semester eq "05">Summer<cfelse>Spring</cfif></cfif>  #getStudentType.student_type#<!---#ListGetAt(student_types, student_type)#--->
					</td>
					<td>#appterm#</td><td>#student_fname#</td><td>#student_mi#</td><td>#student_lname#</td><td style="vnd.ms-excel.numberformat:000000000">#tempstudentid#</td>
					
					<cftry>
					<cfstoredproc procedure="wwokbapi.f_get_pers" datasource="SCHOLARSHIPAPI">
						<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#tempstudentid#"> 
						<cfprocresult name="out_result_set">
					</cfstoredproc>
					<td>#DateFormat(out_result_set.BIRTH_DATE, "mm/dd/yyyy")#</td>
					<cfcatch>
						<cfif isDefined("catcherror.NativeErrorCode")>
							<cfset nativecode=catcherror.NativeErrorCode>
						<cfelse>
							<cfset nativecode=cfcatch.NativeErrorCode>
						</cfif>
						<cfif isDefined("nativecode")>
							<cfif nativecode eq 20102>
								<td><i>Confidential</i></td>
							<cfelse>
								<td></td>
							</cfif>
						<cfelse>
							<td></td>
						</cfif>
					</cfcatch>
					</cftry>
					
					<td nowrap><cfif not isDefined("URL.excel")><a id="greyboxlink" href="popup/prevLetter.cfm?letter_id=#letter_id#" title="View Previous Letter" rel="gb_page_center[500, 525]"></cfif>#DateFormat(letter_date, "mmmm d, yyyy")# #TimeFormat(letter_date, "h:mm tt")#</a></td></tr>
				<!---</cfif>--->
            </cfoutput>
		<cfelseif not (isDefined("Form.panther_num") and Form.panther_num eq "") or (isDefined("Form.start_date") and (Form.start_date eq "mm/dd/yyyy" or Form.end_date eq "mm/dd/yyyy"))>
			<cfset where="">
			<cfif isDefined("Form.panther_num")>
				<cfset where="student_id=#Form.panther_num#">
			<cfelseif isDefined("URL.panther_num")>
				<cfset where="student_id=#URL.panther_num#">
			<cfelseif isDefined("Form.student_type")>
            	<cfif isNumeric("#Form.student_type#")>
                	<cfset curtempstudtype=Form.student_type>
                <cfelse>
					<cfset curtempstudtype=ListFind(student_types, Form.student_type)>
				</cfif>
				<cfset where="student_type=#curtempstudtype# and (letter_date between #ParseDateTime(Form.start_date)# and #ParseDateTime('#Form.end_date# 11:59PM')#) and appterm='#Form.app_term#'">
				<!---for oracle?  (appdate between to_date('#Form.start_date#', 'mm/dd/yyyy') and to_date('#Form.end_date#', 'mm/dd/yyyy'))--->
			<cfelseif isDefined("URL.student_type")>
            	<cfif isNumeric("URL.student_type")>
                	<cfset curtempstudtype=URL.student_type>
                <cfelse>
					<cfset curtempstudtype=ListFind(student_types, URL.student_type)>
				</cfif>
				<cfset where="student_type=#curtempstudtype# and (letter_date between #ParseDateTime(URL.start_date)# and #ParseDateTime('#URL.end_date# 11:59PM')#) and appterm='#URL.app_term#'">
			</cfif>
 
            <cfquery name="getLetterCount" datasource="eAcceptance">
            	select count(*) as lettercount from sent_letters <cfif where neq "">where #PreserveSingleQuotes(where)#</cfif>
            </cfquery>
            
			<cfquery name="getSentLetters" datasource="eAcceptance">
            	<!---SELECT * FROM ( 
					SELECT ROWNUM as row_num, APPDATE, APPTERM, LETTER_DATE, LETTER_ID, LETTER_TEXT, PDF_UNIQUE_ID, STUDENT_ID, STUDENT_TYPE, TEMPLATE_ID  FROM sent_letters <cfif where neq "">where #PreserveSingleQuotes(where)#</cfif> over letter_date  desc)
					) 
					WHERE row_num BETWEEN #fromnum# AND #tonum#--->
                   <!--- SELECT * FROM 
                    (SELECT APPDATE, APPTERM, LETTER_DATE, LETTER_ID, LETTER_TEXT, PDF_UNIQUE_ID, STUDENT_ID, STUDENT_TYPE, TEMPLATE_ID, ROW_NUMBER() OVER letter_date R FROM table) 
                    WHERE R BETWEEN 0 and 100--->
                    <!---SELECT * FROM 
                    (SELECT x.*, rownum as row_num FROM sent_letters 
                    ORDER BY letter_date DESC) 
                    where row_num >= #fromnum# and row_num <= #tonum#--->
                     select * from (       
                    SELECT  x.*, rownum as r FROM (           
                    select APPDATE, APPTERM, LETTER_DATE, LETTER_ID, LETTER_TEXT, PDF_UNIQUE_ID, STUDENT_ID, STUDENT_TYPE, TEMPLATE_ID , rownum  , student_fname , student_mi , student_lname        
                    from sent_letters     <cfif where neq "">where #PreserveSingleQuotes(where)#</cfif>              
                    order by letter_date, letter_order   desc    
                    ) x     
                    )     
                    where r between #fromnum# AND #tonum#
			</cfquery>
			
			
			
			<cfoutput query="getSentLetters">
				<cfif rowcolor eq 2><cfset rowcolor=1>
				<cfelse><cfset rowcolor=2></cfif>
				<cfset rownum = rownum + 1>
				<!---<cfif rownum gte ((curPage - 1) * 20 + 1) and rownum lte (curPage * 20)>--->
                <cfset tempstudentid=student_id>
                <cfloop index="i" from="1" to="5">
                	<cfif len(tempstudentid) lt 9>
                    	<cfset tempstudentid="0"&tempstudentid>
                    </cfif>
				</cfloop>
				
				<cfset listindex=ListFind(student_type_ids, student_type)>

				<tr class="matrixrow#rowcolor#"><td><cfif listindex eq 0><cfelse>#ListGetAt(student_types, listindex)#</cfif></td><td>#appterm#</td><td>#student_fname#</td><td>#student_mi#</td><td>#student_lname#</td><td>#tempstudentid#</td>
					
					<cftry>
					<cfstoredproc procedure="wwokbapi.f_get_pers" datasource="SCHOLARSHIPAPI">
						<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#tempstudentid#"> 
						<cfprocresult name="out_result_set">
					</cfstoredproc>
					<td>#DateFormat(out_result_set.BIRTH_DATE, "mm/dd/yyyy")#</td>
					<cfcatch>
						<cfif isDefined("catcherror.NativeErrorCode")>
							<cfset nativecode=catcherror.NativeErrorCode>
						<cfelse>
							<cfset nativecode=cfcatch.NativeErrorCode>
						</cfif>
						<cfif isDefined("nativecode")>
							<cfif nativecode eq 20102>
								<td><i>Confidential</i></td>
							<cfelse>
								<td></td>
							</cfif>
						<cfelse>
							<td></td>
						</cfif>
					</cfcatch>
					</cftry>
					
					<td nowrap><a id="greyboxlink" href="popup/prevLetter.cfm?letter_id=#letter_id#" title="View Previous Letter" rel="gb_page_center[500, 525]">#DateFormat(letter_date, "mmmm d, yyyy")# #TimeFormat(letter_date, "h:mm tt")#</a></td><td></td></tr>
				<!---</cfif>--->
			</cfoutput>
			<cfif getSentLetters.RecordCount eq 0>
				<tr><td colspan="3" style="color:red"><b><i>Sorry, there are currently no records that match your search.</i></b></td></tr>
			</cfif>
		</cfif>
		<cfif isDefined("getSentLetters.RecordCount") and not isDefined("URL.excel")><cfoutput><tr><td colspan="7" align="center"><cfinvoke method="showPageNumbers" recordcount="#getLetterCount.lettercount#" /></td></tr></cfoutput></cfif>
	</table>
</Cffunction>
<cffunction name="showDefaultPrevLetters">
	<cfquery name="getStudentTypes" datasource="eAcceptance">
		select * from student_types order by type_id
	</cfquery>
    <!---<cfquery name="getOfferCodes" datasource="eAcceptance">
        select * from template_types
    </cfquery>
     <cfset offer_codes=ValueList(getOfferCodes.template_type, ",")>--->
     <cfset student_types=ValueList(getStudentTypes.student_type, ",")>
            
	<cfquery name="getLetterDates" datasource="eAcceptance">
    	<!---select * from sent_templates order by sent_date desc--->
	select * from sent_templates where sent_date>to_date('01-Jun-15', 'DD-MON-YY')  order by sent_date desc
    </cfquery>
	<!---only select from past June to speed up loading the page!!!--->
    <h2>Letters Sent</h2>
    <table cellspacing="10"><tr><th>Date Sent</th><!--<th>Offer Code<span style="color:red">*</span></th>--><th>Student Type<span style="color:red">*</span></th><th>Application Term<span style="color:red">*</span></th><th>Date Range<span style="color:red">*</span></th><th>Individual Letters</th><th>Group of Letters</th><th>Address Downloads</th></tr>
    <cfoutput query="getLetterDates">
    	<tr><td>#DateFormat(sent_date, "m/dd/yyyy")# #TimeFormat(sent_date, "h:mm tt")#</td><!---<td>#ListGetAt(offer_codes, sent_template_type)#</td>--->
	<td>
		<cfquery dbtype="query" name="getStudentType">
			select * from getStudentTypes where type_id=#student_type#
		</cfquery> <!---#ListGetAt(student_types, student_type)#--->
		<cfif <!---getStudentType.db_id neq "K" and getStudentType.db_id neq "B" and getStudentType.db_id neq "C" and getStudentType.db_id neq "X" and getStudentType.db_id neq "PEP"---> getStudentType.all_semesters eq ""><cfif #getStudentType.semester# eq "08">Fall<cfelseif getStudentType.semester eq "05">Summer<cfelse>Spring</cfif></cfif> #getStudentType.student_type#
	</td>
	<td>#app_term#</td><td>#DateFormat(searchstart_appdate, "m/dd/yyyy")# - #DateFormat(searchend_appdate, "m/dd/yyyy")#</td><td><a href="index.cfm?option=3&pdf_id=#unique_id#">View Letters</a></td><td><a href="index.cfm?option=3&pdfbatches=#sent_template_id#">Print Entire Group of Student and Parent Letters</a><td><a href="downloadAddresses.cfm?pdf=#sent_template_id#">Students</a><br><a href="downloadAddresses.cfm?pdf=#sent_template_id#&parent=true">Parents</a></td></tr>
    </cfoutput> 
    </table> 
    <p><span style="color:red">*</span> - <i>These fields refer to the original search criteria given when generating the letters.</i></p><br><br><br><br>
</cffunction>
<cffunction name="showResidencyParagraphsForm">      
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<h1>Admissions Status Check | Residency Paragraphs</h1>
	<p>Please choose which residency type you would like to change the paragraph for:
	<select name="residency_type" id="residency_type">
		<option <cfif (isDefined("URL.residency_type") and URL.residency_type eq "R") or (isDefined("Form.residency_type") and Form.residency_type eq "R")>selected</cfif> value="R">R</option>
		<option <cfif (isDefined("URL.residency_type") and URL.residency_type eq "Q") or (isDefined("Form.residency_type") and Form.residency_type eq "Q")>selected</cfif> value="Q">Q</option>
		<option <cfif (isDefined("URL.residency_type") and URL.residency_type eq "G") or (isDefined("Form.residency_type") and Form.residency_type eq "G")>selected</cfif> value="G">G</option>
        <option <cfif (isDefined("URL.residency_type") and URL.residency_type eq "N") or (isDefined("Form.residency_type") and Form.residency_type eq "N")>selected</cfif> value="N">N</option>
	</select>
	<input type="button" value="Choose" onclick="document.location='index.cfm?option=2&residency_type='+document.getElementById('residency_type').options[document.getElementById('residency_type').selectedIndex].value"></p>
	<cfif isDefined("URL.residency_type") or isDefined("Form.residency_type")>
		<cfif isDefined("Form.residency_paragraph")>
        	<cfset residency_paragraph=#Replace(Form.residency_paragraph, "<p>", "", "all")#>
			<cfset residency_paragraph=#Replace(residency_paragraph, "</p>", "", "all")#>
			<cfquery name="submitResidencyParagraph" datasource="eAcceptance">
				update residency_extra_info set info_text='#Form.residency_paragraph#' where info_type='paragraph1' and residency_type='#Form.residency_type#' 
			</cfquery>
		</cfif>
		<cfif isDefined("Form.residency_type")><p style="color:red;">Thank you, your paragraph has been submitted!</p></cfif>
		<h2>
		<cfif (isDefined("URL.residency_type") and URL.residency_type eq "R") or (isDefined("Form.residency_type") and Form.residency_type eq "R")>Resident
		<cfelseif (isDefined("URL.residency_type") and URL.residency_type eq "Q") or (isDefined("Form.residency_type") and Form.residency_type eq "Q")>Type Q
		<cfelseif (isDefined("URL.residency_type") and URL.residency_type eq "G") or (isDefined("Form.residency_type") and Form.residency_type eq "G")>Type G
        <cfelseif (isDefined("URL.residency_type") and URL.residency_type eq "N") or (isDefined("Form.residency_type") and Form.residency_type eq "N")>Type N
		</cfif>
		</h2>
		<cfquery name="getResidencyParagraph" datasource="eAcceptance">
			select * from residency_extra_info where info_type='paragraph1' and residency_type='<cfif isDefined("URL.residency_type")>#URL.residency_type#<cfelse>#Form.residency_type#</cfif>'
		</cfquery>
		<cfoutput>
		<form method="post" action="index.cfm">
			<textarea name="residency_paragraph" rows="7" cols="100">#getResidencyParagraph.info_text#</textarea><br><br>
            <script type="text/javascript">
				/*CKEDITOR.replace( 'residency_paragraph',{    
				skin : 'v2',
				toolbar :     
				[        
				['Source','-','Save','NewPage','Preview','-','Templates'],
					['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker'],
					['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens'],
					['TextColor','BGColor']
				],   
				extraPlugins: 'tokens'
				}    
				);*/
				CKEDITOR.replace( 'residency_paragraph', {
					skin : 'moono',
					toolbar: [
						{ name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },	// Defines toolbar group with name (used to create voisdce label) and items in 3 subgroups.
						[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],			// Defines toolbar group without name.
						['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens'],
					['TextColor','BGColor']
					],
					extraPlugins: 'tokens'
				})
			</script>
			<input type="submit" value="Submit">
			<input type="hidden" name="residency_type" value="<cfif isDefined('URL.residency_type')>#URL.residency_type#<cfelseif isDefined('Form.residency_type')>#Form.residency_type#</cfif>">
		</form>
		</cfoutput>
	</cfif>
	<br><br>
</cffunction>
<cffunction name="showNonresidentParagraphForm">      
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<h1>Admissions Status Check | Non-Residency Sentences</h1>
    <p><b>Please note:</b> All of these paragraphs will <b>only</b> appear if a person has a citizenship code of "A"</p>
	<p>Please choose which residency type you would like to change the paragraph for:
	<select name="residency_type" id="residency_type">
		<option <cfif (isDefined("URL.residency_type") and URL.residency_type eq "R") or (isDefined("Form.residency_type") and Form.residency_type eq "R")>selected</cfif> value="R">R</option>
		<option <cfif (isDefined("URL.residency_type") and URL.residency_type eq "Q") or (isDefined("Form.residency_type") and Form.residency_type eq "Q")>selected</cfif> value="Q">Q</option>
		<option <cfif (isDefined("URL.residency_type") and URL.residency_type eq "G") or (isDefined("Form.residency_type") and Form.residency_type eq "G")>selected</cfif> value="G">G</option>
        <option <cfif (isDefined("URL.residency_type") and URL.residency_type eq "N") or (isDefined("Form.residency_type") and Form.residency_type eq "N")>selected</cfif> value="N">N</option>
	</select>
	<input type="button" value="Choose" onclick="document.location='index.cfm?option=2&paragraphtype=nonresident&residency_type='+document.getElementById('residency_type').options[document.getElementById('residency_type').selectedIndex].value"></p>
	<cfif isDefined("URL.residency_type") or isDefined("Form.residency_type")>
		<cfif isDefined("Form.nonresidency_paragraph")>
        	<cfset residency_paragraph=#Replace(Form.nonresidency_paragraph, "<p>", "", "all")#>
			<cfset residency_paragraph=#Replace(residency_paragraph, "</p>", "", "all")#>
			<cfquery name="submitResidencyParagraph" datasource="eAcceptance">
				update residency_extra_info set info_text='#Form.nonresidency_paragraph#' where info_type='paragraph2' and residency_type='#Form.residency_type#' 
			</cfquery>
		</cfif>
		<cfif isDefined("Form.residency_type")><p style="color:red;">Thank you, your paragraph has been submitted!</p></cfif>
		<h2>
		<cfif (isDefined("URL.residency_type") and URL.residency_type eq "R") or (isDefined("Form.residency_type") and Form.residency_type eq "R")>Resident
		<cfelseif (isDefined("URL.residency_type") and URL.residency_type eq "Q") or (isDefined("Form.residency_type") and Form.residency_type eq "Q")>Type Q
		<cfelseif (isDefined("URL.residency_type") and URL.residency_type eq "G") or (isDefined("Form.residency_type") and Form.residency_type eq "G")>Type G
        <cfelseif (isDefined("URL.residency_type") and URL.residency_type eq "N") or (isDefined("Form.residency_type") and Form.residency_type eq "N")>Type N
		</cfif>
		</h2>
		<cfquery name="getResidencyParagraph" datasource="eAcceptance">
			select * from residency_extra_info where info_type='paragraph2' and residency_type='<cfif isDefined("URL.residency_type")>#URL.residency_type#<cfelse>#Form.residency_type#</cfif>'
		</cfquery>
		<cfoutput>
		<form method="post" action="index.cfm">
			<textarea name="nonresidency_paragraph" rows="7" cols="100">#getResidencyParagraph.info_text#</textarea><br><br>
            <script type="text/javascript">
				/*CKEDITOR.replace( 'nonresidency_paragraph',{    
				skin : 'v2',
				toolbar :     
				[        
				['Source','-','Save','NewPage','Preview','-','Templates'],
					['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker'],
					['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens'],
					['TextColor','BGColor']
				],   
				extraPlugins: 'tokens'
				}    
				);*/
				CKEDITOR.replace( 'nonresidency_paragraph', {
					skin : 'moono',
					toolbar: [
						{ name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },	// Defines toolbar group with name (used to create voisdce label) and items in 3 subgroups.
						[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],			// Defines toolbar group without name.
						['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens'],
					['TextColor','BGColor']
					],
					extraPlugins: 'tokens'
				})
			</script>
			<input type="submit" value="Submit">
			<input type="hidden" name="residency_type" value="<cfif isDefined('URL.residency_type')>#URL.residency_type#<cfelseif isDefined('Form.residency_type')>#Form.residency_type#</cfif>">
		</form>
		</cfoutput>
	</cfif>
	<br><br>
</cffunction>





<cffunction name="showStatusExplanationForm">      
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<h1>Admissions Status Check | Status Explanations</h1>
	<p>Please choose which decision code you would like to change the paragraph for:
	<cfquery name="getStatuses" datasource="eAcceptance">
		select * from status_explanations order by status_code
	</cfquery>
	<select name="status_code" id="status_code">
		<cfoutput query="getStatuses">
			<option <cfif (isDefined("URL.status_code") and URL.status_code eq "#status_code#") or (isDefined("Form.status_code") and Form.status_code eq "#status_code#")>selected</cfif> value="#status_code#">#status_code#</option>
			<!---<option <cfif (isDefined("URL.status_code") and URL.status_code eq "A") or (isDefined("Form.status_code") and Form.status_code eq "A")>selected</cfif> value="R">R</option>
			<option <cfif (isDefined("URL.status_code") and URL.status_code eq "Q") or (isDefined("Form.status_code") and Form.status_code eq "Q")>selected</cfif> value="Q">Q</option>
			<option <cfif (isDefined("URL.status_code") and URL.status_code eq "G") or (isDefined("Form.status_code") and Form.status_code eq "G")>selected</cfif> value="G">G</option>
			<option <cfif (isDefined("URL.status_code") and URL.status_code eq "N") or (isDefined("Form.status_code") and Form.status_code eq "N")>selected</cfif> value="N">N</option>--->
		</cfoutput>
	</select>
	<input type="button" value="Choose" onclick="document.location='index.cfm?option=2&paragraphtype=statusexplanation&status_code='+document.getElementById('status_code').options[document.getElementById('status_code').selectedIndex].value"></p>
	<cfif isDefined("URL.status_code") or isDefined("Form.status_code")>
		<cfif isDefined("Form.statuscode_explanation")>
			<!---<cfset residency_paragraph=#Replace(Form.nonresidency_paragraph, "<p>", "", "all")#>
			<cfset residency_paragraph=#Replace(residency_paragraph, "</p>", "", "all")#>--->
			<cfquery name="submitStatusExplanation" datasource="eAcceptance">
				update status_explanations set info_text='#Form.statuscode_explanation#' where status_code='#Form.status_code#' 
			</cfquery>
		</cfif><!---<cfoutput>update status_explanations set info_text='#Form.statuscode_explanation#' where status_code='#Form.status_code#' </cfoutput>--->
		<cfif isDefined("Form.status_code")><p style="color:red;">Thank you, your paragraph has been submitted!</p></cfif>
		<h2>
		<cfif isDefined("URL.status_code")><cfset tempstatuscode=URL.status_code>
		<cfelseif isDefined("Form.status_code")><cfset tempstatuscode=Form.status_code>
		<cfelse><cfset tempstatuscode="">
		</cfif>
		<cfquery name="getStatus" dbtype="query">
			select * from getStatuses where status_code='#tempstatuscode#'
		</cfquery>
		<!---<cfif (isDefined("URL.status_code") and URL.status_code eq "A") or (isDefined("Form.status_code") and Form.status_code eq "A")>Accept
		<cfelseif (isDefined("URL.status_code") and URL.status_code eq "D") or (isDefined("Form.status_code") and Form.status_code eq "D")>Deny
		<cfelseif (isDefined("URL.status_code") and URL.status_code eq "G") or (isDefined("Form.status_code") and Form.status_code eq "G")>Type G
		<cfelseif (isDefined("URL.status_code") and URL.status_code eq "N") or (isDefined("Form.status_code") and Form.status_code eq "N")>Type N
		</cfif>--->
		<cfoutput>#getStatus.info_title#</cfoutput>
		</h2>
		<cfquery name="getStatusCode" datasource="eAcceptance">
			select * from status_explanations where status_code='<cfif isDefined("URL.status_code")>#URL.status_code#<cfelse>#Form.status_code#</cfif>'
		</cfquery>
		<cfoutput>
		<form method="post" action="index.cfm">
			<textarea name="statuscode_explanation" rows="7" cols="100">#getStatusCode.info_text#</textarea><br><br>
            <script type="text/javascript">
				/*CKEDITOR.replace( 'statuscode_explanation',{    
				skin : 'v2',
				toolbar :     
				[        
				['Source','-','Save','NewPage','Preview','-','Templates'],
					['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker'],
					['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens'],
					['TextColor','BGColor']
				],   
				extraPlugins: 'tokens'
				}    
				);*/
				CKEDITOR.replace( 'statuscode_explanation', {
					skin : 'moono',
					toolbar: [
						{ name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },	// Defines toolbar group with name (used to create voisdce label) and items in 3 subgroups.
						[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],			// Defines toolbar group without name.
						['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens'],
					['TextColor','BGColor']
					],
					extraPlugins: 'tokens_statusexplanations'
				})
			</script>
			<input type="submit" value="Submit">
			<input type="hidden" name="status_code" value="<cfif isDefined('URL.status_code')>#URL.status_code#<cfelseif isDefined('Form.status_code')>#Form.status_code#</cfif>">
		</form>
		</cfoutput>
	</cfif>
	<br><br>
</cffunction>


<cffunction name="showWelcomeCenterForm">      
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<h1>Admissions Status Check | WelcomeCenterEvents</h1>
	<p>Please choose which student type you would like to change the paragraph for:
	<select name="welcomecenter_studenttype" id="welcomecenter_studenttype">
			<option <cfif (isDefined("URL.welcomecenter_studenttype") and URL.welcomecenter_studenttype eq "others") or (isDefined("Form.welcomecenter_studenttype") and Form.welcomecenter_studenttype eq "others")>selected</cfif> value="others">Regular Freshmen</option>
			<option <cfif (isDefined("URL.welcomecenter_studenttype") and URL.welcomecenter_studenttype eq "41") or (isDefined("Form.welcomecenter_studenttype") and Form.welcomecenter_studenttype eq "41")>selected</cfif> value="41">Honors Students</option>
			<option <cfif (isDefined("URL.welcomecenter_studenttype") and URL.welcomecenter_studenttype eq "10") or (isDefined("Form.welcomecenter_studenttype") and Form.welcomecenter_studenttype eq "10")>selected</cfif> value="10">Success Academy Students</option>
	</select>
	<input type="button" value="Choose" onclick="document.location='index.cfm?option=2&paragraphtype=welcomecenterevents&welcomecenter_studenttype='+document.getElementById('welcomecenter_studenttype').options[document.getElementById('welcomecenter_studenttype').selectedIndex].value"></p>
	<cfif isDefined("URL.welcomecenter_studenttype") or isDefined("Form.welcomecenter_studenttype")>
		<cfif isDefined("Form.welcomecenter_explanation")>
			<!---<cfset residency_paragraph=#Replace(Form.nonresidency_paragraph, "<p>", "", "all")#>
			<cfset residency_paragraph=#Replace(residency_paragraph, "</p>", "", "all")#>--->
			<cfquery name="submitStatusExplanation" datasource="eAcceptance">
				update custom_paragraphs set paragraph_text='#Form.welcomecenter_explanation#' where paragraph_type='admitted_freshmen' and student_type<cfif Form.welcomecenter_studenttype eq "" or Form.welcomecenter_studenttype eq "others"> is null<cfelse>='#Form.welcomecenter_studenttype#'</cfif> 
			</cfquery>
		</cfif><!---<cfoutput>update status_explanations set info_text='#Form.statuscode_explanation#' where status_code='#Form.status_code#' </cfoutput>--->
		<cfif isDefined("Form.welcomecenter_studenttype")><p style="color:red;">Thank you, your paragraph has been submitted!</p></cfif>
		<h2>
		<cfif isDefined("URL.welcomecenter_studenttype")><cfset tempstatuscode=URL.welcomecenter_studenttype>
		<cfelseif isDefined("Form.welcomecenter_studenttype")><cfset tempstatuscode=Form.welcomecenter_studenttype>
		<cfelse><cfset tempstatuscode="">
		</cfif>
		<cfif isDefined("URL.welcomecenter_studenttype")>
			<cfset WCstudentType=URL.welcomecenter_studenttype>
		<cfelse>
			<cfset WCstudentType=Form.welcomecenter_studenttype>
		</cfif>
		<cfif WCstudentType  eq "others">
			<cfset WCStudentTypeDesc="Regular Students">
		<cfelse>
			<cfquery name="getWelcomeCenterStudentType" datasource="eAcceptance">
				select * from student_types where type_id=#WCstudentType#
			</cfquery>
			<cfset WCStudentTypeDesc="#getWelcomeCenterStudentType.student_type#">
		</cfif>
		<cfoutput>#WCStudentTypeDesc#</cfoutput>
		</h2>
		<cfoutput>
		<form method="post" action="index.cfm">
			<cfif WCstudentType eq "others">
				<cfset WCstudent_type="">
			<cfelse>
				<cfset WCstudent_type=#WCstudentType#>
			</cfif>
			<cfquery name="getWCText" datasource="eAcceptance">
				select * from custom_paragraphs where paragraph_type='admitted_freshmen' and student_type<cfif WCstudent_type eq ""> is null<cfelse>='#WCstudent_type#'</cfif>
			</cfquery>
			<textarea name="welcomecenter_explanation" rows="7" cols="100">#getWCText.paragraph_text#</textarea><br><br>
            <script type="text/javascript">
				CKEDITOR.replace( 'welcomecenter_explanation', {
					skin : 'moono',
					toolbar: [
						{ name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },	// Defines toolbar group with name (used to create voisdce label) and items in 3 subgroups.
						[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],			// Defines toolbar group without name.
						['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens'],
					['TextColor','BGColor']
					]
				})
			</script>
			<input type="submit" value="Submit">
			<input type="hidden" name="welcomecenter_studenttype" value="#WCstudentType#">
		</form>
		</cfoutput>
	</cfif>
	<br><br>
</cffunction>

<cffunction name="showScholCustomParForm">      
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<h1>Admissions Status Check | Scholarships</h1>
	<p>Please choose which student type you would like to change the scholarship terms for:
	<select name="scholarship_studenttype" id="scholarship_studenttype">
			<option <cfif (isDefined("URL.scholarship_studenttype") and URL.scholarship_studenttype eq "T") or (isDefined("Form.scholarship_studenttype") and Form.scholarship_studenttype eq "T")>selected</cfif> value="T">Transfer</option>
			<option <cfif (isDefined("URL.scholarship_studenttype") and URL.scholarship_studenttype eq "F") or (isDefined("Form.scholarship_studenttype") and Form.scholarship_studenttype eq "F")>selected</cfif> value="F">Regular Freshmen</option>
	</select>
	<input type="button" value="Choose" onclick="document.location='index.cfm?option=2&paragraphtype=scholarshipTerms&scholarship_studenttype='+document.getElementById('scholarship_studenttype').options[document.getElementById('scholarship_studenttype').selectedIndex].value"></p>
	<cfif isDefined("URL.scholarship_studenttype") or isDefined("Form.scholarship_studenttype")>
		<cfif isDefined("Form.scholCustPara_explanation")>
			<!---<cfset residency_paragraph=#Replace(Form.nonresidency_paragraph, "<p>", "", "all")#>
			<cfset residency_paragraph=#Replace(residency_paragraph, "</p>", "", "all")#>--->
			<cfquery name="submitStatusExplanation" datasource="eAcceptance">
				update custom_paragraphs set paragraph_text='#Form.scholCustPara_explanation#' where paragraph_type='scholarship_terms' and student_type<cfif Form.scholarship_studenttype eq "" or Form.scholarship_studenttype eq "others"> is null<cfelse>='#Form.scholarship_studenttype#'</cfif> 
			</cfquery>
		</cfif><!---<cfoutput>update custom_paragraphs set paragraph_text='#Form.scholCustPara_explanation#' where paragraph_type='admitted_freshmen' and student_type<cfif Form.scholarship_studenttype eq "" or Form.scholarship_studenttype eq "others"> is null<cfelse>='#Form.scholarship_studenttype#'</cfif> </cfoutput>--->
		<cfif isDefined("Form.scholarship_studenttype")><p style="color:red;">Thank you, your paragraph has been submitted!</p></cfif>
		<h2>
		<cfif isDefined("URL.scholarship_studenttype")><cfset tempstatuscode=URL.scholarship_studenttype>
		<cfelseif isDefined("Form.scholarship_studenttype")><cfset tempstatuscode=Form.scholarship_studenttype>
		<cfelse><cfset tempstatuscode="">
		</cfif>
		<cfif isDefined("URL.scholarship_studenttype")>
			<cfset SPstudentType=URL.scholarship_studenttype>
		<cfelse>
			<cfset SPstudentType=Form.scholarship_studenttype>
		</cfif>
		<cfif SPstudentType  eq "others">
			<cfset SPStudentTypeDesc="Regular Students">
		<cfelse>
			<cfquery name="getScholStudentType" datasource="eAcceptance">
				select * from student_types where db_id='#SPstudentType#'
			</cfquery>
			<cfset SPstudentTypeDesc="#getScholStudentType.student_type#">
		</cfif>
		<cfoutput>#SPstudentTypeDesc#</cfoutput>
		</h2>
		<cfoutput>
		<form method="post" action="index.cfm">
			<cfif SPstudentType eq "others">
				<cfset SPstudent_type="">
			<cfelse>
				<cfset SPstudent_type=#SPstudentType#>
			</cfif>
			<cfquery name="getSPText" datasource="eAcceptance">
				select * from custom_paragraphs where paragraph_type='scholarship_terms' and student_type<cfif SPstudent_type eq ""> is null<cfelse>='#SPstudent_type#'</cfif>
			</cfquery>
			<textarea name="scholCustPara_explanation" rows="7" cols="100">#getSPText.paragraph_text#</textarea><br><br>
            <script type="text/javascript">
				CKEDITOR.replace( 'scholCustPara_explanation', {
					skin : 'moono',
					toolbar: [
						{ name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },	// Defines toolbar group with name (used to create voisdce label) and items in 3 subgroups.
						[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],			// Defines toolbar group without name.
						['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens'],
					['TextColor','BGColor']
					]
				})
			</script>
			<input type="submit" value="Submit">
			<input type="hidden" name="scholarship_studenttype" value="#SPstudentType#">
		</form>
		</cfoutput>
	</cfif>
	<br><br>
</cffunction>

<cffunction name="showNonresidentParagraphForm2">  
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<h1>Admissions Status Check | Non-Residency Sentences</h1>
    <p><b>Please note:</b> This sentence will <b>only</b> appear if a person has a citizenship code of "A"</p>
		<cfif isDefined("Form.nonresidency_paragraph2")>
        	<cfset residency_paragraph=#Replace(Form.nonresidency_paragraph2, "<p>", "", "all")#>
			<cfset residency_paragraph=#Replace(residency_paragraph, "</p>", "", "all")#>
			<cfquery name="submitResidencyParagraph" datasource="eAcceptance">
				update residency_extra_info set info_text='#Form.nonresidency_paragraph2#' where info_type='paragraph3'
			</cfquery>
		</cfif>
		<cfif isDefined("Form.nonresidency_paragraph2")><p style="color:red;">Thank you, your paragraph has been submitted!</p></cfif>
		<cfquery name="getResidencyParagraph" datasource="eAcceptance">
			select * from residency_extra_info where info_type='paragraph3'
		</cfquery>
		<cfoutput>
		<form method="post" action="index.cfm">
			<textarea name="nonresidency_paragraph2" rows="7" cols="100">#getResidencyParagraph.info_text#</textarea><br><br>
            <script type="text/javascript">
				/*CKEDITOR.replace( 'nonresidency_paragraph2',{    
				skin : 'v2',
				toolbar :     
				[        
				['Source','-','Save','NewPage','Preview','-','Templates'],
					['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker'],
					['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens'],
					['TextColor','BGColor']
				],   
				extraPlugins: 'tokens'
				}    

				);*/
				CKEDITOR.replace( 'nonresidency_paragraph2', {
					skin : 'moono',
					toolbar: [
						{ name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },	// Defines toolbar group with name (used to create voisdce label) and items in 3 subgroups.
						[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],			// Defines toolbar group without name.
						['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens'],
					['TextColor','BGColor']
					],
					extraPlugins: 'tokens'
				})
			</script>
			<input type="submit" value="Submit">
			<input type="hidden" name="residency_type" value="<cfif isDefined('URL.residency_type')>#URL.residency_type#<cfelseif isDefined('Form.residency_type')>#Form.residency_type#</cfif>">
		</form>
		</cfoutput>
	<br><br>
</cffunction>
<cffunction name="replaceFields">
<cfargument name="original_text">
<cfargument name="res_paragraph">
<cfargument name="nonres_sentence1">
<cfargument name="nonres_sentence2">
<!---<cfargument name="nursing_paragraph">
<cfargument name="music_paragraph">
<cfargument name="music_management_paragraph">
<cfargument name="int_studies_paragraph">--->
<cfargument name="studentset">
<cfargument name="studentsetrow">
<cfargument name="justaddresses" default="">











		<cfset final_text=Replace('#original_text#', '&nbsp;', '', 'all')>
	  <cfif justaddresses eq "">
      	  <cfif cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "glacierqa.gsu.edu">
		  	<cfset final_text=Replace('#final_text#', '<img src="/applicantstatus/admin/images/scott_sig.gif" />', '<img src="file:///d:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', 'ALL')>
          <cfelse>
          	<cfset final_text=Replace('#final_text#', '<img src="/applicantstatus/admin/images/scott_sig.gif" />', '<img src="file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', 'ALL')>
          </cfif>
		  <cfset final_text=ReReplace("#final_text#",'<p>\s+<span contenteditable="false">\[RESIDENCY PARAGRAPH\]</span></p>',"#res_paragraph#","ALL")>
          <cfset final_text=Replace('#final_text#', '<span contenteditable="false">[RESIDENCY PARAGRAPH]</span>', '#res_paragraph#', 'all')>
          
          <cfset final_text=ReReplace("#final_text#",'<p>\s+<span contenteditable="false">\[NON-RESIDENT SENTENCE1\]</span></p>',"#nonres_sentence1#","ALL")>
          <cfset final_text=Replace('#final_text#', '<span contenteditable="false">[NON-RESIDENT SENTENCE1]</span>', '#nonres_sentence1#', 'all')>
          
          <cfset final_text=ReReplace("#final_text#",'<p>\s+<span contenteditable="false">\[NON-RESIDENT SENTENCE2\]</span></p>',"#nonres_sentence2#","ALL")>
          <cfset final_text=Replace('#final_text#', '<span contenteditable="false">[NON-RESIDENT SENTENCE2]</span>', '#nonres_sentence2#', 'all')>
	  
	  <!---BIS_IDS STATEMENT (NOT IN EXCEL FILE UNTIL I GET ACCESS TO CONCENTRATIONS
	  <cfif studentset["PROGRAM1"][studentsetrow] eq "BIS_IDS">
		<cfset temp_dept="">
		<cfif studentset["APP_DEPT_CODE"][studentsetrow] eq "DONS"><cfset temp_dept="Byrdine F. Lewis School of Nursing and Health Professions">
			<cfelseif studentset["APP_DEPT_CODE"][studentsetrow] eq "DOED"><cfset temp_dept="College of Education">
			<cfelse><cfset temp_dept="">
		</cfif>
		<cfset bis_stmt = "Admission ">
		<cfif temp_dept neq ""><cfset bis_stmt=bis_stmt & "into the #temp_dept# "></cfif>
		<cfset bis_stmt=bis_stmt&"to pursue your major is pending your acceptance to their program.">
		<cfset final_text=Replace('#final_text#', '[STMT_BISIDS]', '#bis_stmt#', 'all')>
	<cfelse>
		<cfset final_text=Replace('#final_text#', '[STMT_BISIDS]', '', 'all')>
	  </cfif>--->
	  <cfset final_text=Replace('#final_text#', '[STMT_BISIDS]', '', 'all')>
	  <!---END OF BIS_IDS STATEMENT--->
          
            <!---<cfset myStruct=StructNew()>
            <cfset myStruct.HSBSN_PNUR="NURSING PARAGRAPH">
            <cfset myStruct.ASBMU_MUS="MUSIC PARAGRAPH">
            <cfset myStruct.ASBS_MMI="MUSIC MANAGEMENT PARAGRAPH">
            <cfset myStruct.ASBIS_IDS="INT STUDIES PARAGRAPH">--->
            <!---<cfdump var=#myStruct#><br>
            <cfoutput>#mystruct["HSBSN_PNUR"]#<br></cfoutput>--->
    		<cfquery name="getCustomParagraphs" datasource="eAcceptance">
            	select * from degree_custom_paragraphs
            </cfquery>
            <cfloop query="getCustomParagraphs">
            	<!---<cfoutput>#studentset[banner_field][studentsetrow]# -> #banner_value#</cfoutput><br><br>--->
                <cfif studentset[#trim(banner_field)#][studentsetrow] eq "#trim(banner_value)#">
                    <cfset final_text=Replace('#final_text#', '[#banner_value# PARAGRAPH]', '#paragraph_text#', "all")>
                </cfif>
            </cfloop>      
            <!---CLEAN UP--->
            	<cfloop query="getCustomParagraphs">
                    <!---would really like to do this: <cfset final_text=ReReplace("#final_text#" ,'<br />(\s+)<br />(\s+)<span contenteditable="false">\[NURSING PARAGRAPH\]</span>',"","ALL")>--->
                    <cfset final_text=ReReplace("#final_text#",'<p>\s+<span contenteditable="false">\[#banner_value# PARAGRAPH\]</span></p>'," ","ALL")>
                    <cfset final_text=ReReplace("#final_text#" ,'<br />\s+(\S|&nbsp;)<br />\s+<span contenteditable="false">\[#banner_value# PARAGRAPH\]</span>',"","ALL")>
                    <cfset final_text=ReReplace("#final_text#" ,'<br />(\s+)<span contenteditable="false">\[#banner_value# PARAGRAPH\]</span>',"","ALL")>
                    <cfset final_text=Replace('#final_text#', '<span contenteditable="false">[#banner_value# PARAGRAPH]</span>', '', "all")>
                    <cfset final_text=Replace('#final_text#', '[#banner_value# PARAGRAPH]', '', "all")>
                </cfloop>
            <cfset final_text=Replace('#final_text#', '[DATE]', '#DateFormat(NOW(), "mmmm d, yyyy")#', 'all')>
        </cfif>
        <cfset final_text=Replace('#final_text#', '[STUDENT NAME]', '#studentset["name_prefix"][studentsetrow]# #studentset["first_name"][studentsetrow]# #studentset["mi"][studentsetrow]# #studentset["last_name"][studentsetrow]# #studentset["name_suffix"][studentsetrow]#', "all")>
        <cfset address1=#studentset["street_line1"][studentsetrow]#>
        <cfif studentset["street_line2"][studentsetrow] neq ""><cfset address1=address1&"<br>#studentset["street_line2"][studentsetrow]#"></cfif>
        <cfif studentset["street_line3"][studentsetrow] neq ""><cfset address1=address1&"<br>#studentset["street_line3"][studentsetrow]#"></cfif>
        <cfset final_text=Replace('#final_text#', '[ADDRESS 1]', '#address1#', "all")>
        <cfset final_text=Replace('#final_text#', '[ADDRESS 2]', '#studentset["city"][studentsetrow]#, #studentset["state"][studentsetrow]# &nbsp;#studentset["zip"][studentsetrow]#', "all")>
	<cfset final_text=Replace('#final_text#', '[CITY]', '#studentset["city"][studentsetrow]#', "all")>
	<cfset final_text=Replace('#final_text#', '[STATE]', '#studentset["state"][studentsetrow]#', "all")>
	<cfset final_text=Replace('#final_text#', '[ZIP CODE]', '#studentset["zip"][studentsetrow]#', "all")>
	<cfif cgi.server_name eq "istcfdev.gsu.edu">
		<cfset sigpath="D:\inetpub\cf-dev\applicantstatus\admin\images\scott_sig.gif">
		<cfset sigpath2="D:\inetpub\cf-dev\applicantstatus\admin\images\dean_berman_sig.jpg">
	<cfelseif cgi.server_name eq "istcfqa.gsu.edu">
		<cfset sigpath="D:\inetpub\cf-qa\applicantstatus\admin\images\scott_sig.gif">
		<cfset sigpath2="D:\inetpub\cf-qa\applicantstatus\admin\images\dean_berman_sig.jpg">
	<cfelse>
		<cfset sigpath="D:\inetpub\applicantstatus\admin\images\scott_sig.gif">
		<cfset sigpath2="D:\inetpub\applicantstatus\admin\images\dean_berman_sig.jpg">
	</cfif>
	<cfset final_text=Replace('#final_text#', '[SCOTT SIGNATURE]', '<img src="file:///#sigpath#" />', 'ALL')>
	<cfset final_text=Replace('#final_text#', '[DR BERMAN SIGNATURE]', '<img src="file:///#sigpath2#" />', 'ALL')>
        <cfif justaddresses eq "">
        	<!---the below if statement must be done because the banner college field has a 30-character limit.  It also can't just do a global replace of "School of Nursing" because that phrase is in the Byrdine name. --->
        	<cfif studentset["APP_COLL_CODE_1_DESC"][studentsetrow] eq "School of Nursing">
            	<cfset final_text=Replace('#final_text#', '[COLLEGE]', 'Byrdine F. Lewis School of Nursing and Health Professions', 'all')>
            <cfelse>
				<cfset final_text=Replace('#final_text#', '[COLLEGE]', '#studentset["APP_COLL_CODE_1_DESC"][studentsetrow]#', 'all')>
            </cfif>
            <cfset final_text=Replace('#final_text#', '[MAJOR]', '#studentset["APP_MAJR_CODE_1"][studentsetrow]#', 'all')>
            <!---<cfif #studentset["APP_DEPT_CODE_DESC"][studentsetrow]# eq "">
            	<cfset final_text=Replace('#final_text#', 'to the [DEPARTMENT]', '', 'all')>
            <cfelse>
            	<cfset final_text=Replace('#final_text#', '[DEPARTMENT]', '#studentset["APP_DEPT_CODE_DESC"][studentsetrow]#', 'all')>
            </cfif>--->
            <cfset final_text=Replace('#final_text#', '[DEPARTMENT]', '#studentset["APP_DEPT_CODE_DESC"][studentsetrow]#', 'all')>
            <cfset final_text=Replace('#final_text#', '[PANTHER NUMBER]', '#studentset["STUDENT_ID"][studentsetrow]#', 'all')>
            <cfset appyear=Left(#studentset["APP_TERM_CODE"][studentsetrow]#, 4)>
            <cfset appsem=Right(#studentset["APP_TERM_CODE"][studentsetrow]#, 2)>
            <cfif appsem eq "01"><cfset appsemester="Spring">
            <cfelseif appsem eq "05"><cfset appsemester="Summer">
            <cfelseif appsem eq "08"><cfset appsemester="Fall">
            <cfelse><cfset appsemester="">
            </cfif>
	    <cfset final_text=Replace('#final_text#', '<span contenteditable="false">[APPLICATION TERM]</span>', ' #appsemester# #appyear#', 'all')>
            <cfset final_text=Replace('#final_text#', '[APPLICATION TERM]', '#appsemester# #appyear#', 'all')>
            <!---<cfset final_text=Replace('#final_text#', '<p>', '', "all")>
            <cfset final_text=Replace('#final_text#', '</p>', '', "all")>--->
            <cfset final_text=Replace('#final_text#', '<span contenteditable="false"><p>', ' ', 'all')>
        <cfset final_text=Replace("#final_text#", '<span contenteditable="false"><br><p>', ' ', "ALL")>
          <cfset final_text=ReReplace("#final_text#", '</p>\s+</span></p>', '</p>', 'all')>
          <cfset final_text=Replace("#final_text#", '</p><br><p>', '</p><p>', 'all')>
          <!---this must be done because the banner college field has a 30-character limit.  It also can't just replace "School of Nursing" because that phrase is in the Byrdine name.  So I have to let it know that it starts with School of Nursing by giving it the start span tag.
           <cfset final_text=Replace("#final_text#", '<span contenteditable="false">School of Nursing', '<span contenteditable="false">Byrdine F. Lewis School of Nursing and Health Professions', 'all')>--->
         </cfif>
    <cfreturn final_text>  
</cffunction>
<cffunction name="replaceParentFields">
<cfargument name="original_text">
<cfargument name="letter_info">
<cfargument name="lettersetrow">
<cfargument name="justaddresses" default="">


	<cfset final_text=Replace('#original_text#', '&nbsp;', '', 'all')>
	  <cfif justaddresses eq "">
      	  <cfif cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "glacierqa.gsu.edu">
		  	<cfset final_text=Replace('#final_text#', '<img src="/applicantstatus/admin/images/scott_sig.gif" />', '<img src="file:///d:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', 'ALL')>
          <cfelse>
          	<cfset final_text=Replace('#final_text#', '<img src="/applicantstatus/admin/images/scott_sig.gif" />', '<img src="file:///c:\inetpub\wwwroot\applicantstatus\admin\images\scott_sig.gif" />', 'ALL')>
          </cfif>
            <cfset final_text=Replace('#final_text#', '[DATE]', '#DateFormat(NOW(), "mmmm d, yyyy")#', 'all')>
        </cfif>
        <cfset final_text=Replace('#final_text#', '[STUDENT NAME]', 'Parent(s) of #letter_info["student_fname"][lettersetrow]# #letter_info["student_mi"][lettersetrow]# #letter_info["student_lname"][lettersetrow]#', "all")>
	<cftry>
        <cfstoredproc procedure="wwokbapi.f_get_addr" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#NumberFormat(letter_info["student_id"][lettersetrow], "000000009")#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="address_type" type="in" value="MA"> 
			<cfprocresult name="out_result_set">
		</cfstoredproc>
	
	<cfset address1=out_result_set.STREET_LINE1>
		<cfif out_result_set.street_line2 neq ""><cfset address1=address1&"<br>"&#out_result_set.street_line2#></cfif>
		<cfif out_result_set.street_line3 neq ""><cfset address1=address1&"<br>"&#out_result_set.street_line3#></cfif>
        <cfset final_text=Replace('#final_text#', '[ADDRESS 1]', '#address1#', "all")>
        <cfset final_text=Replace('#final_text#', '[ADDRESS 2]', '#out_result_set.CITY#, #out_result_set.STATE# &nbsp;#out_result_set.ZIP#', "all")>
        <!---<cfif justaddresses eq "">
        	<cfif studentset["APP_COLL_CODE_1_DESC"][studentsetrow] eq "School of Nursing">
            	<cfset final_text=Replace('#final_text#', '[COLLEGE]', 'Byrdine F. Lewis School of Nursing and Health Professions', 'all')>
            <cfelse>
				<cfset final_text=Replace('#final_text#', '[COLLEGE]', '#studentset["APP_COLL_CODE_1_DESC"][studentsetrow]#', 'all')>
            </cfif>
            <cfset final_text=Replace('#final_text#', '[MAJOR]', '#studentset["APP_MAJR_CODE_1"][studentsetrow]#', 'all')>
            <cfset final_text=Replace('#final_text#', '[DEPARTMENT]', '#studentset["APP_DEPT_CODE_DESC"][studentsetrow]#', 'all')>
            <cfset final_text=Replace('#final_text#', '[PANTHER NUMBER]', '#studentset["STUDENT_ID"][studentsetrow]#', 'all')>
            <cfset appyear=Left(#studentset["APP_TERM_CODE"][studentsetrow]#, 4)>
            <cfset appsem=Right(#studentset["APP_TERM_CODE"][studentsetrow]#, 2)>
            <cfif appsem eq "01"><cfset appsemester="Spring">
            <cfelseif appsem eq "05"><cfset appsemester="Summer">
            <cfelseif appsem eq "08"><cfset appsemester="Fall">
            <cfelse><cfset appsemester="">
            </cfif>
            <cfset final_text=Replace('#final_text#', '[APPLICATION TERM]', '&nbsp; #appsemester# #appyear# ', 'all')>
            <cfset final_text=Replace('#final_text#', '<span contenteditable="false"><p>', ' ', 'all')>
        <cfset final_text=Replace("#final_text#", '<span contenteditable="false"><br><p>', ' ', "ALL")>
          <cfset final_text=ReReplace("#final_text#", '</p>\s+</span></p>', '</p>', 'all')>
          <cfset final_text=Replace("#final_text#", '</p><br><p>', '</p><p>', 'all')>
         </cfif>--->
	 <cfcatch><cfoutput>#cfcatch.detail#</cfoutput></cfcatch>
	</cftry>
    <cfreturn final_text>  
</cffunction>  
<cffunction name="showCustomParagraphForm">
<cfargument name="paragraphtype">
	<cfoutput>
     <cfif paragraphtype eq "musicmanag">
		<cfset displaytype="Music Management">
    <cfelseif paragraphtype eq "intstudies">
        <cfset displaytype="Interdisciplinary Studies">
    <cfelse>
        <cfset displaytype="#UCase(left(paragraphtype,1))##Right(paragraphtype,Len(paragraphtype)-1)#">
    </cfif>
	<cfif isDefined("Form.custom_paragraph")>
    	<cfset pText=Replace(Form.custom_paragraph, "<p>", "", "all")>
        <cfset pText=Replace(Form.custom_paragraph, "</p>", "", "all")>
    	<cfquery name="updateCustomParagraph" datasource="eAcceptance">
        	update custom_paragraphs set paragraph_text='#Form.custom_paragraph#' where paragraph_type='#paragraphtype#'
        </cfquery>
        <h3 style="color:red;">Thank you, the #displaytype# paragraph has been updated!</h3>
    </cfif>
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<cfquery name="getParagraphInfo" datasource="eAcceptance">
    	select * from custom_paragraphs where paragraph_type='#paragraphtype#'
    </cfquery>
	<h1>Admissions Status Check | #displaytype# <cfif displaytype eq "scholarship">Page<cfelse>Paragraph</cfif></h1>
    <cfif displaytype eq "scholarship">
    	<cfset tokentype="tokens_scholletter">
    <cfelse>
    	<cfset tokentype="tokens">
    </cfif>
    <form method="post" action="index.cfm">
        <textarea name="custom_paragraph" rows="7" cols="100">#getParagraphInfo.paragraph_text#</textarea><br><br>
        <script type="text/javascript">
            /*CKEDITOR.replace( 'custom_paragraph',{    
            skin : 'v2',
            toolbar :     
            [        
            ['Source','-','Save','NewPage','Preview','-','Templates'],
                ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker'],
                ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
                '/',
                ['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
                ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
                ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
                ['BidiLtr', 'BidiRtl' ],
                ['Link','Unlink','Anchor'],
                ['Image','HorizontalRule','SpecialChar','PageBreak'],
                ['Styles','Format','Font','FontSize','tokens_scholletter'],
                ['TextColor','BGColor']
            ],   
            extraPlugins: 'tokens_scholletter'
            }    
            );*/
	    CKEDITOR.replace( 'custom_paragraph', {
		skin : 'moono',
		toolbar: [
			{ name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },	// Defines toolbar group with name (used to create voisdce label) and items in 3 subgroups.
			[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],			// Defines toolbar group without name.
			['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
		'/',
		['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
		['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
		['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
		['BidiLtr', 'BidiRtl' ],
		['Link','Unlink','Anchor'],
		['Image','HorizontalRule','SpecialChar','PageBreak'],
		['Styles','Format','Font','FontSize','tokens_scholletter'],
		['TextColor','BGColor']
		],
		extraPlugins: 'tokens_scholletter'
	})
        </script>
        <input type="submit" value="Submit">
        <input type="hidden" name="customparagraphtype" value="#paragraphtype#">
        <input type="hidden" name="option" value="#Session.option#">
    </form>
	</cfoutput>
</cffunction>
<cffunction name="editScholarshipForms">
<cfargument name="paragraphtype">
	<cfif isDefined("URL.paragraphtype")>
    	<cfset paragraphtype=URL.paragraphtype>
		<cfif URL.paragraphtype eq 2><cfset displaytype="Scholarship Rules"><cfelseif URL.paragraphtype eq 3><cfset displaytype="Out-of-State Tuition Form"><cfelseif URL.paragraphtype eq 1><cfset displaytype="Acceptance Form"></cfif>
    <cfelseif isDefined("Form.paragraphtype")>
    	<cfset paragraphtype=Form.paragraphtype>
    	<cfif Form.paragraphtype eq 2><cfset displaytype="Scholarship Rules"><cfelseif Form.paragraphtype eq 3><cfset displaytype="Out-of-State Tuition Form"><cfelseif Form.paragraphtype eq 1><cfset displaytype="Acceptance Form"></cfif>
	</cfif>
	<cfoutput>
    <h1>Admissions Status Check | <cfif isDefined("displaytype")>#displaytype#</cfif></h1>
    <cfif isDefined("Form.scholarship_form")>
    	<cfset pText=Replace(Form.scholarship_form, "<p>", "", "all")>
        <cfset pText=Replace(Form.scholarship_form, "</p>", "", "all")>
        <cfset myObject = createObject( "java", "ZipUtil" )>
    	<cfset compressed_form = myObject.compress(Form.scholarship_form) >
    	<cfquery name="updateCustomParagraph" datasource="eAcceptance">
        	insert into scholarship_forms (form_id, form_type, form_text, form_date, campus_id) values (scholforms_seq.nextval, '#paragraphtype#', <cfqueryparam cfsqltype="cf_sql_clob" value="#compressed_form#">, #NOW()#, '#Cookie.campusid#')
        </cfquery>
        <h3 style="color:red;">Thank you, the #displaytype# page has been updated!</h3>
    </cfif>
    <script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
    <cfquery name="getScholarshipRules" datasource="eAcceptance">
    	select * from scholarship_forms where form_type='#paragraphtype#' order by form_date desc
    </cfquery>
    <cfset myObject = createObject( "java", "ZipUtil" )>
    <cfset decompressed_form = myObject.decompress(getScholarshipRules.form_text) >
    <form method="post" action="index.cfm">
        <cfoutput><textarea name="scholarship_form" rows="7" cols="100">#decompressed_form#</textarea><br><br></cfoutput>
        <script type="text/javascript">
            /*CKEDITOR.replace( 'scholarship_form',{    
            skin : 'v2',
            toolbar :     
            [        
            ['Source','-','Save','NewPage','Preview','-','Templates'],
                ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker'],
                ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
                '/',
                ['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
                ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
                ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
                ['BidiLtr', 'BidiRtl' ],
                ['Link','Unlink','Anchor'],
                ['Image','HorizontalRule','SpecialChar','PageBreak'],
                ['Styles','Format','Font','FontSize','tokens_eschol'],
                ['TextColor','BGColor']
            ],   
            extraPlugins: 'tokens_eschol'
            }    
            );*/
	    CKEDITOR.replace( 'scholarship_form', {
		skin : 'moono',
		toolbar: [
			{ name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },	// Defines toolbar group with name (used to create voisdce label) and items in 3 subgroups.
			[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],			// Defines toolbar group without name.
			['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
		'/',
		['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
		['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
		['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
		['BidiLtr', 'BidiRtl' ],
		['Link','Unlink','Anchor'],
		['Image','HorizontalRule','SpecialChar','PageBreak'],
		['Styles','Format','Font','FontSize','tokens_eschol'],
		['TextColor','BGColor']
		],
		extraPlugins: 'tokens_eschol'
	})
        </script>
        <input type="submit" value="Submit">
        <input type="hidden" name="paragraphtype" value="#paragraphtype#">
        <input type="hidden" name="option" value="#Session.option#">
    </form>
    </cfoutput>
</cffunction>
<cffunction name="editItem4Form">
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<h1>Admissions Status Check | Scholarship Rules Item #4</h1>
	<!---<p>Please choose which scholarships category you would like to change the paragraph for:
	<select name="schol_cat" id="schol_cat">
		<option <cfif (isDefined("URL.schol_cat") and URL.schol_cat eq "SR") or (isDefined("Form.schol_cat") and Form.schol_cat eq "SR")>selected</cfif> value="SR">Student Recruitment</option>
		<option <cfif (isDefined("URL.schol_cat") and URL.schol_cat eq "UW") or (isDefined("Form.schol_cat") and Form.schol_cat eq "UW")>selected</cfif> value="UW">University-Wide</option>
	</select>
	<input type="button" value="Choose" onclick="document.location='index.cfm?option=15&schol_cat='+document.getElementById('schol_cat').options[document.getElementById('schol_cat').selectedIndex].value"></p>--->
    <cfset scholcat="UW">
	<cfif isDefined("scholcat") or isDefined("Form.schol_cat")>
		<cfif isDefined("Form.schol_cat")>
        	<cfset schol_cat=#Replace(Form.schol_cat, "<p>", "", "all")#>
			<cfset schol_cat=#Replace(schol_cat, "</p>", "", "all")#>
			<cfquery name="submitItem4" datasource="eAcceptance">
				update custom_paragraphs set paragraph_text='#Form.item4_paragraph#' where paragraph_type='item4#Form.schol_cat#' 
			</cfquery>
		</cfif>
		<cfif isDefined("Form.schol_cat")><p style="color:red;">Thank you, your paragraph has been submitted!</p></cfif>
		<h2>
		<cfif (isDefined("scholcat") and scholcat eq "SR") or (isDefined("Form.schol_cat") and Form.schol_cat eq "SR")>Student Recruitment Item #4
		<cfelseif (isDefined("scholcat") and scholcat eq "UW") or (isDefined("Form.schol_cat") and Form.schol_cat eq "UW")>University-Wide Item #4
		</cfif>
		</h2>
		<cfquery name="getItem4" datasource="eAcceptance">
			select * from custom_paragraphs where paragraph_type='item4<cfif isDefined("scholcat")>#scholcat#<cfelse>#Form.schol_cat#</cfif>'
		</cfquery>
		<cfoutput>
		<form method="post" action="index.cfm">
			<textarea name="item4_paragraph" rows="7" cols="100">#getItem4.paragraph_text#</textarea><br><br>
            <script type="text/javascript">
				/*CKEDITOR.replace( 'item4_paragraph',{    
				skin : 'v2',
				toolbar :     
				[        
				['Source','-','Save','NewPage','Preview','-','Templates'],
					['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker'],
					['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens_eschol'],
					['TextColor','BGColor']
				],   
				extraPlugins: 'tokens_eschol'
				}    
				);*/
				CKEDITOR.replace( 'item4_paragraph', {
					skin : 'moono',
					toolbar: [
						{ name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },	// Defines toolbar group with name (used to create voisdce label) and items in 3 subgroups.
						[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],			// Defines toolbar group without name.
						['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens_eschol'],
					['TextColor','BGColor']
					],
					extraPlugins: 'tokens_item4'
				})
			</script>
			<input type="submit" value="Submit">
			<input type="hidden" name="schol_cat" value="<cfif isDefined('scholcat')>#scholcat#<cfelseif isDefined('Form.schol_cat')>#Form.schol_cat#</cfif>">
		</form>
		</cfoutput>
	</cfif>
	<br><br>
</cffunction>
<cffunction name="editScholarshipDeadlineForm">
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<h1>Admissions Status Check | Scholarship Deadline</h1>
	<p>Please choose which scholarships category you would like to change the deadline for:
	<cfquery name="getContactInfo" datasource="scholarships">
		select * from contact_info order by awarding_unit
	</cfquery>
	<select name="schol_cat" id="schol_cat">
		<cfoutput query="getContactInfo">
			<option <cfif (isDefined("URL.schol_cat") and URL.schol_cat eq #getContactInfo.contact_unit#) or (isDefined("Form.schol_cat") and Form.schol_cat eq #getContactInfo.contact_unit#)>selected</cfif> value=#getContactInfo.contact_unit#>#getContactInfo.awarding_unit# - #getContactInfo.contact_email#</option>
		</cfoutput>
	</select>
	<input type="button" value="Choose" onclick="document.location='index.cfm?option=19&schol_cat='+document.getElementById('schol_cat').options[document.getElementById('schol_cat').selectedIndex].value"></p>
	<cfif isDefined("URL.schol_cat") or isDefined("Form.schol_cat")>
		<cfif isDefined("Form.schol_cat")>
        	<cfset schol_cat=#Replace(Form.schol_cat, "<p>", "", "all")#>
			<cfset schol_cat=#Replace(schol_cat, "</p>", "", "all")#>
			<cfquery name="submitDeadline" datasource="eAcceptance">
				update custom_paragraphs set paragraph_text='#Form.schol_deadline#' where paragraph_type='scholarshipDeadline#Form.schol_cat#' 
			</cfquery>
		</cfif>
		<cfif isDefined("Form.schol_cat")><p style="color:red;">Thank you, your paragraph has been submitted!</p></cfif>
		<h2>
		<cfif (isDefined("scholcat") and scholcat eq "SR") or (isDefined("Form.schol_cat") and Form.schol_cat eq "SR")>Student Recruitment Item #4
		<cfelseif (isDefined("scholcat") and scholcat eq "UW") or (isDefined("Form.schol_cat") and Form.schol_cat eq "UW")>University-Wide Item #4
		</cfif>
		</h2>
		<cfquery name="getDeadline" datasource="eAcceptance">
			select * from custom_paragraphs where paragraph_type='scholarshipDeadline<cfif isDefined("URL.schol_cat")>#URL.schol_cat#<cfelse>#Form.schol_cat#</cfif>'
		</cfquery>
		<cfoutput>
		<form method="post" action="index.cfm">
			<h3>Please enter your scholarship deadline:</h3>
			<input type="text" name="schol_deadline" value="<cfif isDefined("Form.schol_deadline")>#Form.schol_deadline#<cfelseif isDefined("URL.schol_cat")>#getDeadline.paragraph_text#</cfif>">
			<input type="submit" value="Submit">
			<input type="hidden" name="schol_cat" value="<cfif isDefined('Form.schol_cat')>#Form.schol_cat#<cfelseif isDefined("URL.schol_cat")>#URL.schol_cat#</cfif>">
		</form>
		</cfoutput>
	</cfif>
	<br><br>
</cffunction>
<cffunction name="editScholarshipPageForm">
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<h1>Admissions Status Check | Scholarship Page Form</h1>
	<p>Please choose which scholarships category you would like to change the paragraph for:
	<select name="schol_cat" id="schol_cat">
		<option <cfif (isDefined("URL.schol_cat") and URL.schol_cat eq "R") or (isDefined("Form.schol_cat") and Form.schol_cat eq "R")>selected</cfif> value="R">Resident</option>
		<option <cfif (isDefined("URL.schol_cat") and URL.schol_cat eq "NR") or (isDefined("Form.schol_cat") and Form.schol_cat eq "NR")>selected</cfif> value="NR">Non-resident</option>
	</select>
	<input type="button" value="Choose" onclick="document.location='index.cfm?option=18&schol_cat='+document.getElementById('schol_cat').options[document.getElementById('schol_cat').selectedIndex].value"></p>
	<cfif isDefined("URL.schol_cat") or isDefined("Form.schol_cat")>
		<cfif isDefined("Form.schol_cat")>
        	<cfset schol_cat=#Replace(Form.schol_cat, "<p>", "", "all")#>
			<cfset schol_cat=#Replace(schol_cat, "</p>", "", "all")#>
			<cfquery name="submitItem4" datasource="eAcceptance">
				update custom_paragraphs set paragraph_text='#Form.schol_paragraph#' where paragraph_type='scholarship#Form.schol_cat#' 
			</cfquery>
		</cfif>
		<cfif isDefined("Form.schol_cat")><p style="color:red;">Thank you, your paragraph has been submitted!</p></cfif>
		<h2>
		<cfif (isDefined("URL.schol_cat") and URL.schol_cat eq "R") or (isDefined("Form.schol_cat") and Form.schol_cat eq "R")>Resident Letter
		<cfelseif (isDefined("URL.schol_cat") and URL.schol_cat eq "NR") or (isDefined("Form.schol_cat") and Form.schol_cat eq "NR")>Non-Resident Letter
		</cfif>
		</h2>
		<cfquery name="getItem4" datasource="eAcceptance">
			select * from custom_paragraphs where paragraph_type='scholarship<cfif isDefined("URL.schol_cat")>#URL.schol_cat#<cfelse>#Form.schol_cat#</cfif>'
		</cfquery>
		<cfoutput>
		<form method="post" action="index.cfm">
			<textarea name="schol_paragraph" rows="7" cols="100">#getItem4.paragraph_text#</textarea><br><br>
            <script type="text/javascript">
				/*CKEDITOR.replace( 'schol_paragraph',{    
				skin : 'v2',
				toolbar :     
				[        
				['Source','-','Save','NewPage','Preview','-','Templates'],
					['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker'],
					['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens_eschol'],
					['TextColor','BGColor']
				],   
				extraPlugins: 'tokens_eschol'
				}    
				);*/
				CKEDITOR.replace( 'schol_paragraph', {
					skin : 'moono',
					toolbar: [
						{ name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },	// Defines toolbar group with name (used to create voisdce label) and items in 3 subgroups.
						[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],			// Defines toolbar group without name.
						['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens_eschol'],
					['TextColor','BGColor']
					],
					extraPlugins: 'tokens_eschol'
				})
			</script>
			<input type="submit" value="Submit">
			<input type="hidden" name="schol_cat" value="<cfif isDefined('URL.schol_cat')>#URL.schol_cat#<cfelseif isDefined('Form.schol_cat')>#Form.schol_cat#</cfif>">
		</form>
		</cfoutput>
	</cfif>
	<br><br>
</cffunction>
<cffunction name="editOutofStateForm">
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<h1>Admissions Status Check | Out-of-State Tuition Form</h1>
	<!---<p>Please choose which text you would like to edit:
	<select name="schol_cat" id="schol_cat">
		<option <cfif (isDefined("URL.schol_cat") and URL.schol_cat eq "IN") or (isDefined("Form.schol_cat") and Form.schol_cat eq "IN")>selected</cfif> value="IN">Form Introduction</option>
		<option <cfif (isDefined("URL.schol_cat") and URL.schol_cat eq "SU") or (isDefined("Form.schol_cat") and Form.schol_cat eq "SU")>selected</cfif> value="SU">Statement of Understanding</option>
	</select>
	<input type="button" value="Choose" onclick="document.location='index.cfm?option=16&schol_cat='+document.getElementById('schol_cat').options[document.getElementById('schol_cat').selectedIndex].value"></p>
	<cfif isDefined("URL.schol_cat") or isDefined("Form.schol_cat")>--->
		<cfif isDefined("Form.out_of_state")>
        	<cfset myObject = createObject( "java", "ZipUtil" )>
    		<cfset compressed_form = myObject.compress(Form.out_of_state) >
			<cfquery name="submitOST" datasource="eAcceptance">
				insert into scholarship_forms (form_id, campus_id, form_date, form_text, form_type) values (scholforms_seq.nextval, '#Cookie.campusid#', #NOW()#, <cfqueryparam cfsqltype="cf_sql_clob" value="#compressed_form#">, 3)
			</cfquery>
            <h3 style="color:red;">Thank you, your form has been updated!</h3>
		</cfif>
		
		<h2>
		<cfif (isDefined("URL.schol_cat") and URL.schol_cat eq "IN") or (isDefined("Form.schol_cat") and Form.schol_cat eq "IN")>Form Introduction
		<cfelseif (isDefined("URL.schol_cat") and URL.schol_cat eq "SU") or (isDefined("Form.schol_cat") and Form.schol_cat eq "SU")>Statement of Understanding
		</cfif>
		</h2>
		<cfquery name="getOST" datasource="eAcceptance">
			select * from scholarship_forms where form_type=3 order by form_date desc
		</cfquery>
        <cfset myObject = createObject( "java", "ZipUtil" )>
    	<cfset decompressed_form = myObject.decompress(getOST.form_text) >
		<cfoutput>
		<form method="post" action="index.cfm">
			<textarea name="out_of_state" rows="7" cols="100">#decompressed_form#</textarea><br><br>
            <script type="text/javascript">
				/*CKEDITOR.replace( 'out_of_state',{    
				skin : 'v2',
				toolbar :     
				[        
				['Source','-','Save','NewPage','Preview','-','Templates'],
					['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker'],
					['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens_outofstate'],
					['TextColor','BGColor']
				],   
				extraPlugins: 'tokens_outofstate'
				}    
				);*/
				CKEDITOR.replace( 'out_of_state', {
					skin : 'moono',
					toolbar: [
						{ name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },	// Defines toolbar group with name (used to create voisdce label) and items in 3 subgroups.
						[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],			// Defines toolbar group without name.
						['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens_outofstate'],
					['TextColor','BGColor']
					],
					extraPlugins: 'tokens_outofstate,justify,colorbutton'
				})
			</script>
			<input type="submit" value="Submit">
			<!---<input type="hidden" name="schol_cat" value="<cfif isDefined('URL.schol_cat')>#URL.schol_cat#<cfelseif isDefined('Form.schol_cat')>#Form.schol_cat#</cfif>">--->
		</form>
		</cfoutput>
	<!---</cfif>--->
	<br><br>
</cffunction>
<cffunction name="getStudents">
	<cfquery name="getStudentType" datasource="eAcceptance">
                select * from student_types where type_id='#Form.student_type#'
            </cfquery>
    <cftry>
            <cfstoredproc  procedure="APUPRD.WWOKEACC.F_FIND_ACCEPTED" datasource="eAcceptanceBanner">
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="application_type" type="in" value="#getStudentType.db_id#">  <!---change this when honors students get added to api (#Form.student_type#)--->
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="term_code" type="in" value="#Form.app_term#"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="start_date" type="in" value="#Form.start_date#"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="end_date" type="in" value="#Form.end_date#"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_sort_column" type="in" value="STUDENT_ID"> 
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_sort_order" type="in" value="ASC"> 
            <cfprocresult name="out_result_set_students">
            </cfstoredproc>
        <cfcatch>
            <cfset query=QueryNew("")>
             <cfoutput><B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
            <cfreturn query>
        </cfcatch>
        </cftry>
    	<cfmail from="christina@gsu.edu" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="mail1">
            <cfdump var="#out_result_set_students#">
        </cfmail>
	<cfif isDefined("Form.individual_pantherids")>
		<cfquery dbtype="query" name="out_result_set_students">
			select * from out_result_set_students where <cfset acount=1><cfloop list="#Form.individual_pantherids#" index="z"><cfif acount gt 1> or </cfif>student_id=<cfqueryparam CFSQLType = "string" value="#z#"><cfset acount=acount+1></cfloop>
		</cfquery>
		<cfmail from="christina@gsu.edu" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="mail1">
			<cfdump var="#out_result_set_students#">
		    </cfmail>
	</cfif>
	<cfreturn out_result_set_students>
	<cfabort>
</cffunction>
<cffunction name="previewStudentsTab">
	<a href="previewStudentSA.cfm" target="_blank">Preview SA Student</a><br>
	<a href="previewStudentSAP.cfm" target="_blank">Preview SAP Student</a><br>
	<hr><br>
    	<p>Please choose a template to change the preview template:</p>
        <form method="post" action="index.cfm">
    	<select name="template_type">
        	<option value="1">Freshman</option>
            <option value="4" <cfif isDefined("Form.template_type") and Form.template_type eq 4>selected</cfif>>Honors</option>
	    <!---<option value="10" <cfif isDefined("Form.template_type") and Form.template_type eq 10>selected</cfif>>SA</option>
	    <option value="11" <cfif isDefined("Form.template_type") and Form.template_type eq 11>selected</cfif>>SAP</option>--->
        </select>
        <input type="submit" value="Change">
        <input type="hidden" name="option" value="10">
        </form>
        <cfif not isDefined("Form.template_type")>
			<cfset curtemplatetype=1>
    	<cfelse>
    		<cfset curtemplatetype=Form.template_type> 
         </cfif> 
        <p><b>Current template showing: <cfif curtemplatetype eq 1>Freshman<cfelse>Honors</cfif></b></p>
   
    
	<h2>Click on the links below to preview each test student:</h2>
    <cfoutput>
    <ul>
    	<li><a target="_blank" href="previewStudent.cfm?student_id=001090797&template_type=#curtemplatetype#">Mickey Mouse</a></li>
        <li><a target="_blank" href="previewStudent.cfm?student_id=001090798&template_type=#curtemplatetype#">Minnie Mouse</a></li>
        <li><a target="_blank" href="previewStudent.cfm?student_id=001153485&template_type=#curtemplatetype#">John Public</a></li>
    </ul>
    </cfoutput>
</cffunction>
<cffunction name="uploadDegreeSpreadsheetForm">
	<form method="post" action="index.cfm" enctype="multipart/form-data" onsubmit="return validate_uploadform_excel(this);"><br><br>
    Upload Spreadsheet: <span class="error"><b>*</b></span> &nbsp; <input type="file" name="spreadsheet_file" size="15" maxlength="75" accept="application/vnd.ms-excel,text/csv"><br><br>
    <input type="Submit" name="submitDegreeSpreadsheetFile" value="Upload File">
    <br><br>
    </form> 
    <p><a target="_blank" href="/applicantstatus/admin/view_degree_paragraphs.cfm">View the current spreadsheet</a></p>
    <p><a target="_blank" href="/applicantstatus/admin/view_degree_paragraphs_excel.cfm">Download the current spreadsheet</a> <b>Note: </b>After viewing this file, save file to your computer as CSV (Comma-delimited)</p><br><br><br><br><br><br><br><br><br>
</cffunction>
<cffunction name="uploadDegreeSpreadsheet">
	<cfif Form.spreadsheet_file eq "">
    	<p><span class="error">Please browse for your file before pressing the upload button.</span></p>
        <cfinvoke method="uploadDegreeSpreadsheetForm" />
        <cfreturn false>
    </cfif>
	<cfif isDefined("Form.spreadsheet_file")>
		<cfif cgi.server_name eq "glacierqa.gsu.edu" or cgi.server_name eq "glacier.gsu.edu" or cgi.server_name eq "istcfqa.gsu.edu" or cgi.server_name eq "app.gsu.edu">
			<cfset drive="d">
        <cfelse>
            <cfset drive="c">
        </cfif>
	<cfif cgi.server_name eq "istcfqa.gsu.edu">
		<cfset filepath="#drive#:\inetpub\cf-qa\applicantstatus\admin\uploaded_files\degree_paragraphs.csv">
	<cfelseif cgi.server_name eq "app.gsu.edu">
		<cfset filepath="#drive#:\inetpub\applicantstatus\admin\uploaded_files\degree_paragraphs.csv">
	<cfelse>
		<cfset filepath="#drive#:\Inetpub\wwwroot\applicantstatus\admin\uploaded_files\degree_paragraphs.csv">
	</cfif>
        <cfset accepted_file_types="application/octet-stream, application/vnd.ms-excel, text/csv, text/plain">
    	<cftry>
			<cfif Form.spreadsheet_file neq "">
              <cffile action="upload"
                 fileField="Form.spreadsheet_file"
                 destination="#filepath#"
                 nameconflict="overwrite"
                 accept="#accepted_file_types#">
                 
            </cfif>
        <cfcatch>
        	<cfoutput>You have received an error.  Please only upload a .CSV file.<br>
            Error below:<br>#cfcatch.Detail# -> #cfcatch.Message#<br><br><br></cfoutput>
            <cfreturn>
        </cfcatch>
        </cftry>
        
        <cffile action="read" file="#filepath#" variable="csvfile"> 
        <cfset csvfilearray=ListtoArray(csvfile, "#chr(10)##chr(13)#")>

        <cfquery name="deleteContacts" datasource="eAcceptance">
        	delete from degree_custom_paragraphs
        </cfquery>
 	
 		<cfloop index="index" from="1" to="#ArrayLen(csvfilearray)#" step="1">
        	<!---doing it this way because still using ColdFusion 7.  cffile read doesn't even allow another delimiter besides a comma in this version.--->
        	<cfoutput>
            <!---#csvfilearray[index]#<br>--->
            <cfset degreeinfoarray=ListtoArray(csvfilearray[index])>
            <cfif #trim(degreeinfoarray[1])# neq "Paragraph" and #trim(degreeinfoarray[2])# neq "Field" and #trim(degreeinfoarray[3])# neq "Value" and #trim(degreeinfoarray[4])# neq "Text">
            	<cfset par_text="">
            	<cfloop index="i" from="4" to="#ArrayLen(degreeinfoarray)#" step="1">
                	<cfif par_text neq ""><cfset par_text=par_text&","></cfif>
                	<cfset par_text=par_text&degreeinfoarray[i]>
                </cfloop>
                <cfif ArrayLen(degreeinfoarray) gt 4 or Left(par_text, 1) eq '"'>
                	<!---<cfif Left(par_text, 1)> eq '"'>---><cfset par_text=Mid(par_text, 2, Len(par_text)-2)><!---</cfif>--->
                </cfif>
                <cfquery name="uploadContacts" datasource="eAcceptance">
                INSERT INTO degree_custom_paragraphs (paragraph_id, paragraph_type, banner_field, banner_value, paragraph_text) 
                 VALUES 
                          (custom_paragraph_sequence.NEXTVAL,
                          '#degreeinfoarray[1]#', 
                           '#degreeinfoarray[2]#',
                          '#degreeinfoarray[3]#',
                          <cfqueryparam cfsqltype="cf_sql_clob" value="#par_text#">
                          ) 
                </cfquery>
             </cfif>
          </cfoutput>
        </cfloop> 
        
        <!--- 
        <cfquery name="getcontacts" datasource="registration_adjustment"> 
                 SELECT * FROM contacts 
        </cfquery> 
        <cfdump var="#getcontacts#"> 
         ---> 
        
        <h2>Thank you, your file has been uploaded!</h2>  Please check that your information was uploaded correctly <a target="_blank" href="view_degree_paragraphs.cfm">here</a>.<br><br><br>
    </cfif>
</cffunction>
<cffunction name="showSignedScholForms">
	<cfquery name="getSchols" datasource="scholarships">
        select scholarship_id, title from scholarships
    </cfquery>
	<cfoutput>
    <h2>Signed Scholarship Accept Forms</h2>
    <p>Choose the dates between which you would like to view the signed forms.</p>
    <p><b>Please note: </b><i>The dates will only be used as filters if both dates are specified.</i></p>
	<div id="release">
    <h3>Filter Signed Scholarship Letters</h3>
    <form method="post" action="index.cfm">
		<SCRIPT LANGUAGE="JavaScript">
        var cal1schol = new CalendarPopup("popupcalendarschol"); 
        //cal1.showNavigationDropdowns();
        </SCRIPT> 
        <input  type="text" name="scholform_startdate" id="scholform_startdate" size="8" onfocus="alert('Please choose the date by clicking on the calendar to the right of the field.');this.blur();" value="<cfif isDefined('Form.scholform_startdate')>#Form.scholform_startdate#<cfelseif isDefined('URL.scholform_startdate')>#URL.scholform_startdate#<cfelse>mm/dd/yyyy</cfif>">
         <img src="images/cal.gif" onClick="cal1schol.select(document.getElementById('scholform_startdate'),'anchor1schol','MM/dd/yyyy'); return false;" TITLE="start date calendar" NAME="anchor1schol" ID="anchor1schol">
        <div id="popupcalendarschol" STYLE="position:absolute;visibility:hidden;background-color:white;layer-background-color:white;font-family: Arial, Helvetica, sans-serif;font-size: 12px;"></div>
        &nbsp; 
        to 
        &nbsp; 
        <SCRIPT LANGUAGE="JavaScript">
        var cal2schol = new CalendarPopup("popupcalendar2schol"); 
        //cal2.showNavigationDropdowns();
        </SCRIPT>
        <input  type="text" name="scholform_enddate" id="scholform_enddate" size="8" onfocus="alert('Please choose the date by clicking on the calendar to the right of the field.');this.blur();"  onchange="" value="<cfif isDefined('Form.scholform_enddate')>#Form.scholform_enddate#<cfelseif isDefined('URL.scholform_enddate')>#URL.scholform_enddate#<cfelse>mm/dd/yyyy</cfif>">
        <img src="images/cal.gif" onclick="cal2schol.select(document.getElementById('scholform_enddate'),'anchor2schol','MM/dd/yyyy');" name="anchor2schol" id="anchor2schol">
        <div id="popupcalendar2schol" STYLE="position:absolute;visibility:hidden;background-color:white;layer-background-color:white;font-family: Arial, Helvetica, sans-serif;font-size: 12px;"></div>
        <!-----------GET NAMES OF ALL SCHOLARSHIPS WITH ACCEPTANCES-------->
	<cfquery name="getSignedSchols" datasource="eAcceptance">
        	select distinct scholarship_id from scholarship_forms_archive
        </cfquery>
	<cfset myScholQuery = queryNew("id,name","Varchar,Varchar")>
	<cfset newRow = QueryAddRow(myScholQuery, 100)>
	<cfset scholQueryCount=1>
	<cfloop query="getSignedSchols">
		<cfif getSignedSchols.scholarship_id neq "">
			<cfquery name="getScholName" dbtype="query">	
				select title from getSchols where scholarship_id=#getSignedSchols.scholarship_id#
			</cfquery>
			<!--- Set the values of the cells in the query --->
			<cfset temp = QuerySetCell(myScholQuery, "id", "#getSignedSchols.scholarship_id#", #scholQueryCount#)>
			<cfset temp = QuerySetCell(myScholQuery, "name", "#getScholName.title#", #scholQueryCount#)>
			<cfset scholQueryCount=scholQueryCount+1>
		</cfif>
	</cfloop>
	<cfquery name="getSignedSchols2" datasource="eAcceptance">
		select distinct scholarship_code from scholarship_forms_archive
	</cfquery>
	<cfloop query="getSignedSchols2">
		<cfquery name="getScholName" datasource="eAcceptance">
			select panther_id,appterm from scholarship_forms_archive where scholarship_code='#getSignedSchols2.scholarship_code#' and rownum=1
		</cfquery>
		<cftry>
			<cfstoredproc  procedure="wwokbapi.f_get_sch_cohort" datasource="hsguidanceoracle">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#getScholName.panther_id#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="app_term_code" type="in" value="#getScholName.appterm#"> 
			<cfprocresult name="out_result_set_cohort_temp">
			</cfstoredproc> 
			<cfcatch>
			   <cfoutput>11<B>#cfcatch.message# -> #cfcatch.detail#</B>11<br /><br /></cfoutput>
			</cfcatch>
		</cftry>
		<cfset currentTestingScholCode=#getSignedSchols2.scholarship_code#>
		<cfloop query="out_result_set_cohort_temp">
			<cfif out_result_set_cohort_temp.scholarship_code eq currentTestingScholCode>
				<cfset temp = QuerySetCell(myScholQuery, "id", "#currentTestingScholCode#", #scholQueryCount#)>
				<cfset temp = QuerySetCell(myScholQuery, "name", "#out_result_set_cohort_temp.scholarship_description#", #scholQueryCount#)>
			</cfif>
		</cfloop>
		<cfset scholQueryCount=scholQueryCount+1>
	</cfloop>
	<!----------DONE GETTING NAMES------------->
        &nbsp; for &nbsp;
	<cfquery name="getFinalSignedSchols" dbtype="query">
		select * from myScholQuery order by name
	</cfquery>
        <select name="chosenSchol">
        	<option value="">All Scholarships</option>
        	<cfloop query="getFinalSignedSchols">
            	<cfif id neq "">
                    <option value="#id#" <cfif isDefined("form.chosenSchol") and form.chosenSchol eq id>selected</cfif>>#name#</option>
                </cfif>
            </cfloop>
        </select>
        &nbsp; &nbsp
        <cfquery name="getForms" datasource="eAcceptance">
        	select * from scholarship_forms_types order by formtype_id
        </cfquery>
        <cfset formlist=ValueList(getForms.form_type)>
        <cfset formarray=ListToArray(formlist)>
        <select name="chosenForm">
        	<option value="">All Forms</option>
        	<cfloop query="getForms">
                <option value="#formtype_id#" <cfif isDefined("form.chosenForm") and form.chosenForm eq formtype_id>selected</cfif>>#form_type#</option>
            </cfloop>
        </select>
        &nbsp; &nbsp<input type="submit" name="seeSignedForms" value="See Signed Forms">
	<input type="hidden" name="option" value="17">
    </form>
    </div>
    <!---select * from scholarship_forms_archive where form_type=1 <cfif isDefined("Form.chosenSchol") and Form.chosenSchol neq "">and scholarship_id=#Form.chosenSchol#</cfif> <cfif isDefined("Form.scholform_startdate") and isDefined("Form.scholform_enddate")>and form_date between #scholform_startdate# and #scholform_enddate#</cfif>--->
    </cfoutput>
    <cfinvoke method="showSignedFormsTable" formarray="#formarray#" />
</cffunction>
<cffunction name="showSignedFormsTable">
<cfargument name="formarray">
    <cfset formwhere="">
    <cfset filequery="">
	<cfif isDefined("Form.chosenForm") and Form.chosenForm neq "">
		<cfset formwhere="form_type=#Form.chosenForm#">
		<cfset filequery=filequery&"chosenForm=#Form.chosenForm#">
	</cfif>
	<cfif isDefined("URL.chosenForm") and URL.chosenForm neq "">
		<cfset formwhere="form_type=#URL.chosenForm#">
		<cfset filequery=filequery&"chosenForm=#URL.chosenForm#">
	</cfif>
	<cfif (isDefined("Form.chosenSchol") and Form.chosenSchol neq "") or (isDefined("URL.chosenSchol") and URL.chosenSchol neq "")>
		<cfif formwhere neq ""><cfset formwhere=formwhere&" and "></cfif>
		<cfif isDefined("Form.chosenSchol")><cfset chosenSchol=Form.chosenSchol>
		<cfelse><cfset chosenSchol=URL.chosenSchol>
		</cfif>
		<cfif isNumeric(chosenSchol) eq "YES">
			<cfset formwhere=formwhere&"scholarship_id=#chosenSchol#">
		<cfelse>
			<cfset formwhere=formwhere&"scholarship_code='#chosenSchol#'">
		</cfif>
		<cfif filequery neq ""><cfset filequery=filequery&"&"></cfif>
		<cfset filequery=filequery&"chosenSchol=#chosenSchol#">
	</cfif>
	<cfif isDefined("Form.scholform_startdate")><cfset scholform_startdate=Form.scholform_startdate></cfif>
	<cfif isDefined("URL.scholform_startdate")><cfset scholform_startdate=URL.scholform_startdate></cfif>
	<cfif isDefined("Form.scholform_enddate")><cfset scholform_enddate=Form.scholform_enddate></cfif>
	<cfif isDefined("URL.scholform_enddate")><cfset scholform_enddate=URL.scholform_enddate></cfif>
	<cfif isDefined("scholform_startdate") and isDefined("scholform_enddate") and scholform_startdate neq "mm/dd/yyyy" and scholform_enddate neq "mm/dd/yyyy">
	    <cfif formwhere neq ""><cfset formwhere=formwhere&" and "></cfif>
	    <cfset formwhere=formwhere & " form_date between to_date('#scholform_startdate#', 'mm/dd/yyyy') and to_date('#scholform_enddate#', 'mm/dd/yyyy')">
	    <cfif filequery neq ""><cfset filequery=filequery&"&"></cfif>
	    <cfset filequery=filequery&"scholform_startdate=#scholform_startdate#&scholform_enddate=#scholform_enddate#">
	</cfif>
    <cfoutput>
	<cfif isDefined("Form.seeSignedForms") or isDefined("URL.page")>
		<div width="100%" align="right"><cfif #getFileFromPath(cgi.script_name)# neq "downloadAcceptForms.cfm"><a target="_blank" href="downloadAcceptForms.cfm?#filequery#">Download Students in Excel Format</a><br></cfif></div>
	</cfif>
	<!---form_type=1 <cfif isDefined("Form.chosenSchol") and Form.chosenSchol neq "">and scholarship_id=#Form.chosenSchol#</cfif> <cfif isDefined("Form.scholform_startdate") and isDefined("Form.scholform_enddate") and Form.scholform_startdate neq "mm/dd/yyyy" and Form.scholform_enddate neq "mm/dd/yyyy">and form_date between to_date('#scholform_startdate#', 'mm/dd/yyyy') and to_date('#scholform_enddate#', 'mm/dd/yyyy')</cfif>---></cfoutput>
    <cfquery name="getSignedForms" datasource="eAcceptance">
    	select * from scholarship_forms_archive <cfif formwhere neq "">where (#PreserveSingleQuotes(formwhere)#)</cfif> <!---form_type=1 <cfif isDefined("Form.chosenSchol") and Form.chosenSchol neq "">and scholarship_id=#Form.chosenSchol#</cfif> <cfif isDefined("Form.scholform_startdate") and isDefined("Form.scholform_enddate") and Form.scholform_startdate neq "mm/dd/yyyy" and Form.scholform_enddate neq "mm/dd/yyyy">and form_date between to_date('#scholform_startdate#', 'mm/dd/yyyy') and to_date('#scholform_enddate#', 'mm/dd/yyyy')</cfif>--->  order by scholarship_id, student_last_name
    </cfquery>
    
    <cfif not isDefined("getSchols")>
	<cfquery name="getSchols" datasource="scholarships">
		select scholarship_id, title from scholarships where scholarship_id not in (select scholarship_id from scholarships_colleges where college_id=63)
	</cfquery>
    </cfif>
    
    <cfif getSignedForms.RecordCount eq 0>
    	<p><b>Sorry, there are no forms that match your request.</b></p>
    <cfelseif not isDefined("Form.seeSignedForms") and not isDefined("URL.page") and #getFileFromPath(cgi.script_name)# neq "downloadAcceptForms.cfm">
	<p><b>Please select from the filter above to view signed scholarship forms.</b></p>
    <cfelse>
        <table class="matrix" width="80%">
            <caption>Signed Scholarship Student Forms</caption>
            <tr><th>Scholarship Name</th><th>Panther ID</th><th>Student Name</th><th>Form Signed Date</th><th>Form Type</th><th>Intent</th><th>Housing</th><th>Incept</th></tr>
            <cfset rownum=0>
            <cfif not isDefined("URL.page")><cfset curPage=1>
			<cfelse><cfset curPage=URL.page></cfif>
            <cfoutput query="getSignedForms">
		<cfset curscholcode="">
		<cfset scholtitle="">
            	<cfset rownum = rownum + 1>
				<cfif #getFileFromPath(cgi.script_name)# eq "downloadAcceptForms.cfm" or (rownum gte ((curPage - 1) * 20 + 1) and rownum lte (curPage * 20))>
                    <cfif scholarship_id neq "">
			<cfset scholtitle="">
                        <cfquery name="getScholName" dbtype="query">
                            select title from getSchols where scholarship_id=#scholarship_id#
                        </cfquery>
			<cfset scholtitle=getScholName.title>
                    </cfif>
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
                    <tr><td><cfif isDefined("scholtitle")>#scholtitle#</cfif></td><td>#panther_id#</td><td><a target="_blank" href="https://#cgi.server_name#/applicantstatus/admin/showSignedForm.cfm?form=#form_id#">#student_last_name#, #student_first_name# </a></td><td>#DateFormat(form_date, "mm/dd/yyyy")#</td><td>#formarray[form_type]#</td>
		<td align="center"><cftry>
						<cfstoredproc  procedure="wwokbapi.f_get_intent" datasource="hsguidanceoracle">
						<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#panther_id#"> 
						<cfprocresult name="out_result_set_cohort_temp">
						</cfstoredproc>
						#out_result_set_cohort_temp.INTENT_IND#
						<cfcatch>
							Error
						</cfcatch>
					    </cftry></td>
			<td align="center"><cftry>
				<cfstoredproc  procedure="wwokbapi.f_get_housing" datasource="hsguidanceoracle">
						<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#panther_id#"> 
					
						<cfprocresult name="out_result_set_cohort_temp">
						</cfstoredproc>
						#out_result_set_cohort_temp.housing_ind#
			<cfcatch>
						   Error
						</cfcatch>
					    </cftry></td>
			<td align="center"><cftry>
				<cfstoredproc  procedure="wwokbapi.f_get_incept" datasource="hsguidanceoracle">
						<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#panther_id#"> 
					
						<cfprocresult name="out_result_set_cohort_temp">
						</cfstoredproc>
						#out_result_set_cohort_temp.incept_ind#
			<cfcatch>
						   Error
						</cfcatch>
					    </cftry></td>
         		</tr> <!---AM USING ABSOLUTE URL HERE BECAUSE IT LINKS FROM EXCEL DOCS ON COMPUTER--->
                </cfif>
            </cfoutput>
            <cfif #getFileFromPath(cgi.script_name)# neq "downloadAcceptForms.cfm"><cfoutput><tr><td colspan="6" align="center"><cfinvoke method="showPageNumbers" recordcount="#getSignedForms.RecordCount#" type="policy" /></td></tr></cfoutput></cfif>
        </table>
     </cfif>
</cffunction>
<cffunction name="editChecklist">
	<h1>Insert/Edit Checklist Items</h1>
	<p>Please enter the Banner Checklist Code (i.e. PSST for Personal Statement)<br><br></p>
	<form method="post" action="index.cfm">
		<input type="hidden" name="function" value="edit_checklist">
		<table>
		<Tr><Td>Banner Code:</Td><Td><input  type="text" name="banner_checklist_code" maxlength="4"></Td></Tr>
		<Tr><Td>Level Code:</Td><Td><select name="level_code"><option>US</option><option>GS</option></select></Td></Tr>
		<Tr><Td colspan="2"><input type="submit" name="submit_banner_checklist_code"></Td></Tr>
		</table>
	</form>
</cffunction>
<cffunction name="showBannerChecklistForm">
	<cfset banner_code=UCase(#Form.banner_checklist_code#)>
	<cfstoredproc  procedure="wwokbapi.f_get_chkl_desc" datasource="hsguidanceoracle">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="requirement_code" type="in" value="#banner_code#">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="level_code" type="in" value="#Form.level_code#">
        <cfprocresult name="out_result_set_desc">
	</cfstoredproc>
	<cfif out_result_set_desc.RecordCount eq 0>
		<h1>Insert Checklist Item to specify descriptions</h1>
		<cfinvoke method="showRequirementForm" methodtype="insert" />
	<cfelse>
		<h1>Update Checklist Item descriptions</h1>
		<cfinvoke method="showRequirementForm" methodtype="update" resultset="#out_result_set_desc#" />
	</cfif>
</cffunction>
<cffunction name="insertRequirementIntoChecklist">
	<cfif Form.short_description eq "" or Form.long_description eq ""><p>Please push the back button and insert both descriptions. Thank you.</p><cfreturn></cfif>
	<cfstoredproc  procedure="wwokbupi.f_insert_chkl_desc" datasource="hsguidanceoracle"  returnCode="yes">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="requirement_code" type="in" value="#Form.requirement_code#">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="level_code" type="in" value="#Form.level_code#">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="short_description" type="in" value="#Form.short_description#">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="long_description" type="in" value="#Form.long_description#">
        <cfprocresult name="out_result_set_desc3">
	</cfstoredproc>
	<cfif #cfstoredproc.statusCode# eq 1><h3>The insert was successful. Thank you!</h3>
	<cfelse>The insert was not successful.</cfif>
	<cfinvoke method="editChecklist" />
</cffunction>
<cffunction name="updateChecklistRequirement">
	<cfif Form.short_description eq "" or Form.long_description eq ""><p>Please push the back button and update both descriptions. Thank you.</p><cfreturn></cfif>
	<cfstoredproc  procedure="wwokbupi.f_update_chkl_desc" datasource="hsguidanceoracle" returnCode="yes">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="requirement_code" type="in" value="#Form.requirement_code#">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="level_code" type="in" value="#Form.level_code#">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="description_type" type="in" value="S"> <!---s for short, l for long--->
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="new_description" type="in" value="#Form.short_description#"> 
	</cfstoredproc>
	<cfset statuscode1=cfstoredproc.statusCode>
	<cfstoredproc  procedure="wwokbupi.f_update_chkl_desc" datasource="hsguidanceoracle" returnCode="yes">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="requirement_code" type="in" value="#Form.requirement_code#">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="level_code" type="in" value="#Form.level_code#">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="description_type" type="in" value="L"> <!---s for short, l for long--->
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="new_description" type="in" value="#Form.long_description#"> 
	</cfstoredproc>
	<cfif statuscode1 eq 1 and #cfstoredproc.statusCode# eq 1><h3>The update was successful. Thank you!</h3>
	<cfelse>The update was not successful.</cfif>
	<cfinvoke method="editChecklist" />
</cffunction>
<cffunction name="showRequirementForm">
<cfargument name="methodtype" required="yes">
<cfargument name="resultset" required="no" default="">
	<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
	<cfset banner_code=UCase(#Form.banner_checklist_code#)>
	<cfoutput>
	<form method="post" action="index.cfm">
		<input type="hidden" name="function" value="#methodtype#ChecklistItem">
		<input type="hidden" name="requirement_code" value="#banner_code#">
		<table>
			<tr>
				<td>Requirement Code</td>
				<td>#banner_code#</td>
			</tr>
			<Tr>
				<td>Level Code</td>
				<td>#Form.level_code#<input type="hidden" name="level_code" value="#Form.level_code#"></td>
			</Tr>
			<tr>
				<td valign="top">Short Description</td>
				<td><textarea name="short_description" id="short_description" maxlength="5"><cfif methodtype eq "update">#resultset.short_desc#</cfif></textarea></td>
				<script language="javascript">		  
				CKEDITOR.replace( 'short_description', {
					skin : 'moono',
					toolbar: [
						{ name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },	// Defines toolbar group with name (used to create voisdce label) and items in 3 subgroups.
						[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],			// Defines toolbar group without name.
						['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','Table','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens'],
					['TextColor','BGColor']
					]
				})
				</script>
			</tr>
			<tr>
				<td valign="top">Long Description</td>
				<Td><textarea name="long_description" maxlength="4000"><cfif methodtype eq "update">#resultset.long_desc#</cfif></textarea></Td>
				
				<script language="javascript">
				CKEDITOR.replace( 'long_description', {
					skin : 'moono',
					toolbar: [
						{ name: 'document', items: [ 'Source', '-', 'NewPage', 'Preview', '-', 'Templates' ] },	// Defines toolbar group with name (used to create voisdce label) and items in 3 subgroups.
						[ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ],			// Defines toolbar group without name.
						['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
					'/',
					['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
					['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
					['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
					['BidiLtr', 'BidiRtl' ],
					['Link','Unlink','Anchor'],
					['Image','Table','HorizontalRule','SpecialChar','PageBreak'],
					['Styles','Format','Font','FontSize','tokens'],
					['TextColor','BGColor']
					]
				})
				</script>
				
			</tr>
			<script>
				var currentLength;
				var SHORTLENGTHLIMIT = 950;
				CKEDITOR.instances.short_description.on("key", function() {
					currentLength = CKEDITOR.instances.short_description.getData().length;
					if (currentLength > SHORTLENGTHLIMIT) {
						alert('You have reached the limit of this text area.  Please delete some text.');
					}
				});
				
				var currentLength;
				var LONGLENGTHLIMIT = 3950;
				CKEDITOR.instances.long_description.on("key", function() {
					currentLength = CKEDITOR.instances.long_description.getData().length;
					if (currentLength > LONGLENGTHLIMIT) {
						alert('You have reached the limit of this text area.  Please delete some text.');
					}
				});
			</script>
			<Tr><td><input type="Submit" name="submit_inserted_checklist_item" onclick="if(CKEDITOR.instances.short_description.getData().length==0 || CKEDITOR.instances.long_description.getData().length==0) {alert('Please fill out both descriptions before submitting.'); return false;}"></td></Tr>
		</table>
	</form>
	</cfoutput>
</cffunction>
<cffunction name="insertBannerChecklistItem">
	<cfstoredproc  procedure="wwokbupi.f_insert_chkl_desc" datasource="hsguidanceoracle"  returnCode="yes">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="requirement_code" type="in" value="abcd">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="level_code" type="in" value="US">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="short_description" type="in" value="test short description">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="long_description" type="in" value="test long description">
        <cfprocresult name="out_result_set_desc3">
	</cfstoredproc>
	<cfdump var="#cfstoredproc.statusCode#">
</cffunction>
<cffunction name="updateBannerChecklistItem">
	
</cffunction>
<cffunction name="getSignedFormSQL">
	
</cffunction>
<cffunction name="showPDFBatches">
	<cfquery name="getBatchInfo" datasource="eAcceptance">
    	select * from sent_templates where sent_template_id=#URL.pdfbatches#
    </cfquery>
    <cfquery name="getStudType" datasource="eAcceptance">
    	select * from student_types where type_id=#getBatchInfo.student_type#
    </cfquery>
	<cfoutput>
    <h1>PDF Batch of Letters Sent #DateFormat(getBatchInfo.sent_date, "mm/dd/yyyy")# at #TimeFormat(getBatchInfo.sent_date, "hh:mm:ss tt")#</h1>
	<h3>Search Criteria:<br><br>#getBatchInfo.app_term# | #DateFormat(getBatchInfo.SEARCHSTART_APPDATE, "mm/dd/yyyy")# - #DateFormat(getBatchInfo.SEARCHEND_APPDATE, "mm/dd/yyyy")# | #getStudType.student_type#</h3><br>
	<h3>Student Letters</h3>
    <cfquery name="getSentLetters" datasource="eAcceptance">
    	select letter_id from sent_letters where pdf_unique_id='#getBatchInfo.unique_id#'
    </cfquery>
    <cfif getSentLetters.RecordCount lte 1000>
    	<a target="_blank" href="showBatchLetters.cfm?pdf=#URL.pdfbatches#">Download Group of Letters</a><br><br>
    <cfelse>
    	<cfset numletters=getSentLetters.RecordCount>
    	<cfloop index="i" from="1" to="#ceiling(numletters / 1000)#">
        	<a target="_blank" href="showBatchLetters.cfm?pdf=#URL.pdfbatches#&numbatch=#i#">Download Group of Letters ###i#</a><br>
        </cfloop><br><br>
    </cfif>
    <h3>Parent Letters</h3>
    <cfquery name="getSentLetters" datasource="eAcceptance">
    	select letter_id from sent_letters where pdf_unique_id='#getBatchInfo.unique_id#'
    </cfquery>
    <cfif getSentLetters.RecordCount lte 1000>
    	<a target="_blank" href="showParentLetters.cfm?pdf=#URL.pdfbatches#&semester=#getStudType.semester#">Download Group of Letters</a><br><br>
    <cfelse>
    	<cfset numletters=getSentLetters.RecordCount>
    	<cfloop index="i" from="1" to="#ceiling(numletters / 1000)#">
        	<a target="_blank" href="showParentLetters.cfm?pdf=#URL.pdfbatches#&numbatch=#i#&semester=#getStudType.semester#">Download Group of Letters ###i#</a><br>
        </cfloop><br><br>
    </cfif>
    </cfoutput>
</cffunction>


<CFFUNCTION NAME="showPageNumbers">
<cfargument name="recordcount">
<cfargument name="itemsperpage" default="">
<cfargument name="type">
<cfargument name="attributes" default="">
	<cfoutput>
		<cfif itemsperpage eq "">
			<cfset policiesperpage=20>
		<cfelse>
			<cfset policiesperpage=itemsperpage>
		</cfif>
		<cfset lastpagenum=#ceiling(recordcount/Int(policiesperpage))#>
		<cfif recordcount gt policiesperpage>
			<cfif isDefined("URL.page")>
				<cfset pagenum=URL.page>
				<cfset prevpagenum=URL.page - 1>
			<cfelse>
				<cfset pagenum=1>
				<cfset prevpagenum=0>
			</cfif>
			<cfloop index="page" from="1" to="#lastpagenum#">
				<cfif lastpagenum gt prevpagenum>
					<cfset query="">
					<cfif not page eq 1>&nbsp;|&nbsp;</cfif>
					<cfif not pagenum eq page>
						<cfset displayednum="linked">
					<cfelse>
						<cfset displayednum="selected">
					</cfif>
					<cfif isDefined("Form.student_type")>
						<cfset query="&student_type=#Form.student_type#&start_date=#Form.start_date#&end_date=#Form.end_date#&app_term=#Form.app_term#">
					<cfelseif isDefined("URL.student_type")>
						<cfset query="&student_type=#URL.student_type#&start_date=#URL.start_date#&end_date=#URL.end_date#&app_term=#URL.app_term#">
					<cfelseif isDefined("Form.panther_num")>
						<cfset query="&panther_num=#Form.panther_num#">
					<cfelseif isDefined("URL.panther_num")>
						<cfset query="&panther_num=#URL.panther_num#">
					</cfif>
					<cfif isDefined("URL.pdf_id")><cfset query=query&"&pdf_id=#URL.pdf_id#"></cfif>
					<cfif isDefined("URL.search")><cfset query=query></cfif>
					<cfif isDefined("Form.scholform_startdate")><cfset query=query&"&scholform_startdate=#Form.scholform_startdate#"></cfif>
					<cfif isDefined("Form.scholform_enddate")><cfset query=query&"&scholform_enddate=#Form.scholform_enddate#"></cfif>
					<cfif isDefined("Form.chosenSchol") and Form.chosenSchol neq ""><cfset query=query&"&chosenSchol=#Form.chosenSchol#"></cfif>
					<cfif isDefined("Form.chosenForm") and Form.chosenForm neq ""><cfset query=query&"&chosenForm=#Form.chosenForm#"></cfif>
					
					<cfif isDefined("URL.scholform_startdate")><cfset query=query&"&scholform_startdate=#URL.scholform_startdate#"></cfif>
					<cfif isDefined("URL.scholform_enddate")><cfset query=query&"&scholform_enddate=#URL.scholform_enddate#"></cfif>
					<cfif isDefined("URL.chosenSchol") and URL.chosenSchol neq ""><cfset query=query&"&chosenSchol=#URL.chosenSchol#"></cfif>
					<cfif isDefined("URL.chosenForm") and URL.chosenForm neq ""><cfset query=query&"&chosenForm=#URL.chosenForm#"></cfif>
					
					<cfif displayednum eq "linked">
						<cfif (isDefined("URL.option") and URL.option eq 17) or (isDefined("Form.option") and Form.option eq 17)>
						<cfset urloption=17>
					<cfelse>
						<cfset urloption=3>
					</cfif>
					<a href="/applicantstatus/admin/index.cfm?option=#urloption#&page=#page#<cfif isDefined('query')>&#query#</cfif>">
					</cfif>
					#page#
					<cfif displayednum eq "linked"></a></cfif>
				</cfif>
			</cfloop>
		</cfif>
		</cfoutput>
</CFFUNCTION>




<cffunction name="usersTab">
	<cfquery name="getUsers" datasource="eAcceptance">
    	select * from users where campus_id<>'christina' order by campus_id
    </cfquery>
    Add Campus ID: <input type="text" name="add_user" id="addUser"> <input type="button" value="Add Administrator" onclick="addUser(document.getElementById('addUser').value);">
    <br><br><span id="userChangeConfirmation" style="color:red;"></span>
    <table class="matrix" id="userTable">
    <caption>Administrator Table</caption>
    <tr><th>Campus ID</th><th>Name</th><th>Delete</th></tr>
    <cfset rowcolor=2>
    <cfoutput query="getUsers">
	 <cftry>
		<cfinvoke component="ldapAuthentication" method="getName" uid="#campus_id#" system="prod" return="true" returnvariable="username" />
	<cfcatch>
		<cfset username="">
	</cfcatch>
	</cftry>
    	<tr class="matrixrow#rowcolor#"><td>#campus_id#</td><td>#username#</td><td><img src="images/delete.gif" onclick="deleteUser('#campus_id#');"></td></tr>
        <cfif rowcolor eq 2><cfset rowcolor=1>
		<cfelse><cfset rowcolor=2></cfif>
    </cfoutput>
    </table>
</cffunction>

<cffunction name="uploadCounselorFileForm">
	<h3>High School Guidance Counselor Access file</h3>
	<form method="post" action="index.cfm" enctype="multipart/form-data" onsubmit="return validate_uploadform_access(this);"><br><br>
    Upload Access File: <span class="error"><b>*</b></span> &nbsp; <input type="file" name="access_file" size="15" maxlength="75" accept="application/msaccess, application/x-msaccess, application/vnd.msaccess, application/vnd.ms-access, application/mdb, application/x-mdb, zz-application/zz-winassoc-mdb"><br><br>
    <input type="Submit" name="submitCounselorAccessFile" value="Upload File">
    <br><br>
    </form>
    * Please only upload a .mdb file. If you have a later version of Access, you can click File > Save & Publish and save the file as a .mdb file.  Also, please have underscores instead of spaces in the field names.<br><br>
    <p><a target="_blank" href="/applicantstatus/counselor/view_counselor_file.cfm">View the current file</a></p><br><br><br>
</cffunction>


<cffunction name="uploadCounselorFile">
	<cfif Form.access_file eq "">
    	<p><span class="error">Please browse for your file before pressing the upload button.</span></p>
        <cfinvoke method="uploadCounselorFileForm" />
        <cfreturn false>
    </cfif>
	<cfif isDefined("Form.access_file")>
		<cfif cgi.server_name eq "istcfqa.gsu.edu">
			<cfset fullpath="d:\Inetpub\cf-qa\applicantstatus\counselor\admissions_counselor.mdb">
        <cfelseif cgi.server_name eq "webdb.gsu.edu">
            <cfset fullpath="d:\Inetpub\wwwroot\applicantstatus\counselor\admissions_counselor.mdb">
	<cfelseif cgi.server_name eq "app.gsu.edu">
		<cfset fullpath="d:\Inetpub\applicantstatus\counselor\admissions_counselor.mdb">
        </cfif>
        <cfset accepted_file_types="application/octet-stream, application/msaccess, application/x-msaccess, application/vnd.msaccess, application/vnd.ms-access, application/mdb, application/x-mdb, zz-application/zz-winassoc-mdb">
    	<cftry>
			<cfif Form.access_file neq "">
              <cffile action="upload"
                 fileField="Form.access_file"
                 destination="#fullpath#"
                 nameconflict="overwrite"
                 accept="#accepted_file_types#">
                 
            </cfif>
        <cfcatch>
        	<cfoutput>You have received an error.  Please only upload a .mdb file.<br>
            Error below:<br>#cfcatch.Detail# -> #cfcatch.Message#<br><br><br></cfoutput>
            <cfreturn>
        </cfcatch>
        </cftry>
        
        
        
        <h2>Thank you, your file has been uploaded!</h2>  Please check that your information was uploaded correctly <a target="_blank" href="../counselor/view_counselor_file.cfm">here</a>.<br><br><br>
    </cfif>
</cffunction>
<cffunction name="getDeviceStatistics">
            <h3>Device Statistics</h3>
        <cfquery name="GetDates" datasource="eAcceptance">
            select extract(month from click_date) "month", extract(year from click_date) "year" from student_clicks where user_agent is not null group by  extract(month from click_date),  extract(year from click_date) order by extract(year from click_date), extract(month from click_date)
        </cfquery>
        <form action="index.cfm" method="post">
        <select name="showMonths">
            <cfoutput query="GetDates">
                <cfset correctMonth=NumberFormat(month, "00")>
                <option value="#correctMonth##year#">#MonthAsString(month)# #year#</option>
            </cfoutput>
        </select> <input type="submit" value="GO">
	<input type="hidden" name="function" value="view_statistics">
        </form>
        <h3>Logins</h3>
        <cfif isDefined("Form.showMonths")>
            <br><br>
            <cfquery name="GetStats" datasource="eAcceptance">
                select * from student_clicks where extract(month from click_date)=#Left(Form.showMonths, 2)# and extract(year from click_date)=#Right(Form.showMonths, 4)# order by click_date
            </cfquery>
            <!---<cfdump var="#GetStats#">--->
            <cfset searchSystems=ListSort("Windows,Macintosh,IPad,Android,IPhone,Blackberry,Kindle", "text")>
            <cfoutput>
            <cfloop list="#searchSystems#" index="sys">
                <cfquery name="getSystems" dbtype="query">
                    select * from GetStats where click_event=1 and upper(user_agent) like '%#UCase(sys)#%'
                </cfquery>
                <b>#sys#</b> - #getSystems.RecordCount#<br>
            </cfloop>
            </cfoutput>
        </cfif>
        <br><br><Br>
</cffunction>