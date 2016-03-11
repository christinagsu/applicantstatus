
<cfapplication name="applicantstatusApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<cfif not isDefined("Session.student_id") or Session.student_id eq ""><cflocation url="index.cfm" addtoken="no"></cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">





<head>
	<link rel="shortcut icon" href="http://www.gsu.edu/wp-content/themes/gsu-core/favicon.ico" />
	<title>Applicant Status Check</title>
    
	<style type="text/css">
	     p.title {
		 color:#59B747;
		 border-top:solid #59B747;
		 border-top-width: 2px;
		 padding-top:8px;
		 font-size:15px;
		 padding-bottom:0px;
		 margin-top:0px;
	     }
	     p.info {
		font-size:13px;
		margin-left:5px;
		font-weight:normal;
	     }
	     table {
		font-size:13px;
		padding: 0px;
	     }
	     table td a:hover { text-decoration:normal; }
	     
		 .ui-accordion .ui-accordion-header { margin-top: 0px !important; }
		 /*.ui-accordion-content { background: url(http://www.psdgraphics.com/file/blue-business-background.jpg) !important; }*/
		 .ui-accordion-content { background: #0066CC !important; color: white !important; padding-bottom: 45px !important; }
		 .acceptance-msg { font-family:Arial;font-size:35px;font-weight:bold;font-style:normal;text-decoration:none;color:#FFFFFF; }
		 .acceptance-msg2 { font-family:Arial;font-size:30px;font-weight:bold;font-style:normal;text-decoration:none;color:#FFFFFF; }
		 h3.acceptance { line-height: 0.8; }
		 
		 .content-section-wrapper { background: #CCE6FF; border: 1px solid #797979; padding: 5px; margin: 0px;  }
		 .content-section { background: #FFF; border: 1px solid #797979; padding: 10px; margin: 0px;  }
		 
		 .content-internal td a { font-size: 10px; }
		 
		 .accordion-message-hdr tbody { width: 100% !important; }
		
		.social-buttons-table { background: /*#66A3E0*/ url('admin/images/Semi-transparent.png'); margin: 25px; /*border-radius: 6px;*/ }		 
		 .social-buttons-table td { height: 45px; text-align: center; padding: 0px 10px; }
	
		 .twitter-share-button { width: 80px !important; } 
	</style>
    
        <link href="/ApplicationTemplateCSS/css/960.css" rel="stylesheet" type="text/css">
        <link href="/ApplicationTemplateCSS/css/layout.css" rel="stylesheet" type="text/css">
        <link href="/ApplicationTemplateCSS/fonts/m_plus/stylesheet.css" rel="stylesheet" type="text/css">
        <link href="/applicantstatus/admin/tempcss.css" rel="stylesheet" type="text/css" />
    
	
	
	<!--link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" /-->
	<link href="css/jquery-gsu/jquery-ui-1.10.3.custom.css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-1.9.1.js"></script>
	<script src="https://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
	<script src="js/jquery-migrate-1.0.0.js"></script>
	<link rel="stylesheet" type="text/css" href="/cost_calculator/css/boxy.css" />
	<script type="text/javascript" src="/cost_calculator/js/jquery.form.js"></script>
	<script type="text/javascript" src="js/jquery.boxy.js"></script>
	<script type="text/javascript" src="js/calculate.js"></script>
	<script type="text/javascript" src="js_funcs.js"></script>
    
	<script language="JavaScript" type="text/javascript">
	<!--
	
	function MM_preloadImages() { //v3.0
	  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
	    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
	    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
	}
	
	function MM_swapImgRestore() { //v3.0
	  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}
	
	function MM_findObj(n, d) { //v4.01
	  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  if(!x && d.getElementById) x=d.getElementById(n); return x;
	}
	
	function MM_swapImage() { //v3.0
	  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}
	
	-->
	</script>
	
	<!--popup functions ended-->
	<script type="text/javascript" src="counselor/js_funcs.js"></script>
    
    	<link href="nonmobilestyles.css" rel="stylesheet" type="text/css" />
        <!--popup functions below-->
		<script type="text/javascript">
            var GB_ROOT_DIR = "/applicantstatus/counselor/greybox/";
        </script>
        <script type="text/javascript" src="/applicantstatus/counselor/greybox/AJS.js"></script>
        <script type="text/javascript" src="/applicantstatus/counselor/greybox/AJS_fx.js"></script>
        <script type="text/javascript" src="/applicantstatus/counselor/greybox/gb_scripts.js"></script>
        <link href="/applicantstatus/counselor/greybox/gb_styles.css" rel="stylesheet" type="text/css" />
    
    
    
    

    
</head>

<body>


<div class="wrapper" width="100%">

  <div class="container_16" id="header" width="100%">
    
	<div class="grid_6"  style="white-space:nowrap">
    	
        <span class="logo" style="display:inline;"><a href="index.cfm?option=1"><img src="/ApplicationTemplateCSS/images/gsulogo_departonlybanner.gif" width="109" height="84" alt="Georgia State University"  border="0"></a></span>
      <span class="appname" style="display:inline;">Admissions<br>
        Status Check</span>
        
    </div>

  </div>
  <div class="clear"></div>
  
	
  <div class="container_16 page" style="padding-top: 0px;">
   
   
  <div class="clear"></div>
  <div class="container_16 page" style="padding-top: 0px;">
    <div class="grid_12" id="app" style="width: 98%;">



	<script>
	endSession("returningStudentsScholStatus");
        </script>
	
	<H2>Your application is inactive.</H2>
	<p>Please reapply to Georgia State University.</p>

	
      <!--Content End-->
      <!--Right Rail Start
      <div class="grid_4">-->
        <!--	  Release Status Box and Form Start-->
		
		
        <!--	  Release Status Box and Form End-->
      	
	<!--Right Rail End-->
      </div>
      <div class="clear"></div>
    </div>
    <div class="clear"></div>
    <div class="container_16 footer">
      
	<div class="grid_16" style="width:100%;" align="center">
	
	 <br />
	 <div id="footer">
     
	 		
			&#169; 2016 Georgia State University | <a href="http://www.gsu.edu/legal-statement">View legal statement</a> | <a href="http://www.gsu.edu/contact-georgia-state">Contact us</a> | <a href="https://gsu.uservoice.com">Send feedback</a>
        
	 </div>
     </div>

    </div>
    <div class="clear"></div>
  </div>	
    <!-- Footer End -->
    <script type="text/javascript">
	  var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
	  document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
	  </script>
	  <script type="text/javascript">
	  try {
	  var pageTracker = _gat._getTracker("UA-411467-1");
	  pageTracker._trackPageview();
	  } catch(err) {}</script>
  </div>
  
  
  
  <script>
    $(function() {
      $('.wrapper').show();
    });
  </script>
  
  </body>
  </html>
