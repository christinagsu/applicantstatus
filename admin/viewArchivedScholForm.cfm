<cfquery name="getLetter" datasource="eAcceptance">
select * from scholarship_forms_archive where form_id=13
</cfquery>

<cfif getLetter.RecordCount eq 0>
<p>Sorry, this letter does not exist.</p><cfexit>
</cfif>

<!---<cfdocument format="pdf"  marginBottom="0" marginTop="0" marginLeft="0" marginRight="0" pagewidth="8.5" pageheight="11.75" pageType="custom">

<style type="text/css"> 
body{font-family:"Times New Roman", Times, serif; margin: 0px .3in 0px .3in; padding: 0px; font-size:14px;}
#letter p {margin-bottom: 18px; margin-top:0px; line-height:17px; }
#letter br {margin-bottom:0px; margin-top:0px; line-height:13px; }
#letter {margin-top:145px;margin-bottom:0px;}
</style>--->

<cfset myObject = createObject( "java", "ZipUtil" )>
<cfset decompressed_letter = myObject.decompress( getLetter.form_text ) >

<cfoutput><div id="letter">#decompressed_letter#</div></cfoutput>

<!---</cfdocument>--->