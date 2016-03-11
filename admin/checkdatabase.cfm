<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>    
                               
    
  <cfset mystring="INSERT INTO sent_letters (letter_id, letter_date, letter_order, student_id, letter_text, template_id, pdf_unique_id, student_type, appterm, appdate, student_fname, student_mi, student_lname, student_college, student_major, student_department, student_panthernum , residency_paragraph) select sequence_sentletters.NEXTVAL, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q from ( select {ts '2011-05-16 14:30:15'} as a, 1 as b, 001801602 as c, <cfqueryparam value='my test my test' cfsqltype='CF_SQL_CLOB'> as d, 42  as e, '19861682.3750516201102301189639312.524' as f, 1 as g, 201108 as h, {ts '2010-09-07 00:00:00'} as i, 'Rebecca' as j, 'Carol' as k, 'Camp' as l, 'AS' as m, 'Biological Science' as n, 'Biology' as o, 001860107 as p, '<br><p> You have been classified as a Resident for tuition payment purposes.</p> ' as q from dual union all select {ts '2011-05-16 14:30:15'}, 3, 001883674, <cfqueryparam value='my test2 my test2' cfsqltype='CF_SQL_CLOB'>, 42, '19861682.3750516201102301189639312.524', 1, 201108, {ts '2010-09-07 00:00:00'}, 'Rebecca', 'Carol', 'Camp', 'AS', 'Biological Science', 'Biology', 001860107, '<br><p> You have been classified as a Resident for tuition payment purposes.</p> ' from dual)  ">
                                      
                      
  <cfset mystring='select <cfqueryparam value="my test my test"> as d from dual  '>
          
				     
