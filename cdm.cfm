 
<CFOUTPUT>
<!--- 
  <cfquery  datasource="eAcceptance" name="insert" >
           insertxx into users (CAMPUS_ID,	USER_ID) values ('mick',35)
        </cfquery>
		
		 <CFQUERY NAME="datatable" DATASOURCE="eAcceptance">
select * from users		  
</CFQUERY>

		
		  --->
 <!--- <CFQUERY NAME="datatable" DATASOURCE="eAcceptance">
deletexxx
  from sent_letters  xx
 where LETTER_ID in(  1028647,  1035297)
</CFQUERY>
 --->

   1028647,  1035297
 
		 
 <!--- <CFQUERY NAME="datatable" DATASOURCE="eAcceptance">
select * 
  from sent_letters  
 where LETTER_ID in( 1028647,  1035297)
</CFQUERY>
 --->

 
 <CFQUERY NAME="datatable" DATASOURCE="eAcceptance">
select * 
  from sent_letters   where student_id='2129083'
 
</CFQUERY>



	  









<cfset rownum=1>
<table border="1" class="matrix">
  <tr>
   <cfloop list="#datatable.ColumnList#" index="columnname">
     <td bgcolor="##CCCCCC"><B><font size="-2">#columnname#</font></B> </td>
   </cfloop>
  </tr>
 <cfloop query="datatable">
  <tr>
         <cfloop list="#datatable.ColumnList#" index="columnname">
		 <cfset var=Evaluate("datatable.#columnname#")>
           <td> <font size="-2">#var#</font> </td>
        </cfloop>
         <td> <font size="-2">#rownum#</font> </td>
             <cfset rownum=1+ #rownum#>
  </tr>
  </cfloop>
</table>
</CFOUTPUT>

