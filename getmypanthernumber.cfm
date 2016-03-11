<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html dir=\"ltr\" lang=\"en\">
<head>
<style type="text/css"> 
<!-- 
p, tr, td { font-family: Arial; color: #000099; font-size: .85em; } 
h1, h2, h3, h4 { font-family: Arial; color:#990033} 
h1 { font-size: 1.7em; }
h2 { font-size: 1.4em; }
h3 { font-size: 1.2em; }
h4 { font-size: 1.0em; }
.note { font-size: 8pt; margin-top: 0; }
--> 
</STYLE>
<script>
   function SetParentInfo() {
      window.opener.document.getElementById("stud_panther_number").value=document.getElementById("studentId").value;
      window.opener.document.getElementById("stud_first_name_three_letters").value=document.getElementById("fname").value;
      window.opener.document.getElementById("stud_last_name").value=document.getElementById("lname").value;
      window.opener.document.getElementById("stud_four_digits_ssn").value=document.getElementById("ssn").value;
      window.opener.document.getElementById("birth_day").value=document.getElementById("bday").value;
      window.opener.document.getElementById("birth_year").value=document.getElementById("byear").value;
      var bdate = new Date(document.getElementById("bmonth").value+"/"+document.getElementById("bday").value+"/"+document.getElementById("byear").value),
         locale = "en-us",
         month = bdate.toLocaleString(locale, { month: "short" });
      //alert(month.toUpperCase());
      window.opener.document.getElementById("birth_month").value=month.toUpperCase();
   }
</script>

<cfif isDefined("submit_gsuid_request")>
   <cfif isDefined("Form.ssn1")><cfset ssn=Form.ssn1><cfelse><cfset ssn=""></cfif>
   <cfif isDefined("Form.country")><cfset country1=Form.country><cfelse><cfset country1=""></cfif>
	 <cfif Form.month lt 10><cfset tmonth="0"&#Form.month#><cfelse><cfset tmonth=Form.month></cfif>
	 
   

	 <cfset firstNameLen=Len(Form.fname)>
	 <cfset tempstudid="">
	 <cfset templname=Replace(Form.lname, "'", "", "all")>
	 <cfset templname=Replace(templname, "-", "", "all")>
	 <cfset templname=Replace(templname, " ", "", "all")>
	 <cfset templname=Replace(templname, "\\", "", "all")>
	 
	 <cfif country1 eq "US">
			<cfquery name="getPantherNum" datasource="hsguidanceoracle">
							 select   a.spriden_id
               from     spriden a,
                        spbpers b
               where    a.spriden_search_last_name like upper('#templname#')
               and      substr (a.spriden_search_first_name, 0, #firstNameLen#) = upper('#Form.fname#')
               and      b.spbpers_birth_date = to_date('#Form.year#-#Form.month#-#Form.mday#', 'YYYY-MM-DD')
               and      a.spriden_change_ind is NULL
               and      a.SPRIDEN_PIDM = b.spbpers_pidm
			</cfquery>
			<cfset panthernum=getPantherNum.spriden_id>
	 </cfif>
	 <cfif ssn eq "">
			<cfquery name="getPantherNum" datasource="hsguidanceoracle">
				 select   a.spriden_id
               from     spriden a,
                        spbpers b
               where    a.spriden_search_last_name like upper('#templname#')
               and      substr (a.spriden_search_first_name, 0, #firstNameLen#) = upper('#Form.fname#')
               and      b.spbpers_birth_date = to_date('#Form.year#-#Form.month#-#Form.mday#', 'YYYY-MM-DD')
               and      a.spriden_change_ind is NULL
               and      a.SPRIDEN_PIDM = b.spbpers_pidm
			</cfquery>
			<cfset panthernum=getPantherNum.spriden_id>
			<cfif isDefined("panthernum")>
				 <cfquery name="getCountry" datasource="hsguidanceoracle">
						select  b.GOBINTL_NATN_CODE_LEGAL as birth
                   from    spriden a,
                           gobintl b,
                           gorvisa c
                   where  a.spriden_id = '#panthernum#'
                   and    a.spriden_change_ind is null
                   and    a.spriden_pidm = c.gorvisa_pidm
                   and    a.spriden_pidm = b.GOBINTL_PIDM
                   and    c.gorvisa_activity_date = (select max(y.gorvisa_activity_date)
                                                     from   gorvisa y,
                                                            spriden z
                                                     where  z.spriden_pidm = y.gorvisa_pidm
                                                     and    z.spriden_id = a.spriden_id
                                                     and    z.spriden_change_ind is NULL)

				 </cfquery>
				 <cfif getCountry.birth eq country1>
						<cfset panthernum=getPantherNum.student_id>
				 </cfif>
			</cfif>
	 <cfelse>
			<cfif country1 eq "">
				 <cfquery name="getPantherNum" datasource="hsguidanceoracle">
						select   a.spriden_id
               from     spriden a,
                        spbpers b
               where    a.spriden_search_last_name like upper('#templname#')
               and      b.spbpers_birth_date = to_date('#Form.year#-#Form.month#-#Form.mday#', 'YYYY-MM-DD')
               and      substr(b.spbpers_ssn, -4,4) = '#ssn#'
               and      substr (a.spriden_search_first_name, 0, #firstNameLen#) = upper('#Form.fname#')
               and      a.spriden_change_ind is NULL
               and      a.SPRIDEN_PIDM = b.spbpers_pidm

				 </cfquery>
				 <cfset panthernum=getPantherNum.spriden_id>
			</cfif>
	 </cfif>





















<cfoutput>

   <h2>#panthernum#</h2>
   <input type="hidden" id="studentId" value="#panthernum#">
   <input type="hidden" id="ssn" value="#ssn#">
   <input type="hidden" id="country" value="#country1#">
   <input type="hidden" id="bmonth" value="#Form.month#">
   <input type="hidden" id="bday" value="#Form.mday#">
   <input type="hidden" id="byear" value="#Form.year#">
   <input type="hidden" id="fname" value="#Form.fname#">
   <input type="hidden" id="lname" value="#templname#">
   <p>Please write this number down and/or memorize it.  You will need to use
   this number on many of the forms that used to require your SSN.  SSNs will
   still be required on some forms dealing with payroll and federal and state
   taxes.</p>
   <p>
   <form name="insergpcid">
   
          
     <input class="formbutton" type="submit" value="Copy my Panther Number and Details to the Form" onclick='SetParentInfo(); self.close(); return false;' />
   
           &nbsp; &nbsp;
     <input class="formbutton" type="submit" value="Cancel" onclick='self.close(); return false;' />
   </form>
   </p>
   <script language="JavaScript">
     var origOpener = self.opener;
     var origName = origOpener.name;
     function OpenerWatch() {
       // watch for changes in the opener.name
       setTimeout('testOpener(origName)',1000);
     } //end OpenerWatch
   
     function testOpener(strName){
       // if the opener reference is lost, close this window
       if (!self.opener || self.opener.closed) {
         //alert('Closing -- the opener page changed: \n original name: ' + strName + '\n name now: ' + opener);
         self.close();
       } else {
         //alert('Opener still there -- ' + opener.name);
         OpenerWatch();
       }
     }// end testOpener
   
   </script>
</cfoutput>
<cfabort>
</cfif>

<script type="text/javascript">

function ckagree(form)  {

   var s = new String (document.getElementById("last_name").value.fulltrim());

        if (s.length < 2) {
            alert("Last Name is a required field");
            document.getElementById("last_name").focus();
            return(false);
        }

        document.getElementById("last_name").value = s;


        if (document.getElementById('no_ssn').checked == false) {

            if (document.getElementById("ssn4").value.length != 4) {
                alert("Last 4 Digits of your SSN  is a required field");
                document.getElementById("ssn4").focus();
                return(false);
            }

            if (isNumber(document.getElementById("ssn4").value) == false) {
                alert("Last 4 Digits of your SSN  must be a Number");
                document.getElementById("ssn4").focus();
                return(false);
            }

        } else {

            if (form.country.selectedIndex == 0) {
                alert ("Country of citizenship is a required field if you do not have an SSN number.");
                form.country.focus();
                form.country.select();
                return false;
            }



        }

        if (isNumber(form.gpcid.value) == false) {
            alert ("GPC-ID must be a number.");
            form.gpcid.focus();
            form.gpcid.select();
            return false;
        }


        if (form.gpcid.value.charAt(0) != "9") {
            alert ("GPC-ID must start with a number 9");
            form.gpcid.focus();
            form.gpcid.select();
            return false;
         }


         if (form.gpcid.value.length != 9) {
             alert ("Please enter a 9-digit GPC-ID.");
             form.gpcid.focus();
             form.gpcid.select();
             return false;
         }

         if (form.mon.selectedIndex == 0) {
             alert ("Please enter your Birth Month.");
             form.mon.focus();
             form.mon.select();
             return false;

         }

         if (form.day.selectedIndex == 0) {
             alert ("Please enter your Birth Day.");
             form.day.focus();
             form.day.select();
             return false;

         }




  var last_name = document.getElementById('last_name').value;
  var ssn4 = document.getElementById('ssn4').value;
  var gpcid = document.getElementById('gpcid').value;
  var mon = document.getElementById('mon').selectedIndex;
  var day = document.getElementById('day').selectedIndex;
  var ycount = document.getElementById('year').selectedIndex;
  var year = document.getElementById('year').options[ycount].value;
  var mytoke = document.getElementById('mytoke').value;
  var country_index = document.getElementById('country').selectedIndex;
  var country = document.getElementById('country').options[country_index].value;
  var no_ssn = document.getElementById('no_ssn').checked;

  var parameters="last_name="+last_name+"&ssn4="+ssn4+"&gpcid="+gpcid+"&mon="+mon+"&day="+day+"&year="+year+"&mytoke="+mytoke+"&country="+country+"&no_ssn="+no_ssn;

   //alert(parameters);

  //  var count = document.getElementById('s_cdef').options[scount].value;

  http.open("POST", "gr_ajax.php", true)
  http.setRequestHeader("Content-type", "application/x-www-form-urlencoded")
  http.onreadystatechange = handle_step_1;
  http.send(parameters);

}//endof 




function handle_step_1() {

  var results;

  if (http.readyState == 4) {

      //alert("response " + http.responseText) + "\n";

      document.getElementById('work').innerHTML = http.responseText;

  }

}//endof




function get_a_question(gpcid, sq_counter) {


  var parameters="gpcid="+gpcid+"&sq_counter="+sq_counter;
  //alert(parameters); 

  http.open("POST", "sq_ajax.php", true)
  http.setRequestHeader("Content-type", "application/x-www-form-urlencoded")
  http.onreadystatechange = handle_get_a_question;
  http.send(parameters);


}//endof


function handle_get_a_question() {

  var results;

  if (http.readyState == 4) {

      //alert("response " + http.responseText) + "\n";

      document.getElementById('sq_container').innerHTML = http.responseText;

  }

}//endof


function save_sq() {

  var gpcid = document.getElementById('gpcid').value;
  var sq_counter = document.getElementById('sq_counter').value;
  var question_index = document.getElementById('question').selectedIndex;
  var qid = document.getElementById('question').options[question_index].value;
  var answer = document.getElementById('answer').value;

  if (!question_index) {
      alert("Please Select a Secret Question");
      return(false);

  }

  if (answer.length < 5) {
      alert("Answer must be at least 5 characters");
      document.getElementById('answer').focus();
      return(false);

  }

  var parameters="gpcid="+gpcid+"&sq_counter="+sq_counter+"&qid="+qid+"&answer="+answer;

  http.open("POST", "save_sq_ajax.php", true)
  http.setRequestHeader("Content-type", "application/x-www-form-urlencoded")
  http.onreadystatechange = handle_save_sq;
  http.send(parameters);


}//endof


function handle_save_sq() {

  var results;

  if (http.readyState == 4) {

      //alert("response " + http.responseText) + "\n";

      $results = "<p style=\"color:red\"> Secret Question Saved</p>";

      document.getElementById('sq_container').innerHTML = http.responseText;

       

  }

}//endof






























function isNumber(inputVal) {
  var oneDecimal = false;
  inputStr = "" + inputVal;

  for (var i = 0; i < inputStr.length; i++) {
        var oneChar = inputStr.charAt(i);
        if (oneChar < "0" || oneChar > "9") {
            if (oneChar != ".") {
                 return(false);
            }
            if (inputStr.length == 1 && oneChar == ".") {
               return(false);
            }
        }
  }
        return(true);

}//endof





String.prototype.trim = function() {

  return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,"");

}

String.prototype.fulltrim = function() {

   return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,"").replace(/\s+/g," ");

}

function open_gpcidwin() {

  var gpcidurl = '/getmygpcid/index.php?GPCLook=NO';
  var gpcidwinname = 'gpcidwin';
  //left & top for IE, screenX & screenY for FF, NSC
  var gpcidargs = 'width=460,height=400,menubar=no,status=yes,location=no,toolbar=no,scrollbars=yes,left=450,top=200,screenX=400,screenY=400,resizable=yes';
  var popupWin;
  if (typeof(popupWin) != "object"){
      popupWin = window.open(gpcidurl,gpcidwinname,gpcidargs);
  } else {
     if (!popupWin.closed){
         popupWin.location.href = gpcidurl;
     } else {
         popupWin = window.open(gpcidurl,gpcidwinname,gpcidargs);
     }
  }
  popupWin.focus();
  return false;
}


function setgpcid( val ){

     document.getElementById('gpcid').value = val;

}


function getHTTPObject() {
  var xmlhttp;
  /*@cc_on
  @if (@_jscript_version >= 5)
    try {
      xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
      try {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
      } catch (E) {
        xmlhttp = false;
      }
    }
  @else
  xmlhttp = false;
  @end @*/

  if (!xmlhttp && typeof XMLHttpRequest != 'undefined') {
    try {
      xmlhttp = new XMLHttpRequest();
    } catch (e) {
      xmlhttp = false;
    }
  }
  return xmlhttp;
}
var http = getHTTPObject(); // We create the HTTP Object



function enable_country() {

   var s = document.getElementById('no_ssn').checked;

   if (s == true) { // use country
       document.getElementById('ssn4').style.background="#e0e0e0";
       document.getElementById('ssn4').value="";
       document.getElementById('ssn4').readOnly=true;
       document.getElementById('country').style.background="white";
       document.getElementById('country').disabled=false;
       document.getElementById('showCountry').style.display="inline";
       document.getElementById('showCountry1').style.display="inline";
       document.getElementById('showssn').style.display="none";
       document.getElementById('showssn1').style.display="none";
   } else {
       document.getElementById('ssn4').style.background="white";
       document.getElementById('ssn4').readOnly=false;
       document.getElementById('country').style.background="#e0e0e0";
       document.getElementById('country').selectedIndex = 0;
       document.getElementById('country').disabled=true;
       document.getElementById('showCountry').style.display="none";
       document.getElementById('showCountry1').style.display="none";
       document.getElementById('showssn').style.display="inline";
       document.getElementById('showssn1').style.display="inline";
   }


}//endof


function init_ssn_country() {

    document.getElementById('showCountry').style.display="none";
    document.getElementById('showCountry1').style.display="none";
    document.getElementById('showssn').style.display="inline";
    document.getElementById('showssn1').style.display="inline";


}//endof





</script>
<style type="text/css">

.test {
  color:green;
}

.work {
  border:0px solid #990033; 
  width:600;
  padding:10px; 

}

.work_notes {
  border:2px solid #C8C8C8;
  width:500;
  padding:10px; 

}

.work_notes_home {
  border:2px solid #C8C8C8;
  width:600;
  padding:10px; 

}

.status {
  border:3px double #990033; 
  width:600;
  height:20;
  padding:10px; 

}

.tr_work {
  background-color:#eaeaea;

}


.formbutton {

  cursor:pointer;
  border:outset 1px #ccc;
  background:#FFF;
  color:#990033;
  font-weight:normal;
  padding: 2px 2px;

}



</style>
<script type="text/javascript">

function validate() {



   var s = new String (document.getElementById("lname").value.fulltrim());

        if (s.length < 2) {
            alert("Last Name is a required field");
            document.getElementById("lname").focus();
            return(false);
        }

        document.getElementById("lname").value = s;


        if (document.getElementById('no_ssn').checked == false) {

            if (document.getElementById("ssn4").value.length != 4) {
                alert("Last 4 Digits of your SSN  is a required field");
                document.getElementById("ssn4").focus();
                return(false);
            }

            if (isNumber(document.getElementById("ssn4").value) == false) {
                alert("Last 4 Digits of your SSN  must be a Number");
                document.getElementById("ssn4").focus();
                return(false);
            }

        } else {

            var c = document.getElementById('country');

            if (c.selectedIndex == 0) {
                alert ("Country of citizenship is a required field if you do not have an SSN number.");
                c.focus();
                return false;
            }

        }


         var m = document.getElementById('month');
        
         if (m.selectedIndex == 0) {
             alert ("Please enter your Birth Month.");
             m.focus();
             return false;

         }


         var d = document.getElementById('day');
        
         if (d.selectedIndex == 0) {
             alert ("Please enter your Birth Day.");
             d.focus();
             return false;

         }


         var y = document.getElementById('year');
        
         if (y.selectedIndex == 0) {
             alert ("Please enter your Birth Year.");
             y.focus();
             return false;

         }



}//endof



String.prototype.trim = function() {

  return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,"");

}

String.prototype.fulltrim = function() {

   return this.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,"").replace(/\s+/g," ");

}
</script>

<!-- This page was created with a stripped down version of the GPC Look that -->
<!-- renders valid HTML with none of the graphic elements                    -->
<title>Get Your Panther Number Here! :: Georgia State University</title>
<script language="JavaScript" type="text/javascript">
   var origOpener =  self.opener;
   var origName   =  origOpener.name;

   function OpenerWatch() {
      // Watch for changes in the opener.name
      setTimeout( 'testOpener(origName)', 1000 );
   }

   function testOpener( strName ) {
      // If the opener reference is lost, close this window
      if( !self.opener || self.opener.closed ) {
         self.close();
      } else {
         OpenerWatch();
      }
   }
   
   function FillOutFields() {
      document.getElementById('month').value=new Date(Date.parse(window.opener.document.loginform.birth_month.value +" 1, 2012")).getMonth()+1;
      document.getElementById('day').value=window.opener.document.loginform.birth_day.value;
      document.getElementById('year').value=window.opener.document.loginform.birth_year.value;
      document.getElementById('ssn4').value=window.opener.document.loginform.stud_four_digits_ssn.value;
      document.getElementById('lname').value=window.opener.document.loginform.stud_last_name.value;
      document.getElementById('fname').value=window.opener.document.loginform.stud_first_name_three_letters.value;
   }
   
</script>
</head>
<body onLoad="OpenerWatch();FillOutFields();">
<script language="JavaScript" type="text/javascript">
<!-- Begin

// End -->
</script>

<form method="POST" action="getmypanthernumber.cfm" name="request_form" autocomplete="off" onsubmit="return validate();">
<!-- Text suppressed for popup mode --> 
  






<table border="0" width="450" cellpadding="5">
   <tr>
<td width="150" valign="top" style="padding-top:10px;">First 3 characters of First Name:</td>
<td width="300"><input type="input" name="fname" value="" id="fname" maxlength="3" size="3"><br/>

</td>
</tr>

<tr><td>  </td></tr>


<tr class="tr_work">
<td width="150" valign="top" style="padding-top:10px;">Last Name:</td>
<td width="300"><input type="input" name="lname" value="" id="lname"><br/>
<span class="note"><span style="color:red">Two last names?<br />Enter both without the hyphens<br />(Smith-Jones would be Smith&nbsp;Jones)</font></span></span>
</td>
</tr>

<tr><td>  </td></tr>


<tr>
<td><div id="showssn">Last 4 SSN digits</div></td>
<td><div id="showssn1"><input type="password" value=""  name="ssn1" id="ssn4" size="4" maxlength="4" autocomplete="off"></div></td>
</tr>


<tr>
<td colspan="2">I do not have (or wish to use) a Social Security Number (SSN)&nbsp; &nbsp;
<input type="checkbox" name="no_ssn" id="no_ssn"  onclick="enable_country();"> </td>
</tr>

<tr>
<td><div id="showCountry">Country of citizenship</div></td>
<td colspan="2">

	 <cfhttp url="https://webapp-qa.gpc.edu/gsuApiCode/country" method="POST" result="result" charset="utf-8" port="443" >
  <cfhttpparam name="Content-Type" value="application/x-www-form-urlencoded" type="header">
    <cfhttpparam name="Accept" value="application/json" type="header">
    <cfhttpparam type="body" value='{"authentication":{"api_key":"GSU783354110","api_pass":"A|7E>arpK.L8:qkAX$ab"}}'>
	</cfhttp>
<cfset getResult = deserializeJSON(result.filecontent)>

<div id="showCountry1">

<cfoutput>
	 <select name="country" id="country" disabled><option value=""></option>
	 <cfoutput>
	 <cfloop array="#getResult.Countries#" index="i">
				 <option value="#i.countryCode#">#i.countryName#</option>
	 </cfloop>
	 </cfoutput>
</select>
</cfoutput>

</div>
</td>
</tr>

<script type="text/javascript">
init_ssn_country();
</script>

<cfoutput>
<tr><td> </td></tr>

<tr class="tr_work">
<td>Date of Birth</td>
<td>
<select name="month" id="month">
<option selected value="">Month</option>
<cfloop index="x" from="1" to="12">
   <cfset curmonth=monthAsString(x)>
   <option value="#x#">#curmonth#</option>
</cfloop>
</select> - 
<select name="mday" id="day">
<option selected value="">Day</option>
<cfloop index="x" from="1" to="31">
   <cfset y="">
   <cfif x lt 10><cfset y="0"></cfif><cfset y=y&"#x#">
   <option value="#y#">#y#</option>
</cfloop>
</select> - 
<select name="year" id="year">
<option selected value="">Year</option>
<cfset firstyear=year(#NOW()#)-15>
<cfset lastyear=year(#NOW()#)-100>
<cfloop index="x" from="#firstyear#" to="#lastyear#" step="-1">
   <option>#x#</option>
</cfloop>
</select>
</td>
</tr>
 
<tr><td>&nbsp;  </td></tr>

<tr><td colspan="2" align="center">
<input class="formbutton" type="submit" value="Get My Panther Number" name="submit_gsuid_request">
 &nbsp; 
<input class="formbutton" type="reset" value="Reset Form">
</td></tr>
</table>
</center>
</cfoutput>
</body>
</html>

