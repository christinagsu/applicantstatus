<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>

<cfquery name="test" datasource="eAcceptance">
SELECT LETTER_ORDER, LETTER_TEXT FROM SENT_LETTERS WHERE PDF_UNIQUE_ID='64963794.89310524201103564728942996.3001' ORDER BY LETTER_ORDER
</cfquery>

<cfset myObject = createObject( "java", "ZipUtil" )>

<cfoutput query="test">
	<cfset letter = myObject.decompress( letter_text ) >
	#letter#<br />________________________________________________________________________________________<br />
</cfoutput>

</body>
</html>
