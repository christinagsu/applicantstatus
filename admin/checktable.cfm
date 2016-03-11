<cfquery name="describeTable" datasource="eAcceptance">
select column_name as "Name"
     , nullable as "Null?"
     , concat(concat(concat(data_type,'('),data_length),')') as "Type"
  from user_tab_columns
 where table_name = 'SENT_LETTERS'
 </cfquery>
 <cfdump var="#describeTable#">