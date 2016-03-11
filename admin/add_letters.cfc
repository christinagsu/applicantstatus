<cffunction name="add_letter_form">
    <cfoutput>
    <form name="addLetter" action="add_letters.cfm" method="post">
        <p>What type of letter is this?</p>
        <select name="admit_type">
            <option value="a" <cfif isDefined("Form.admit_type") and Form.admit_type eq "a">selected</cfif>>Acceptance Letter</option>
            <option value="d" <cfif isDefined("Form.admit_type") and Form.admit_type eq "d">selected</cfif>>Denial Letter</option>
            <option value="df" <cfif isDefined("Form.admit_type") and Form.admit_type eq "df">selected</cfif>>Deferral Letter</option>
            <option value="w" <cfif isDefined("Form.admit_type") and Form.admit_type eq "w">selected</cfif>>Withdrawal Letter</option>
            <option value="wl" <cfif isDefined("Form.admit_type") and Form.admit_type eq "wl">selected</cfif>>Wait List Letter</option>
        </select>
        <p>Is this an international letter?</p>
        <select name="type_category">
            <option value="int" <cfif isDefined("Form.type_category") and Form.type_category eq "int">selected</cfif>>Yes</option>
            <option value="other" <cfif isDefined("Form.type_category") and Form.type_category eq "other">selected</cfif>>No</option>
        </select>
        <p>Is this letter a generic letter for all semesters (not a separate letter for each semester)?</p>
        <select name="all_semesters" id="all_semesters" onChange="selectSemester();">
            <option value="X" <cfif isDefined("Form.all_semesters") and Form.all_semesters eq "X">selected</cfif>>Yes</option>
            <option value="" <cfif isDefined("Form.all_semesters") and Form.all_semesters eq "">selected</cfif>>No</option>
        </select>
        <div id="semester_div">
        <p>Please specify the semester that this student type pertains to:</p>
        <select name="semester" id="semester">
            <option value=""></option>
            <option value="01" <cfif isDefined("Form.semester") and Form.semester eq "01">selected</cfif>>Spring</option>
            <option value="05" <cfif isDefined("Form.semester") and Form.semester eq "05">selected</cfif>>Summer</option>
            <option value="08" <cfif isDefined("Form.semester") and Form.semester eq "08">selected</cfif>>Fall</option>
        </select>
        </div>
        <p>Please enter the Banner Population Code for this student type/letter:</p>
        <input type="text" name="db_id" <cfif isDefined("Form.db_id")>value="#Form.db_id#"</cfif>>
        <p>Please enter the name of the dropdown option that Admissions can choose to send this letter:</p>
        <input type="text" name="student_type" <cfif isDefined("Form.student_type")>value="#Form.student_type#"</cfif>>
        <br><br><input type="submit" value="Create this Letter" onclick="validateForm();">
    </form>
    </cfoutput>
</cffunction>
<cffunction name="validate_letter_form">
    <cfif Form.all_semesters eq "" and Form.semester eq "">
        <h2>If you choose that this is not a generic letter for all semesters, please specify the semester. Thank you.</h2>
        <cfinvoke method="add_letter_form" />
        <cfreturn false>
    </cfif>
    <cfif not isDefined("Form.db_id") or Form.db_id eq "">
        <h2>Please fill out the Banner Population Code before submitting this form. Thank you.</h2>
        <cfinvoke method="add_letter_form" />
        <cfreturn false>
    <cfelseif not isDefined("Form.student_type") or Form.student_type eq "">
        <h2>Please fill out the name of the dropdown option before submitting this form. Thank you.</h2>
        <cfinvoke method="add_letter_form" />
        <cfreturn false>
    </cfif>
    <cfinvoke method="submit_letter_form" />
</cffunction>
<cffunction name="submit_letter_form">
    <cfif Form.all_semesters eq "X"><cfset semester="08">
    <cfelse><cfset semester=Form.semester>
    </cfif>
    <cfoutput>insert into student_types (ADMIT_TYPE, ALL_SEMESTERS, DB_ID, SEMESTER, STUDENT_TYPE, TYPE_CATEGORY, TYPE_ID) values ('#Form.admit_type#', '#Form.all_semesters#', '#Form.db_id#', '#semester#', '#Form.student_type#', '#Form.type_category#', STUDENTTYPE_SEQ.nextVal)</cfoutput>
    <!---<cfquery name="addLetter" datasource="eAcceptance">
        insert into student_types (ADMIT_TYPE, ALL_SEMESTERS, DB_ID, SEMESTER, STUDENT_TYPE, TYPE_CATEGORY, TYPE_ID) values ('#Form.admit_type#', '#Form.all_semesters#', '#Form.db_id#', '#Form.semester#', '#Form.student_type#', '#Form.type_category#', STUDENTTYPE_SEQ.nextVal)
    </cfquery>--->
    end
    <cfinvoke method="add_letter_form" />
</cffunction>