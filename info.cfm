<cfif isDefined("URL.decision")>
     <cfquery name="getStatuses" datasource="eAcceptance">
	  select * from status_explanations where status_code = #url.decision#
     </cfquery>
     <cfoutput query="getStatuses">
	  <div id="#LCase(status_code)#" style="width:400px;">
	       <div id="page">
		    <p class="title">#info_title#</p>
		     <p class="info">#info_text#</p>
		    
		    
	       </div>
	  </div>
     </cfoutput>
<cfelse>
     <p>No description available.</p>
</cfif>
     <!--- <div id="a" style='width: 400px;'>     <div id="page">     
                <!-- <table class="matrix" width="100%" border="0" cellspacing="0" cellpadding="2">
                <caption>Tuition Classification</caption>
                <tr>
                <td> <p>
                
                acc
               </p>
                </td>
                </tr>
                </table> -->
		<p class="title">Accept</p>
		<p class="info">Congratulations! You have been accepted to Georgia State University.</p>sdfs
      </div>  </div>




     <div id="d" style="width:400px;">
	  <div id="page">
	       <p class="title">Deny</p>
		<p class="info">Sorry, you have not been accepted to Georgia State University.</p>
	       
	       
	  </div>
     </div>--->



