<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<title>PDF Loading</title>
<style>
    body {
        background-color: #666;
    }
</style>
</head>
<body>
<cfoutput>
<div style="background: transparent url(loading.png) no-repeat center;">
    <object height="800px" width="100%" type="application/pdf" data="sendLetters.cfm?try=#URL.try#">
        <param value="sendLetters.cfm?try=#URL.try#" name="src"/>
        <param value="transparent" name="wmode"/>
    </object>
</div>
</cfoutput>
</body>
</html>