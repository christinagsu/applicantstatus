function validate_genletter_form(myform){
	if (myform.start_date.value=="mm/dd/yyyy"){
		alert("Please choose your start date.");
		return false;
	}
	if (myform.end_date.value=="mm/dd/yyyy"){
		alert("Please choose your end date.");
		return false;
	}
	var today=new Date();
	var startDate=new Date(myform.start_date.value);
	var endDate=new Date(myform.end_date.value);
	/*var enteredPastDates=false;
	if (today > startDate || today > endDate) enteredPastDates=true;
	if (enteredPastDates==true){
		alert("Please choose a start date and end date that are in the future.");
		return false;
	}*/
	if (startDate > endDate){
		alert("Please choose an end date that is later than the start date.");
		return false;
	}
}
function validate_uploadform_excel(thisform){
	var file_parts = thisform.spreadsheet_file.value.split(".");
	//alert(file_parts.length);
	if (file_parts.length>2){
		alert("Please only have one extension for your file.  Your filename can only have one '.' in it.");
		return false;
	}
	var file_ext = thisform.spreadsheet_file.value.substr(thisform.spreadsheet_file.value.lastIndexOf('.') + 1).toLowerCase();
	//alert(file_ext);
	if (file_ext != "csv"){
		alert("Please enter only a .csv file.");
		return false;
	}
}
function confirm_send(){
	var confirm_send=confirm("Are you sure you want to send?  This will insert a record of the sent letter for the student and generate a PDF of the letters to be sent out.");
	if (confirm_send==true) return true;
	else {alert("Letters not sent."); return false;}
}
function open_window(url, window_name, attributes){
	window.open(url, window_name, attributes); 	
}


function addUser(campus_id){
	var campus_id=trim(campus_id);
	if (campus_id == ""){
		alert("Please enter a user's campus id to add.");
		return false;
	}
	count=Math.floor(Math.random()*999999999999999999999);
	var url="/applicantstatus/admin/makeChanges.cfm";
	url=url+"?count="+count;
	url=url+"&addUser=" + campus_id;
	//alert (url);
	var xmlHttp=createResponseObject();
	xmlHttp.open("GET",url,false);
	xmlHttp.send(null);
	var info=trim(xmlHttp.responseText);
	if (info=="already exists"){
		alert("Sorry, that user already exists.  Please try again.");
		return false;
	}
	else if (info=="invalid campusid"){
		alert("Sorry, that is an invalid campus id.  Please try again.");
		return false;
	}
	addRows(info);
	document.getElementById("userChangeConfirmation").innerHTML="Thank you, the administrator has been added.";
}
function deleteUser(campus_id){
	var deleteUser=confirm('Are you sure you would like to delete user \''+campus_id+'\'?');
	if (deleteUser==true){
		count=Math.floor(Math.random()*999999999999999999999);
		var url="/applicantstatus/admin/makeChanges.cfm";
		url=url+"?count="+count;
		url=url+"&deleteUser=" + campus_id;
		//alert (url);
		var xmlHttp=createResponseObject();
		xmlHttp.open("GET",url,false);
		xmlHttp.send(null);
		var info=trim(xmlHttp.responseText);
		addRows(info);  
		document.getElementById("userChangeConfirmation").innerHTML="Thank you, the administrator has been deleted.";
	}
	else 
		alert('User not deleted.');	
}
function deleteRows(){
	var table = document.getElementById('userTable');
	var rows = table.rows;
	while(rows.length && rows.length>1){
		table.deleteRow(rows.length-1);
	}
}
function addRows(info){
	//alert(info);
	 var table = document.getElementById("userTable");
	 var rowCount = table.rows.length;  
	 var color;
	 if (rowCount%2 == 0)
		 color="1";
	 else 
		 color="2";
	//DELETE ALL ROWS
		 deleteRows();   
	 if (info && info!=""){
		 var infoArray = info.split("|");
		 var x; 
		       
		 for (x=0;x<=(infoArray.length-1);x++){
			  var row = table.insertRow(x+1); 
			  var rowclass="matrixrow"+color;
			  row.setAttribute('class', rowclass);  
			  var nameArray = infoArray[x].split("*");
			  var cell1 = row.insertCell(0);
			  cell1.setAttribute("valign","top");
			  cell1.setAttribute('class','word-wrap');
			  //cell1.setAttribute('width','200px');  
			  var newa=document.createElement("a"); 
			  if (document.location.href.indexOf("?") == -1)
			  	newa.setAttribute('href', document.location.href +'?view_scholarship='+nameArray[1]);  
			  else 
			  	newa.setAttribute('href', document.location.href +'&view_scholarship='+nameArray[1]);  
			  var element2 = document.createElement("span"); 
			  element2.innerHTML = nameArray[0];
			  newa.appendChild(element2);           
			  //cell2.appendChild(newa);  
			  cell1.appendChild(element2);  
			  var cell2 = row.insertCell(1);  
			  cell2.setAttribute('valign','top');
			  cell2.setAttribute('class','word-wrap');    
			  cell2.innerHTML = nameArray[1];
			  
			  var cell2 = row.insertCell(2);  
			  cell2.setAttribute('valign','top');
			  var deleteImage = document.createElement("img"); 
			  deleteImage.setAttribute('src', 'images/delete.gif');     
			  deleteImage.setAttribute('alt', 'Delete User');
			  deleteImage.setAttribute('align', 'top');
			  var function_call="deleteUser('"+trim(nameArray[0])+"');";
			  deleteImage.setAttribute('onclick', function_call);
			  deleteImage.setAttribute('id', '1236');
			  cell2.appendChild(deleteImage);
			  
			  if (color==2) color=1;
			  else color=2;
		}     
	}  
	else   {
		var row = table.insertRow(1); 
		  var rowclass="usermatrixrow"+color;
		  row.setAttribute('class', rowclass);  
		  var cell3 = row.insertCell(0);  
		  cell3.setAttribute('valign','top');
		  cell3.setAttribute('class','word-wrap');   
		  cell3.setAttribute('colspan','2'); 
		  //cell3.setAttribute('width','200px');
		  cell3.innerHTML = "There are currently no results.  Please broaden your search to receive more results.";
	}                 
}












function createResponseObject()
{
	var tempobject=GetXmlHttpObject()
	if (tempobject==null)
	{
		alert ("Browser does not support HTTP Request")
		return false;
	}
	return tempobject;
}
function GetXmlHttpObject()
{ 
var objXMLHttp=null;
if (window.ActiveXObject)
{
//alert("ms");
objXMLHttp=new ActiveXObject("Microsoft.XMLHTTP");
}
else if (window.XMLHttpRequest)
{
//alert("other");
objXMLHttp=new XMLHttpRequest()
}
return objXMLHttp
}
function trim (str) {
	var	str = str.replace(/^\s\s*/, ''),
		ws = /\s/,
		i = str.length;
	while (ws.test(str.charAt(--i)));
	return str.slice(0, i + 1);
}