<cfquery name="test" datasource="eAcceptance">
<!---INSERT INTO sent_letters 
( appdate, appterm, letter_date, letter_id, letter_text, pdf_unique_id, student_id, student_type, template_id ) VALUES 
( ################################NOW()################################, 200811, ################################NOW()################################, 1, 'test test test', 'uniqueid1323123232123', 232, 1, 3 ), 
( ################################NOW()################################, 200811, ################################NOW()################################, 1, 'test test test1121212', 'uniqueid132343434', 232, 1, 3 ), 
( ################################NOW()################################, 200811, ################################NOW()################################, 1, 'test test test232323232', 'uniqueid13231454545454', 232, 1, 3 )--->
<!---INSERT INTO sent_letters (appdate, appterm, letter_date, letter_id, letter_text, pdf_unique_id, student_id, student_type, template_id) 
select ################################NOW()################################, 200811, ################################NOW()################################, sequence_sentletters.NEXTVAL, 'test test test', 'uniqueid1323123232123', 232, 1, 3 from dual 
union all
select ################################NOW()################################, 200811, ################################NOW()################################, sequence_sentletters.NEXTVAL, 'test test test1121212', 'uniqueid132343434', 232, 1, 3 from dual 
union all
select ################################NOW()################################, 200811, ################################NOW()################################, sequence_sentletters.NEXTVAL, 'test test test232323232', 'uniqueid13231454545454', 232, 1, 3 from dual--->
 
<!---INSERT INTO sent_letters (letter_id, appdate, appterm, letter_date, letter_text, pdf_unique_id, student_id, student_type, template_id) 
select sequence_sentletters.NEXTVAL, a, b, c, d, e, f, g, h
from
(select ################################NOW()################################ as a, 200811 as b, ################################NOW()################################ as c, 'test test test' as d, 'uniqueid1323123232123' as e, 232 as f, 1 as g, 3 as h from dual 
union all
select ################################NOW()################################, 200811, ################################NOW()################################, 'test test test1121212', 'uniqueid132343434', 232, 1, 3 from dual 
union all
select ################################NOW()################################, 200811, ################################NOW()################################, 'test test test232323232', 'uniqueid13231454545454', 232, 1, 3 from dual)--->

<!---SELECT * FROM ( 
SELECT ROWNUM as row_num, APPDATE, APPTERM, LETTER_DATE, LETTER_ID, LETTER_TEXT, PDF_UNIQUE_ID, STUDENT_ID, STUDENT_TYPE, TEMPLATE_ID  FROM sent_letters 
) 
WHERE row_num BETWEEN 20 AND 40--->

 <!---SELECT * FROM 
                    (SELECT APPDATE, APPTERM, LETTER_DATE, LETTER_ID, LETTER_TEXT, PDF_UNIQUE_ID, STUDENT_ID, STUDENT_TYPE, TEMPLATE_ID FROM sent_letters 
                    ORDER BY letter_date DESC) 
                    where rownum >= 381 and rownum <= 400--->
                    
                    
                  <!---select * from (       
                   SELECT  x.*, rownum as r FROM (           
                   select *        
                   from sent_letters      
                   order by letter_date       
                   ) x     
                   )     
                   where r between 1 AND 5;--->
                   
                   
                   <!--- SELECT * FROM 
                    (SELECT APPDATE, APPTERM, LETTER_DATE, LETTER_ID, LETTER_TEXT, PDF_UNIQUE_ID, STUDENT_ID, STUDENT_TYPE, TEMPLATE_ID, rownum as r FROM sent_letters 
                    ORDER BY letter_date DESC) 
                    where r >= 381 and r <= 400--->
                    
                    
                   <!---CORRECT select * from (       
                    SELECT  x.*, rownum as r FROM (           
                    select letter_date, rownum          
                    from sent_letters                   
                    order by letter_date       
                    ) x     
                    )     
                    where r between 1 AND 5--->
             <!---SELECT 
column_name "Name", 
nullable "Null",
concat(concat(concat(data_type,'('),data_length),')') "Type"
FROM user_tab_columns
WHERE table_name='SENT_LETTERS' --->




<!---select STUDENT_MI,STUDENT_LNAME, LETTER_ORDER, LETTER_ID, LETTER_DATE,  STUDENT_ID, TEMPLATE_ID, PDF_UNIQUE_ID,STUDENT_TYPE, APPTERM, APPDATE, STUDENT_FNAME, STUDENT_COLLEGE, STUDENT_MAJOR, STUDENT_DEPARTMENT, STUDENT_PANTHERNUM from sent_letters--->



























        





<!---<cfloop index="i" from="1" to="300">
	INSERT INTO sent_letters (letter_id, letter_date, letter_order, student_id, letter_text, template_id, pdf_unique_id, student_type, appterm, appdate, student_fname, student_mi, student_lname, student_college, student_major, student_department, student_panthernum , residency_paragraph) values (sequence_sentletters.NEXTVAL,1, 001801602, <cfqueryparam value='my test my test' cfsqltype='CF_SQL_CLOB'>, 42, '19861682.3750516201102301189639312.524', g, 201108, {ts '2010-09-07 00:00:00'}, 'Rebecca', 'Carol', 'Camp', 'AS' , 'Biological Science' , 'Biology', 001860107, '<br><p> You have been classified as a Resident for tuition payment purposes.</p> ')
    INSERT INTO sent_letters (letter_id) values (sequence_sentletters.NEXTVAL)
    
</cfloop>--->


<!---select * from sent_letters where pdf_unique_id='59064224.10830201111450610087403.6278' and rownum > 10 order by letter_order --->


    	<!---select * from sent_letters where letter_date>to_date('08-Feb-12')--->
	

	        
	
   
	
select * from sent_letters where pdf_unique_id='70339861.29210303201605374226972398.6135' and student_id='002245987'

    	
    
</cfquery>

      <cfdump var="#test#">
	<cfabort>
  
                 
<cfoutput>num records: #test.RecordCount#!!</cfoutput>
<cfoutput>#GetCurrentTemplatePath()#</cfoutput>
<table>
<tr>
<cfoutput>
<cfloop index="column" list="#test.columnlist#">
	<th>#column#</th>
</cfloop>
</cfoutput>

<cfoutput query="test">
	<tr>
		<cfloop index="column" list="#test.columnlist#">
			<td>#Evaluate("test.#column#")#</td>
		</cfloop>
	</tr>
</cfoutput>
</tr>
</table>

<!---<cfset myObject = createObject( "java", "ZipUtil" )>
<cfset decompressed_letter = myObject.decompress( test.form_text ) >
<cfoutput><DIV style="border-width:thin; border-style:solid; height:900px;padding:10px;">#decompressed_letter#</div></cfoutput>--->

</body>
</html>
