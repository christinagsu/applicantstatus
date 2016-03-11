function calcCost(formData, jqForm, options) {	
           return false;
}

$(document).ready(function(){ 
      //submit form when calculate button is pressed
      $('#calc').ajaxForm({ 
				// dataType identifies the expected content type of the server response 
				dataType:  'json', 
				// success identifies the function to invoke when the server response 
				// has been received 
			    beforeSubmit:  calcCost  // pre-submit callback 
			}); 
			
      $('.boxyinfo').click(function() {
		   //alert(this.id);
            $('#boxyresult').remove();
            var top = $(this).offset().top - $(window).scrollTop();
            var left = $(this).offset().left;
            var boxy = new Boxy("<div id='boxyresult'>Loading.....</div>", {y:200,  cache:true, title: "Status Explanation", closeable: true});
            boxy.moveTo(left, top);
            var info_url="info.cfm?decision="+this.id;
            $('#boxyresult').load(info_url);
            return false;
       });
      
      $('.boxyinfo_campusid').click(function() {
		   //alert(this.id);
            $('#boxyresult').remove();
            var top = $(this).offset().top - $(window).scrollTop();
            var left = $(this).offset().left;
            var boxy = new Boxy("<div id='boxyresult'>Loading.....</div>", { cache:true, title: "Campus ID Explanation", closeable: true});
            boxy.moveTo(left, top);
            var info_url="info_campusid.cfm";
            $('#boxyresult').load(info_url);
            return false;
       });
 
      $('.boxyinfo_pantherid').click(function() {
		   //alert(this.id);
            $('#boxyresult').remove();
            var top = $(this).offset().top - $(window).scrollTop();
            var left = $(this).offset().left;
            var boxy = new Boxy("<div id='boxyresult'>Loading.....</div>", { cache: true, title: "Panther # Explanation", closeable: true});
            boxy.moveTo(left, top);
            var info_url="info_pantherid.cfm";
            $('#boxyresult').load(info_url);
            return false;
       });
	    //submit form a dropdown is changed
	    var options = { 
					// dataType identifies the expected content type of the server response 
					dataType:  'json', 
					// success identifies the function to invoke when the server response 
					// has been received 
					beforeSubmit:  calcCost  // pre-submit callback 
		  }; 
    
      $("select").change(function () {        
		      $('#calc').ajaxSubmit(options);		
      });
      
      $("input").keyup(function () {        
		      $('#calc').ajaxSubmit(options);		
      });
      
      
});

function open_gpcidwin() {
           var gpcidurl = '/applicantstatus/getmygpcid.cfm';
           var gpcidwinname = 'gpcidwin';
           //left & top for IE, screenX & screenY for FF, NSC
           var gpcidargs = 'width=460,height=400,menubar=no,status=yes,location=no,toolbar=no,scrollbars=yes,left=450,top=200,screenX=400,screenY=400,resizable=yes';
           var popupWin;
           if (typeof(popupWin) != "object"){
                      popupWin = window.open(gpcidurl,gpcidwinname,gpcidargs);
           } else {
                      if (!popupWin.closed){
                      popupWin.location.href = gpcidurl;
           } else {
                      popupWin = window.open(gpcidurl,gpcidwinname,gpcidargs);
           }
           }
           popupWin.focus();
           return false;
}
function open_gsuidwin() {
           var gpcidurl = '/applicantstatus/getmypanthernumber.cfm';
           var gpcidwinname = 'gpcidwin';
           //left & top for IE, screenX & screenY for FF, NSC
           var gpcidargs = 'width=460,height=400,menubar=no,status=yes,location=no,toolbar=no,scrollbars=yes,left=450,top=200,screenX=400,screenY=400,resizable=yes';
           var popupWin;
           if (typeof(popupWin) != "object"){
                      popupWin = window.open(gpcidurl,gpcidwinname,gpcidargs);
           } else {
                      if (!popupWin.closed){
                      popupWin.location.href = gpcidurl;
           } else {
                      popupWin = window.open(gpcidurl,gpcidwinname,gpcidargs);
           }
           }
           popupWin.focus();
           return false;
}
function setgpcid( val ){
	var f = document.forms[1];
 	if (val != '') {
    	f.gpcid.value = val;
	}
}

