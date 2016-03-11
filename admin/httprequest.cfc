<cfcomponent name="httprequest">
 <cffunction name="init" access="remote" returntype="struct" output="no">
  <cfargument name="pass_url" type="any">
  <cfargument name="pass_cookie" type="string">
  <cfargument name="pass_variables" type="array" >
  <cfargument name="pass_httpuseragent" type="string" default="Mozilla/5.0 (Windows; U; Windows NT 6.1; nl; rv:1.9.2.28) Gecko/20120306 Firefox/3.6.28">
  <cfargument name="pass_httphost" type="string" >
  <cfargument name="pass_httpport" type="string" >
  <cfargument name="pass_debug" type="boolean" >
  <cfargument name="pass_autoredirect" type="boolean">
  <cfargument name="pass_remember_cookie" type="any" default="">
  <cfargument name="pass_referer" default="">
  <cfset var websitedata = '' />
  <cfset var i = '' />

  <cfset websitedata=structnew()>
  <cfset websitedata.timer = structNew()>
  <cfset websitedata.timer.init = gettickcount()>
  
  <!--- Save get parameters to Array ---->
  <cfset var send_getParameters = arrayNew(2)>
  <cfloop from=1 to=#arrayLen(pass_variables)# index="i">
   <cfif #pass_variables[i][3]# eq 'url'>
    <cfset send_getParameters[evaluate(arraylen(send_getParameters)+1)][1] = pass_variables[i][1]>
    <cfset send_getParameters[arraylen(send_getParameters)][2] = pass_variables[i][2]>
   </cfif>
  </cfloop>
  <!--- End get parameters to Array ---->

  <!--- Save post parameters to Array ---->
  <cfset var send_postParameters = arrayNew(2)>
  <cfloop from=1 to=#arrayLen(pass_variables)# index="i">
   <cfif #pass_variables[i][3]# eq 'formfield'>
    <cfset send_postParameters[evaluate(arraylen(send_postParameters)+1)][1] = pass_variables[i][1]>
    <cfset send_postParameters[arraylen(send_postParameters)][2] = pass_variables[i][2]>
   </cfif>
  </cfloop>
  <!--- End post parameters to Array ---->

  <!--- Save RequestProperties parameters to Array ---->
  <cfset var send_requestsParameters = arrayNew(2)>
  <cfloop from=1 to=#arrayLen(pass_variables)# index="i">
   <cfif #pass_variables[i][3]# eq 'setRequestProperty'>
    <cfset send_requestsParameters[evaluate(arraylen(send_requestsParameters)+1)][1] = pass_variables[i][1]>
    <cfset send_requestsParameters[arraylen(send_requestsParameters)][2] = pass_variables[i][2]>
   </cfif>
  </cfloop>
  <!--- End post parameters to Array ---->

  <!--- Save cookies to Array ---->
  <cfset var send_cookies = arrayNew(2)>
  <cfloop from=1 to=#arrayLen(pass_variables)# index="i">
   <cfif #pass_variables[i][3]# eq 'cookie'>
    <cfset send_cookies[evaluate(arraylen(send_cookies)+1)][1] = pass_variables[i][1]>
    <cfset send_cookies[arraylen(send_cookies)][2] = pass_variables[i][2]>
   </cfif>
  </cfloop>
  <cfloop from=1 to="#listlen(pass_remember_cookie,chr(1000))#" index="i">
   <cfset founditem="#listgetat(pass_remember_cookie,i,chr(1000))#">
   <cfset send_cookies[evaluate(arraylen(send_cookies)+1)][1]  = #left(founditem,find('=',founditem)-1)#>
   <cfset send_cookies[arraylen(send_cookies)][2]  = #founditem#>
  </cfloop>
  <!--- End save cookies to Array ---->



  <cfsavecontent variable="httpRequest">
  <cfoutput>
  <cfinvoke method="connect" returnvariable="objectHTTP">
   <cfinvokeargument name="in_url" value="#pass_url#">
   <cfinvokeargument name="in_max_redirects" value="5">
   <cfinvokeargument name="in_UserAgent" value="#pass_httpuseragent#">
   <cfinvokeargument name="in_ProxyPort" value="#pass_httpport#">
   <cfinvokeargument name="in_ProxyHost" value="#pass_httphost#">
   <cfinvokeargument name="in_Cookies" value="#SerializeJSON(send_cookies,true)#">
   <cfinvokeargument name="in_getParameters" value="#SerializeJSON(send_getParameters,true)#">
   <cfinvokeargument name="in_postParameters" value="#SerializeJSON(send_postParameters,true)#">
   <cfinvokeargument name="in_requestParameters" value="#SerializeJSON(send_requestsParameters,true)#">
   <cfloop from=1 to=#arrayLen(pass_variables)# index="i">
    <cfif #pass_variables[i][3]# eq 'setRequestProperty'>
     <cfinvokeargument name="in_#replace(pass_variables[i][1],'-','','all')#" value="#pass_variables[i][2]#">
    </cfif>
   </cfloop>
  </cfinvoke>
  </cfoutput>
  </cfsavecontent>

  <cfset var args = structNew()>
  <cfset args.in_url = pass_url>
  <cfset args.in_max_redirects = 5>
  <cfset args.in_UserAgent = pass_httpuseragent>
  <cfset args.in_ProxyPort = pass_httpport>
  <cfset args.in_ProxyHost = pass_httphost>
  <cfset args.in_Cookies = send_cookies>
  <cfset args.in_getParameters = send_getParameters>
  <cfset args.in_postParameters = send_postParameters>
  <cfset args.in_requestParameters =send_requestsParameters>
  <cfloop from=1 to=#arrayLen(pass_variables)# index="i">
   <cfif #pass_variables[i][3]# eq 'setRequestProperty'>
    <cfset args["in_#replace(pass_variables[i][1],'-','','all')#"] =  #pass_variables[i][2]#>
   </cfif>
  </cfloop>

  <cfset objectHTTP = connect(argumentCollection=args)>

  <cfset websitedata.mimeType = #objectHTTP.mimeType#>
  <cfset websitedata.header = #objectHTTP.header#>
  <cfset websitedata.requestheader = #objectHTTP.requestheader#>
  <cfset websitedata.responseheader = #objectHTTP.responseheader#>
  <cfset websitedata.responseBody = #rereplace(objectHTTP.fileContent,'[^\x09-\xFF]',' ','all')#>
  <cfset websitedata.status = #left(objectHTTP.statuscode,3)#>
  <cfset websitedata.httpRequest = #httpRequest#>
  <cfset websitedata.CONNECTION  = objectHTTP.connection>
  <cftry>
   <cfset websitedata.cookies = #objectHTTP.ResponseHeader["Set-Cookie"]#>
   <cfcatch type="any"><cfset websitedata.cookies = ""></cfcatch>
  </cftry>

  <cfset websitedata.uri = #pass_url#>
  <cfset websitedata.charSet = #objectHTTP.charSet#>
  <cfset websitedata.errors = #objectHTTP.errors#>
  <cfset websitedata.timer.connect = objectHTTP.timing>
  <cfset websitedata.timer.end = gettickcount()>
  <cfreturn websitedata>
 </cffunction>

 <cffunction name="connect">
  <cfargument type="string" name="in_url" required="yes">
  <cfargument type="array" name="in_getParameters" required="no" default="#arrayNew(2)#" hint="Get variables url not encoded">
  <cfargument type="array" name="in_postParameters" required="no" default="#arrayNew(2)#" hint="Post variables url not encoded">
  <cfargument type="array" name="in_requestParameters" required="no" default="#arrayNew(2)#" hint="Request variables url">
  <cfargument type="array" name="in_Cookies" required="no" default="#arrayNew(2)#" hint="Post cookies url not encoded">
  <cfargument type="string" name="in_max_redirects" required="no" default="5">
  <cfargument type="string" name="in_requestMethod" required="no" default="GET">
  <cfargument type="string" name="in_Accept" required="no" default="*/*">
  <cfargument type="string" name="in_ContentType" required="no" default="application/x-www-form-urlencoded">
  <cfargument type="string" name="in_AcceptEncoding" required="no" default="gzip, x-gzip, identity, *;q=0">
  <cfargument type="string" name="in_AcceptCharset" required="no" default="ISO-8859-1,utf-8;q=0.7,*;q=0.7">
  <cfargument type="string" name="in_AcceptLanguage" required="no" default="nl,en-us;q=0.7,en;q=0.3">
  <cfargument type="string" name="in_UserAgent" required="no" default="Mozilla/5.0 (Windows; U; Windows NT 6.1; nl; rv:1.9.2.28) Gecko/20120306 Firefox/3.6.28">
  <cfargument type="string" name="in_CacheControl" required="no" default="no-cache">
  <cfargument type="string" name="in_ConnectTimeout" required="no" default="15000">
  <cfargument type="string" name="in_ReadTimeout" required="no" default="15000">
  <cfargument type="string" name="in_ProxyPort" required="no" default="">
  <cfargument type="string" name="in_ProxyHost" required="no" default="">
  <cfargument type="boolean" name="in_RememberRedirectedCookies" required="no" default="true">
  <cfargument type="string" name="out_Charset" required="no" default="UTF-8">

  <!--- Set local variables --->
   <cfset var local_results = structNew()>
   <cfset var local_i = 0>
   <cfset var local_j = 0>
   <Cfset var local_current_redirect = 0>
   <Cfset var local_current_redirect_including_charset = 0>
   <Cfset var local_PostVariables = "">
   <Cfset var local_Cookies = "">
   <Cfset var local_JavaEncoder = createObject("java","java.net.URLEncoder")>
 
   <Cfset var local_RedirectCookiesAsString = "">
   <Cfset var local_RedirectCookiesAsArray = arrayNew(2)>

   <cfset var local_timer = arrayNew(2)>
   <cfset var local_timer_temp = gettickcount()>
   <cfset var local_redirectBasesOnWrongCharset = false>
   <cfset var local_System = createObject("java", "java.lang.System").getProperties()>

  <!--- End set local variables --->

  <cfset local_timer_temp = gettickcount()>

  <!--- Set defaults  --->

   <cfif in_requestMethod eq ""><cfset in_requestMethod="GET"></cfif>
   <cfif in_Accept eq ""><cfset in_Accept="*/*"></cfif>
   <cfif in_ContentType eq ""><cfset in_ContentType="application/x-www-form-urlencoded"></cfif>
   <cfif in_AcceptEncoding eq ""><cfset in_AcceptEncoding="gzip, x-gzip, identity, *;q=0"></cfif>
   <cfif in_AcceptCharset eq ""><cfset in_AcceptCharset="ISO-8859-1,utf-8;q=0.7,*;q=0.7"></cfif>
   <cfif in_AcceptLanguage eq ""><cfset in_AcceptLanguage="nl,en-us;q=0.7,en;q=0.3"></cfif>
   <cfif in_UserAgent eq ""><cfset in_UserAgent="Mozilla/5.0 (Windows; U; Windows NT 6.1; nl; rv:1.9.2.28) Gecko/20120306 Firefox/3.6.28"></cfif>
   <cfif in_CacheControl eq ""><cfset in_CacheControl="no-cache"></cfif>
   <cfif in_ConnectTimeout eq ""><cfset in_ConnectTimeout="15000"></cfif>
   <cfif in_ReadTimeout eq ""><cfset in_ReadTimeout="15000"></cfif>
   <cfif in_ProxyPort eq ""><cfset in_ProxyPort=""></cfif>
   <cfif in_ProxyHost eq ""><cfset in_ProxyHost=""></cfif>
   <cfif arraylen(in_postParameters) neq 0><cfset in_requestMethod = "POST"></cfif>
  <!--- End set defaults  --->
  
  <!--- Set get variables --->
   <cfloop from=1 to="#arraylen(in_getParameters)#" index="i">
    <cfif i eq 1><cfset in_url = "#in_url#?"></cfif>
    <cfif i gt 1><cfset in_url = "#in_url#&"></cfif>
    <cfset in_url = "#in_url##in_getParameters[i][1]#=#trim(local_JavaEncoder.encode(in_getParameters[i][2],"utf-8"))#">
   </cfloop>
  <!--- End set get variables --->

  <!--- Set post variables --->
   <cfloop from=1 to="#arraylen(in_postParameters)#" index="i">
    <cfif i gt 1><cfset local_PostVariables = "#local_PostVariables#&"></cfif>
    <cfset local_PostVariables = "#local_PostVariables##in_postParameters[i][1]#=#trim(local_JavaEncoder.encode(in_postParameters[i][2],"utf-8"))#">
   </cfloop>
  <!--- End set post variables --->

  <!--- Set cookies --->
   <cfloop from=1 to="#arraylen(in_Cookies)#" index="i">
    <cfif i gt 1><cfset local_Cookies = "#local_Cookies#;"></cfif>
    <cfset local_Cookies = "#local_Cookies##in_Cookies[i][1]#=#trim(local_JavaEncoder.encode(in_Cookies[i][2],"utf-8"))#">
   </cfloop>
  <!--- End set cookies --->

  <cfset in_max_redirects = in_max_redirects -1>

  <!--- Set default output variables --->
   <cfset local_timer_temp = gettickcount()>
   <cfset local_results.CHARSET = "UTF-8">
   <cfset local_results.HEADER = "">
   <cfset local_results.MIMETYPE = "">
   <cfset local_results.CONNECTION = structNew()>
   <cfset local_results.CONNECTION.REDIRECTED = false>
   <cfset local_results.CONNECTION.REDIRECT_TIMES = 0>
   <cfset local_results.CONNECTION.REQUESTS = arrayNew(1)>
   <cfset local_results.CONNECTION.URL_START = in_url>
   <cfset local_results.CONNECTION.URL_END = in_url>

   <cfset local_results.REQUESTHEADER  = structNew()>
   <cfset local_results.RESPONSEHEADER = structNew()>
   <cfset local_results.STATUSCODE = "">
   <cfset local_results.FILECONTENT = "">
   <cfset local_results.ERRORS = structNew()>
   <cfset local_results.SUCCESS = true>
  <!--- End set default output variables --->

  <cfset local_timer[arraylen(local_timer)+1][1] = "Set variables">
  <cfset local_timer[arraylen(local_timer)][2] = gettickcount()-local_timer_temp>

  <cftry>
  <!--- Build connection --->
   <cfset var local_Url = createObject("java", "java.net.URL")>
   <cfif in_ProxyPort neq '' or in_ProxyHost neq ''>
    <cfif in_ProxyHost neq ''><cfset local_System.setProperty("http.proxyHost","#in_ProxyHost#")></cfif>
    <cfif in_ProxyPort neq ''><cfset local_System.setProperty("http.proxyPort","#in_ProxyPort#")></cfif>
   </cfif>
   <cfset var local_Connection = createObject("java", "java.net.HttpURLConnection")>
   <cfloop condition="local_current_redirect lte in_max_redirects and local_current_redirect_including_charset lt 10">

    <cfset local_timer_temp = gettickcount()>

    <cfset local_Url.init(in_url)>
    <cfset local_Connection = local_Url.openConnection()>
    <cfset local_Connection.setConnectTimeout(JavaCast("int",in_ConnectTimeout))>
    <cfset local_Connection.setReadTimeout(JavaCast("int",in_ReadTimeout))>
    <cfset local_Connection.setRequestMethod(in_requestMethod)>
    <cfset local_Connection.setFollowRedirects(true)>
    <cfset local_Connection.setDoInput(true)>
    <cfif local_PostVariables neq ''><cfset local_Connection.setDoOutput(true)></cfif>
    <cfset local_Connection.setRequestProperty("Accept", in_Accept)>
    <cfset local_Connection.setRequestProperty("Content-Type", in_ContentType)>
    <cfset local_Connection.setRequestProperty("Accept-Encoding", in_AcceptEncoding)>
    <cfset local_Connection.setRequestProperty("Accept-Charset", in_AcceptCharset)>
    <cfset local_Connection.setRequestProperty("Accept-Language",in_AcceptLanguage)>
    <cfset local_Connection.setRequestProperty("User-Agent",in_UserAgent)>
    <cfset local_Connection.setRequestProperty("Cache-Control", in_CacheControl)>
    <cfset local_Connection.setRequestProperty("Cookie", local_Cookies)>

    <cfif local_current_redirect eq 0>
     <cfloop from=1 to="#arraylen(in_requestParameters)#" index="i">
      <cfset local_Connection.setRequestProperty("#in_requestParameters[i][1]#", in_requestParameters[i][2])>
     </cfloop>
    </cfif>


    <cfset local_Connection.setInstanceFollowRedirects(false)>

    <cfset local_results.url = local_Connection.getURL().toString()>

    <!--- Get request headers --->
    <cfset var local_RequestHeadersStruc = structNew()>
    <cfset var local_RequestHeadersArrayNew = arrayNew(2)>
    <cfset var local_RequestHeadersArrayOriginal = local_Connection.getRequestProperties().entrySet().toArray()>

    <cfloop from=1 to="#arraylen(local_RequestHeadersArrayOriginal)#" index="i">
     <Cfif not isnull(local_RequestHeadersArrayOriginal[i].getKey())>
      <cfset local_RequestHeadersArrayNew[i][1]  = local_RequestHeadersArrayOriginal[i].getKey()>
      <cfloop from=1 to="#arrayLen(local_RequestHeadersArrayOriginal[i].getValue())#" index="j"><cfset local_RequestHeadersArrayNew[i][j+1]  = local_RequestHeadersArrayOriginal[i].getValue()[j]></cfloop>
     <cfelse>
      <cfset local_RequestHeadersArrayNew[i][1]  = "">
      <cfloop from=1 to="#arrayLen(local_RequestHeadersArrayOriginal[i].getValue())#" index="j"><cfset local_RequestHeadersArrayNew[i][j+1]  = local_RequestHeadersArrayOriginal[i].getValue()[j]></cfloop>
     </cfif>
    </cfloop>
    <cfloop from=1 to="#arraylen(local_RequestHeadersArrayNew)#" index="i">
     <cfif arraylen(local_RequestHeadersArrayNew[i]) eq 2>
      <cfset local_RequestHeadersStruc[local_RequestHeadersArrayNew[i][1]] = local_RequestHeadersArrayNew[i][2]>
     <cfelse>
      <cfset local_ResponseHeadersStruc[local_RequestHeadersArrayNew[i][1]] = structNew()>
      <cfloop from=1 to="#arraylen(local_RequestHeadersArrayNew[i])#" index="j">
       <Cftry><cfset local_RequestHeadersStruc[local_RequestHeadersArrayNew[i][1]][""&j&""] = local_RequestHeadersArrayNew[i][j+1]><cfcatch type="any"></cfcatch></cftry>
      </cfloop>
     </cfif>
    </cfloop>
    <!--- <cfset results.requestHeader_asArray = local_RequestHeadersArrayNew> --->
    <!--- End get request headers --->

    <!--- Post post variables --->
    <cfif local_PostVariables neq ''>
     <cfset var local_uploadStream = local_Connection.getOutputStream() />
     <cfset var local_uploadWriter = createObject( "java", "java.io.OutputStreamWriter" ).init(local_uploadStream) />
     <cfset local_uploadWriter.write(javaCast( "string", (local_PostVariables) )) />
     <cfset local_uploadWriter.close() />
    </cfif>
    <!--- End post post variables --->

    <!--- Store get variables in structure to return --->
    <cfset local_RequestHeadersStruc.urlVariables = structNew()>
    <cfloop from=1 to="#arraylen(in_getParameters)#" index="i">
     <cfset local_RequestHeadersStruc.urlVariables[""&i&""] = structNew()>
     <cfset local_RequestHeadersStruc.urlVariables[""&i&""].name = "#in_getParameters[i][1]#">
     <cfset local_RequestHeadersStruc.urlVariables[""&i&""].value =  "#in_getParameters[i][2]#">
    </cfloop>
    <!--- End store get variables in structure to return --->

    <!--- Store post variables in structure to return --->
    <cfset local_RequestHeadersStruc.postVariables = structNew()>
    <cfloop from=1 to="#arraylen(in_postParameters)#" index="i">
     <cfset local_RequestHeadersStruc.postVariables[""&i&""] = structNew()>
     <cfset local_RequestHeadersStruc.postVariables[""&i&""].name = "#in_postParameters[i][1]#">
     <cfset local_RequestHeadersStruc.postVariables[""&i&""].value =  "#in_postParameters[i][2]#">
    </cfloop>
    <!--- End store post variables in structure to return --->
 
    <!--- Store cookies in structure to return --->
    <cfset local_RequestHeadersStruc.Cookies = structNew()>
    <cfloop from=1 to="#arraylen(in_Cookies)#" index="i">
     <cfset local_RequestHeadersStruc.Cookies[""&i&""] = structNew()>
     <cfset local_RequestHeadersStruc.Cookies[""&i&""].name = "#in_Cookies[i][1]#">
     <cfset local_RequestHeadersStruc.Cookies[""&i&""].value =  "#in_Cookies[i][2]#">
    </cfloop>
    <!--- Stop store cookies in structure to return --->
    <cfset local_RequestHeadersStruc.requestMethod = in_requestMethod>
    <cfset local_results.requestHeader = local_RequestHeadersStruc>

    <cfset local_timer[arraylen(local_timer)+1][1] = "Set request">
    <cfset local_timer[arraylen(local_timer)][2] = gettickcount()-local_timer_temp>

    <!--- Get response headers --->
    <cfset local_timer_temp = gettickcount()>
    <cfset var local_ResponseHeadersStruc = structNew()>
    <cfset var local_ResponseHeadersString = "">
    <cfset var local_ResponseHeadersArrayNew= arrayNew(2)>
    <cfset var local_ResponseHeadersArrayOriginal = local_Connection.getHeaderFields().entrySet().toArray()>
 
    <cfloop from=1 to="#arraylen(local_ResponseHeadersArrayOriginal)#" index="i">
     <Cfif not isnull(local_ResponseHeadersArrayOriginal[i].getKey())>
      <cfset local_ResponseHeadersString = "#local_ResponseHeadersString##local_ResponseHeadersArrayOriginal[i].getKey()#: ">
      <cfset local_ResponseHeadersArrayNew[i][1]  = local_ResponseHeadersArrayOriginal[i].getKey()>
      <cfloop from=1 to="#arrayLen(local_ResponseHeadersArrayOriginal[i].getValue())#" index="j"><cfset local_ResponseHeadersString = "#local_ResponseHeadersString##local_ResponseHeadersArrayOriginal[i].getValue()[j]# "><cfset local_ResponseHeadersArrayNew[i][j+1]  = local_ResponseHeadersArrayOriginal[i].getValue()[j]></cfloop>
     <cfelse>
      <cfset local_ResponseHeadersArrayNew[i][1]  = "">
      <cfloop from=1 to="#arrayLen(local_ResponseHeadersArrayOriginal[i].getValue())#" index="j"><cfset local_ResponseHeadersString = "#local_ResponseHeadersString##local_ResponseHeadersArrayOriginal[i].getValue()[j]# "><cfset local_ResponseHeadersArrayNew[i][j+1]  = local_ResponseHeadersArrayOriginal[i].getValue()[j]></cfloop>
     </cfif>
    </cfloop>

    <cfloop from=1 to="#arraylen(local_ResponseHeadersArrayNew)#" index="i">
     <cfif arraylen(local_ResponseHeadersArrayNew[i]) eq 2 and not local_ResponseHeadersArrayNew[i][1] eq 'Set-Cookie'>
      <cfset local_ResponseHeadersStruc[local_ResponseHeadersArrayNew[i][1]] = local_ResponseHeadersArrayNew[i][2]>
     <cfelse>
      <cfset local_ResponseHeadersStruc[local_ResponseHeadersArrayNew[i][1]] = structNew()>
      <cfloop from=1 to="#arraylen(local_ResponseHeadersArrayNew[i])#" index="j">
       <Cftry><cfset local_ResponseHeadersStruc[local_ResponseHeadersArrayNew[i][1]][""&j&""] = local_ResponseHeadersArrayNew[i][j+1]><cfcatch type="any"></cfcatch></cftry>
      </cfloop>
     </cfif>
    </cfloop>

    <cfset local_results.CONNECTION.REQUESTS[arrayLen(local_results.CONNECTION.REQUESTS)+1] = structNew()>
    <cfset local_results.CONNECTION.REQUESTS[arrayLen(local_results.CONNECTION.REQUESTS)].URL = in_url>
    <cfset local_results.CONNECTION.REQUESTS[arrayLen(local_results.CONNECTION.REQUESTS)].COOKIES = local_Cookies>
    <cfif StructKeyExists(local_results.RESPONSEHEADER, "Set-Cookie")>
     <cfset local_results.CONNECTION.REQUESTS[arrayLen(local_results.CONNECTION.REQUESTS)].COOKIES= #local_results.RESPONSEHEADER["Set-Cookie"]#>
    </cfif>
    <cfset local_results.CONNECTION.REQUESTS[arrayLen(local_results.CONNECTION.REQUESTS)].REQUEST_HEADER = local_RequestHeadersStruc>
    <cfset local_results.CONNECTION.REQUESTS[arrayLen(local_results.CONNECTION.REQUESTS)].RESPONSE_HEADER = local_ResponseHeadersStruc>

 
    <cfset local_results.header = local_ResponseHeadersString>
    <cfset local_results.responseHeader = local_ResponseHeadersStruc>
    <cfset local_timer[arraylen(local_timer)+1][1] = "Get url header">
    <cfset local_timer[arraylen(local_timer)][2] = gettickcount()-local_timer_temp>
    <!--- End get response headers --->
 
    <!--- Get CHARSET AND MIMETYPE --->
    <cfset local_timer_temp = gettickcount()>
    <Cfset var mimetype = local_Connection.getContentType()>
    <cftry><cfif find('charset=',mimetype) gt 0 and not local_redirectBasesOnWrongCharset><cfset local_results.Charset = rereplace(mimetype,'.*?charset=(.*)','\1','one')><Cfelseif not local_redirectBasesOnWrongCharset><cfset local_results.Charset ='UTF-8'></cfif><cfcatch type="any"><cfset local_results.Charset ='UTF-8'></cfcatch></cftry>
    <cftry><cfset local_results.Mimetype = rereplace(mimetype,'(.*?);.*','\1','one')><cfcatch type="any"></cfcatch></cftry>
    <cfset local_timer[arraylen(local_timer)+1][1] = "Get url charset and mimetype: #local_results.Charset#">
    <cfset local_timer[arraylen(local_timer)][2] = gettickcount()-local_timer_temp>
    <!--- End Get CHARSET AND MIMETYPE --->

    <!--- Get response body --->
    <cfif not (local_Connection.getResponseCode() eq local_Connection.HTTP_MOVED_PERM OR local_Connection.getResponseCode() eq local_Connection.HTTP_MOVED_TEMP OR local_Connection.getResponseCode() EQ local_Connection.HTTP_SEE_OTHER)>
     <cfset var local_ResponseBody = "">
      <cfif local_Connection.getContentEncoding() neq "" && (local_Connection.getContentEncoding().equalsIgnoreCase("gzip") || local_Connection.getContentEncoding().equalsIgnoreCase("x-gzip"))>
      <cfset var local_BufferedReader = createObject("java","java.io.BufferedReader").init(CreateObject( "JAVA", "java.io.InputStreamReader" ).init( createObject("java", "java.util.zip.GZIPInputStream").init(local_Connection.getInputStream()),local_results.Charset))>
     <cfelse>
      <cfset var local_BufferedReader = createObject("java","java.io.BufferedReader").init(CreateObject( "JAVA", "java.io.InputStreamReader" ).init( local_Connection.getInputStream(),local_results.Charset))>
     </cfif>
  
     <cfset var local_line="">
     <cfset var local_lineCheck = false>
 
     <cfset local_line = local_BufferedReader.readLine()>
     <cfset local_lineCheck = isDefined("local_line")>

     <cfset var local_stringbldr = createObject("java", "java.lang.StringBuilder").init()>
     <cfloop condition="#isDefined("local_line")#">
      <cfset local_stringbldr.append("#local_line##chr(13)##chr(10)#")>
      <cfset local_line = local_BufferedReader.readLine()>
     </cfloop> 
     <cfset local_ResponseBody = local_stringbldr.toString()>
     <Cfset local_BufferedReader.close()>
 
     <cfset local_results.Filecontent = local_ResponseBody>
     <cfset local_timer[arraylen(local_timer)+1][1] = "Get url body">
     <cfset local_timer[arraylen(local_timer)][2] = gettickcount()-local_timer_temp>
     <!--- End get response body --->

     <!--- check if wrong charset is used --->
     <cfset local_redirectBasesOnWrongCharset = false>
     <cfif refind("<meta(?!\s*(?:name|value)\s*=)[^>]*?charset\s*=[\s""']*([^\s""'/>]*)",local_ResponseBody) gt 0>
      <cfif local_results.Charset neq rereplacenocase(local_ResponseBody,".*<meta(?!\s*(?:name|value)\s*=)[^>]*?charset\s*=[\s""']*([^\s""'/>]*)(.*)","\1","one")>
       <cfset local_results.Charset = ucase(rereplacenocase(local_ResponseBody,".*<meta(?!\s*(?:name|value)\s*=)[^>]*?charset\s*=[\s""']*([^\s""'/>]*)(.*)","\1","one"))>
       <cfset local_redirectBasesOnWrongCharset = true>
      </cfif>
     </cfif>
     <!--- End check if wrong charset is used --->
    </cfif>

    <!--- Check if redirection is necessary --->
    <cfif (local_Connection.getResponseCode() eq local_Connection.HTTP_MOVED_PERM OR local_Connection.getResponseCode() eq local_Connection.HTTP_MOVED_TEMP OR local_Connection.getResponseCode() EQ local_Connection.HTTP_SEE_OTHER OR local_redirectBasesOnWrongCharset)>
     <cfif not local_redirectBasesOnWrongCharset>
      <cfif refind('^.{2,5}://',local_Connection.getHeaderField("Location")) eq 0><cfset in_url = local_Url.getProtocol() & "://" & local_Url.getHost() & local_Connection.getHeaderField("Location")>
      <Cfelse><cfset in_url = local_Connection.getHeaderField("Location")></cfif>
      <cfset local_results.Statuscode = "#local_Connection.getResponseCode()# #local_Connection.getResponseMessage()#">
      <cfset local_results.URL = in_url>
      <cfset local_results.CONNECTION.REDIRECTED = true>
      <cfset local_results.CONNECTION.REDIRECT_TIMES = local_current_redirect+1>
      <cfset local_results.CONNECTION.REDIRECT_URL[""&local_current_redirect+1&""] = in_url>
      <cfset local_results.CONNECTION.URL_END = in_url>

      <cfif StructKeyExists(local_results.RESPONSEHEADER, "Set-Cookie")>
       <cfloop collection="#local_results.RESPONSEHEADER["Set-Cookie"]#" item="key">
        <cfset var local_cookie_name = "#rereplace(local_results.RESPONSEHEADER["Set-Cookie"][key],'^(.*?)=.*','\1','one')#">
        <cfset var local_cookie_value = "#rereplace(local_results.RESPONSEHEADER["Set-Cookie"][key],'^.*?=(.*?)(;.*|$)','\1','one')#">
        <cfset var local_cookie_found = false>

        <cfloop from=1 to=#arrayLen(in_Cookies)# index="j">
         <cfif in_Cookies[j][1] eq local_cookie_name>
          <cfset in_Cookies[j][2] = local_cookie_value>
          <cfset local_cookie_found = true>
          <cfbreak>
         </cfif>
        </cfloop>

        <cfif not local_cookie_found>
         <cfset in_Cookies[#evaluate(arrayLen(in_Cookies)+1)#][1] = local_cookie_name>
         <cfset in_Cookies[#arrayLen(in_Cookies)#][2] = local_cookie_value>
        </cfif>

        <cfloop from=1 to=#arrayLen(local_RedirectCookiesAsArray)# index="j">
         <cfif in_Cookies[j][1] eq local_cookie_name>
          <cfset local_RedirectCookiesAsArray[j][1] = local_cookie_name>
          <cfset local_RedirectCookiesAsArray[j][2] = local_results.RESPONSEHEADER["Set-Cookie"][key]>
         <cfelseif j eq arrayLen(local_RedirectCookiesAsArray)> 
          <cfset local_RedirectCookiesAsArray[j+1][1] = local_cookie_name>
          <cfset local_RedirectCookiesAsArray[j+1][2] = local_results.RESPONSEHEADER["Set-Cookie"][key]>
         </cfif>
        </cfloop>
        <cfif arrayLen(local_RedirectCookiesAsArray) eq 0>
         <cfset local_RedirectCookiesAsArray[1][1] = local_cookie_name>
         <cfset local_RedirectCookiesAsArray[1][2] = local_results.RESPONSEHEADER["Set-Cookie"][key]>
        </cfif>
       </cfloop>
       <!--- Set cookies --->
       <cfloop from=1 to="#arraylen(in_Cookies)#" index="i">
        <cfif i gt 1><cfset local_Cookies = "#local_Cookies#;"></cfif>
        <cfset local_Cookies = "#local_Cookies##in_Cookies[i][1]#=#trim(urldecode(local_JavaEncoder.encode(in_Cookies[i][2],"utf-8")))#">
       </cfloop>
       <!--- End set cookies --->
      </cfif>
     </cfif>
     <cfset local_Connection.disconnect()> 
    <cfelse>
     <cfset local_results.Statuscode = "#local_Connection.getResponseCode()# #local_Connection.getResponseMessage()#">
     <cfset local_results.URL = in_url>
     <cfset local_results.CONNECTION.REDIRECT_TIMES = local_current_redirect>
     <cfset local_Connection.disconnect()> 
     <Cfbreak>
    </cfif>
    <!--- End check if redirection is necessary --->
 
    <cfif not local_redirectBasesOnWrongCharset><Cfset local_current_redirect = local_current_redirect + 1></cfif>
    <Cfset local_current_redirect_including_charset = local_current_redirect_including_charset + 1>
   </cfloop>
  <!--- End build connection --->
   <cfcatch type="any">
    <cfset local_results.ERRORS.MESSAGE = cfcatch.message>
    <cftry><cfset local_results.ERRORS.TYPE = cfcatch.Type><cfcatch type="any"></cfcatch></cftry>
    <cftry><cfset local_results.ERRORS.StackTrace = cfcatch.StackTrace><cfcatch type="any"></cfcatch></cftry>
    <cftry><cfset local_results.ERRORS.TagContext = cfcatch.TagContext><cfcatch type="any"></cfcatch></cftry>
    <cfset local_results.success= false>
    <cftry><cfset local_results.Statuscode = "#local_Connection.getResponseCode()# #local_Connection.getResponseMessage()#"><cfcatch type="any"></cfcatch></cftry>
    <cftry><cfset local_Connection.disconnect()> <cfcatch type="any"></cfcatch></cftry>
   </cfcatch>
  </cftry>
 
  <cfif in_ProxyPort neq '' or in_ProxyHost neq ''>
   <cfset var local_system = createObject("java", "java.lang.System")>
       <cfif in_ProxyHost neq ''><cfset local_system.clearProperty("http.proxyHost")></cfif>
      <cfif in_ProxyPort neq ''><cfset local_system.clearProperty("http.proxyPort")></cfif>
  </cfif>

  <cfif in_RememberRedirectedCookies>
   <cfif not StructKeyExists(local_results.RESPONSEHEADER, "Set-Cookie")>
    <cfset local_results.RESPONSEHEADER["Set-Cookie"] = structNew()>
   </cfif>
   <Cfset var local_count_keys = 0>
   <cftry><cfloop collection="#local_results.RESPONSEHEADER["Set-Cookie"]#" item="key"><cfset local_count_keys = local_count_keys+1></cfloop>
    <cfcatch type="any">
     <cfif not IsStruct(local_results.RESPONSEHEADER["Set-Cookie"])>
      <cfif local_results.RESPONSEHEADER["Set-Cookie"] neq ''><cfset local_count_keys = local_count_keys+1></cfif>
     </cfif>
    </cfcatch>
   </cftry>

   <cfloop from=1 to="#arrayLen(local_RedirectCookiesAsArray)#" index="i">
    <cfset local_count_keys = local_count_keys+1>
    <cfset local_results.RESPONSEHEADER["Set-Cookie"][""&local_count_keys&""] = local_RedirectCookiesAsArray[i][2]>
   </cfloop>
  </cfif>

  <cfset local_results.fileContent = CharsetEncode(ToBinary(ToBase64(local_results.fileContent)), out_Charset)>
  <cfset local_results.fileContent = #ToString(local_results.fileContent)#>

  <cfset local_results.timing = local_timer>

  <cfset local_System.setProperty("http.proxyHost","")>
  <cfset local_System.setProperty("http.proxyPort","")>

  <cfreturn local_results>
 </cffunction>

</cfcomponent>