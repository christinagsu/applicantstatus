<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>

<cfoutput>
<cfset origletter="Stocks on Thursday suffered the worst sell-off since the 2008 financial crisis. The Dow plunged 512 points on fears of a global economic slowdown,1111.  Interesting.">
<cfset myObject = createObject( "java", "ZipUtil" )>   
<cfset compressed_letter = myObject.compress( origletter ) >


<cftry>
<cfquery name="insertLetter" datasource="eAcceptance">
insert into SENT_LETTERS (appdate, appnum, appterm, letter_id,  letter_date, letter_order, letter_text) values (#NOW()#, 1, 201108, sequence_sentletters.NEXTVAL, #NOW()#, 1, <cfqueryparam value="#compressed_letter#">)
</cfquery>

<cfquery name="getLetter" datasource="eAcceptance">
select * from SENT_LETTERS where rownum<20 order by letter_id desc
</cfquery>

<cfdump var="#getLetter#">

<cfset myObject = createObject( "java", "ZipUtil" )>
<cfset decompressed_letter = myObject.decompress( getLetter.letter_text ) >
<DIV style="border-width:thin; border-style:solid; height:900px;padding:10px;">#decompressed_letter#</div>
<cfcatch>
#cfcatch.Detail# -> #cfcatch.Message#
</cfcatch>
</cftry>
</cfoutput>

</body>
</html>
