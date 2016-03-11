<cffunction name="logout">
    <cfcookie name = "UserAuthRetStudAppStatus" value = "false" expires = "NOW">
    <cfcookie name = "gsu_student_id_retstudappstatus" value = "false" expires = "NOW">
    <cfset Session.UserAuthRetStudAppStatus="false">
    <cfset Session.gsu_student_id_retstudappstatus="false">
    <cfset Session.campusid="false">
    <cflocation url="returning_students.cfm" addtoken="no" />
</cffunction>
<cffunction name="showPage">
    <cftry>
        <cfset Session.gsu_student_id="">
	<cfstoredproc procedure="wwokbapi.f_get_stud_id" datasource="SCHOLARSHIPAPI">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="campus_id" type="in" value="#Session.campusid#">  
	<cfprocresult name="out_result_set">
	</cfstoredproc>
    <cfcatch>
        <!---<cfoutput>#cfcatch.message# -> #cfcatch.detail#</cfoutput>--->
        <p>Sorry, this system is only available to current students.</p><cfabort>
    </cfcatch>
    </cftry>
    <cfif not isDefined("out_result_set.student_id")><p>Sorry, this system is only available to current students.</p><cfabort></cfif>
    <cfset Session.STUDENT_ID=out_result_set.student_id>
    
    <cfset scholList="">
    <cftry>
          <cfstoredproc  procedure="wwokbapi.f_get_sch_cohort" datasource="hsguidanceoracle">
          <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#Session.STUDENT_ID#"> 
          <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="app_term_code" type="in" value="#Session.curterm#"> 
          <cfprocresult name="out_result_set_cohort">
          </cfstoredproc> 
          <cfcatch>
             <cfoutput>112<B>#cfcatch.message# -> #cfcatch.detail#</B></cfoutput>
             <div class="container_16 footer">
                <cfinvoke component="counselor/hsguidance" method="showPageFooter" />
              </div>
              
              <!---<cfabort>--->
          </cfcatch>
      </cftry>
    <!---<cfdump var="#out_result_set_cohort#">--->
    <cftry>
        <cfstoredproc  procedure="wwokbapi.f_get_sch_forms" datasource="hsguidanceoracle">
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="student_id" type="in" value="#Session.student_id#"> 
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="app_term_code" type="in" value="#Session.curterm#"> 
        <cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="scholarship_code" type="in" value="#out_result_set_cohort.scholarship_code#"> 
        <cfprocresult name="out_result_set_cohort1">
        </cfstoredproc> 
        <cfcatch>
           <cfoutput>22<B>#cfcatch.message# -> #cfcatch.detail#</B>22<br /><br /></cfoutput>
        </cfcatch>
    </cftry>
    <!---<cfdump var="#out_result_set_cohort1#">--->
      <cfset scholList=ValueList(out_result_set_cohort.scholarship_id)>
      <cfset scholcount=out_result_set_cohort.RecordCount>
    <cfoutput>
        <table class="usermatrix" width="90%">
	    <!---<cfoutput>#Session.curterm#</cfoutput>--->
            <cfset scholyear=Left(Session.curterm, 4)>
            <cfset scholsem=Right(Session.curterm, 2)>
            <cfif scholsem eq "01">
                <cfset scholsemester="Spring">
            <cfelseif scholsem eq "05">
                <cfset scholsemester="Summer">
            <cfelse>
                <cfset scholsemester="Fall">
            </cfif>
            <tr><td style="border-bottom-width: 1px; border-bottom-style: outset; border-color: Black;" nowrap><h2>Scholarship Term: #scholsemester# Semester #scholyear#</h2></td></tr>
            <tr><td valign="top"><br><b>Name: </b>
            <!---<cfinvoke component="/scholarships/admin/scholadmin" method="getName" gsustudentid="#Session.student_id#" /><br><br>--->
		<cftry>
                <cfstoredproc procedure="wwokbapi.f_get_general" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#Session.student_id#"><!---#NumberFormat(gsustudentid, "000000000")#"> --->
		<cfprocresult name="out_result_set_name">
		</cfstoredproc>
                #out_result_set_name.first_name# #out_result_set_name.mi# #out_result_set_name.last_name#
                <cfcatch>
                    
                    <cfif Find("Confidential", #cfcatch.detail#)>
                        Confidential Student Information
                    <cfelse>
                        Error Occured
                    </cfif>
                    
                </cfcatch>
                </cftry>
                <br><br>
            <b>College Affiliation:</b> <cfinvoke component="/scholarships/admin/scholadmin" method="getAffiliatedCollege" gsustudentid="#Session.student_id#" returnvariable="col" />
            <cfif find("<i>", #col#)>
                <i>Not Found</i>
            <cfelse>
                #col#
            </cfif>
            <br><br>
            <b>Major:</b> <cfinvoke component="/scholarships/admin/scholadmin" method="getMajor" gsustudentid="#Session.student_id#" returnvariable="mjr" />
            <cfif find("<i>", #mjr#)>
                <i>Not Found</i>
            <cfelse>
                #mjr#
            </cfif>
            <br><br>
            <b>Classification:</b> <cfinvoke component="/scholarships/admin/scholadmin" method="getClassification" gsustudentid="#Session.student_id#" returnvariable="cls" />
            <cfif find("<i>", #cls#)>
                <i>Not Found</i>
            <cfelse>
                #cls#
            </cfif>
            <br>
            </td>
            <td>
                <cfif scholcount gt 0>
                    <div id="release" class="viewappbox" <cfif Session.mobile eq "true">style="width:450px;<!---was 150 before addingi scholarship--->"</cfif>><h3 style="margin-top:0px;margin-bottom:10px;">View your Scholarship Letter<cfif scholcount gt 0>s</cfif></h3>
                        <table>
			     <cfif out_result_set_cohort.RecordCount gt 0>
				<tr><td><a href="viewYourScholarshipLetter.cfm" title="View Scholarship Letter"><img border="0" src="admin/images/scholarship_letter_icon.png"></a></td>
					<td>
                    <div style="padding-top:15px;" onClick="document.location='viewYourScholarshipLetter.cfm';">
                    <a href="viewYourScholarshipLetter.cfm?panid=#URLEncodedFormat(Encrypt(Session.STUDENT_ID, '#Session.campusid##Session.enc_key#'))#" title="View Scholarship Letter">View your Scholarship Letter</a><br>(PDF)<!---<span style="float:right;display:inline;margin-right:50px;font-size:24px;font-weight:bold;margin-top:-10px;">></span>--->
                    </div></td></tr>
                                 </cfif>
                                <cfif Session.mobile eq "false"><tr><td colspan="2"><hr style="margin-top:10px;">View your Scholarship Letter from Georgia State.   <br><br><div width="100%" align="center"><a href="http://get.adobe.com/reader/" target="_blank">Need Adobe Acrobat?</a></div></td></tr></cfif>
                            </table>
                            <br></div></div>
                <cfelse>
                    <p><i>Sorry, no available scholarships have been found at this time.</i></p>
                </cfif>
            </td>
            </tr>
        </table>
    </cfoutput>
</cffunction>
