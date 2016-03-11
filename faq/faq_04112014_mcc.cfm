<cfapplication name="applicantstatusApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
<script src="jQuery/includes/jquery-1.4.2.js" type="text/javascript"></script>
<script src="jQuery/includes/jquery.ui.core.min.js" type="text/javascript"></script>
<script src="jQuery/includes/jquery.ui.widget.min.js" type="text/javascript"></script>
<script src="jQuery/includes/jquery.ui.tabs.min.js" type="text/javascript"></script>
<link href="jQuery/css/jquery.ui.core.css" rel="stylesheet" type="text/css" />
<link href="jQuery/css/jquery.ui.tabs.css" rel="stylesheet" type="text/css" />
<link href="jQuery/css/jquery.ui.theme.css" rel="stylesheet" type="text/css" />
<style type="text/css"> 
/* BeginOAWidget_Instance_2140022: #jQueryTabs */
 
#jQueryTabs.ui-tabs .ui-tabs-panel { 
	display: block; 
	border: 0px solid #8ca5dd; 
	padding: 10px 15px;
	background: #ffffff; 
	font-family: inherit;
	font-size: 12px/*{fsDefault}*/; 
}
 
/* Component containers
----------------------------------*/
#jQueryTabs .ui-widget { 
	
}
#jQueryTabs .ui-widget-content { 
	border: 1px solid #aaaaaa/*{borderColorContent}*/; 
	background: #ffffff/*{bgColorContent}*/ url(jQuery/css/images/ui-bg_flat_75_ffffff_40x100.png)/*{bgImgUrlContent}*/ 50%/*{bgContentXPos}*/ 50%/*{bgContentYPos}*/ repeat-x/*{bgContentRepeat}*/; 
	color: #333333/*{fcContent}*/; 
}
#jQueryTabs .ui-widget-content a { 
	color: #0000ff/*{fcContent}*/; 
}
#jQueryTabs .ui-widget-header { 
	border: 1px solid #aaaaaa/*{borderColorHeader}*/; 
	background: #c6cff0/*{bgColorHeader}*/ url(jQuery/css/images/ui-bg_highlight-soft_75_cccccc_1x100.png)/*{bgImgUrlHeader}*/ 50%/*{bgHeaderXPos}*/ 50%/*{bgHeaderYPos}*/ repeat-x/*{bgHeaderRepeat}*/; 
	color: #222222/*{fcHeader}*/; 
	font-weight: bold; 
	font-family: inherit;
	font-size: 16px/*{fsDefault}*/; 
}
 
/* Interaction states
----------------------------------*/
#jQueryTabs .ui-state-default, .ui-widget-content .ui-state-default { 
	border: 1px solid #8ca5dd/*{borderColorDefault}*/; 
	background: #8ca5dd/*{bgColorDefault}*/ url(jQuery/css/images/ui-bg_glass_75_e6e6e6_1x400.png)/*{bgImgUrlDefault}*/ 50%/*{bgDefaultXPos}*/ 50%/*{bgDefaultYPos}*/ repeat-x/*{bgDefaultRepeat}*/; 
	font-weight: normal/*{fwDefault}*/; 
	color: #555555 /*{fcDefault}*/; 
	
}
#jQueryTabs .ui-state-default a, .ui-state-default a:link, .ui-state-default a:visited { 
	color: #555555/*{fcDefault}*/; 
	text-decoration: none; 
}
#jQueryTabs .ui-state-hover, .ui-widget-content .ui-state-hover, .ui-state-focus, .ui-widget-content .ui-state-focus { 
	border: 1px solid #8ca5dd/*{borderColorHover}*/; 
	background: #8ca5dd/*{bgColorHover}*/ url(jQuery/css/images/ui-bg_glass_75_dadada_1x400.png)/*{bgImgUrlHover}*/ 50%/*{bgHoverXPos}*/ 50%/*{bgHoverYPos}*/ repeat-x/*{bgHoverRepeat}*/; 
	font-weight: normal/*{fwDefault}*/; 
	color: #212121 /*{fcHover} #212121*/; 
	font-family: inherit;
	font-size: inherit/*{fsHover}*/; 
}
#jQueryTabs .ui-state-hover a, .ui-state-hover a:hover { 
	color: #212121/*{fcHover}*/; 
	text-decoration: none; 
}
#jQueryTabs .ui-state-active, .ui-widget-content .ui-state-active { 
	border: 1px solid #8ca5dd/*{borderColorActive}*/; 
	background: #ffffff/*{bgColorActive}*/ url(jQuery/css/images/ui-bg_glass_65_ffffff_1x400.png)/*{bgImgUrlActive}*/ 50%/*{bgActiveXPos}*/ 50%/*{bgActiveYPos}*/ repeat-x/*{bgActiveRepeat}*/; 
	font-weight: normal/*{fwDefault}*/; 
	color: #212121/*{fcActive}*/; 
	font-family: inherit;
	font-size: inherit/*{fsSelected}*/; 
}
#jQueryTabs .ui-state-active a, .ui-state-active a:link, .ui-state-active a:visited { 
	color: #333333/*{fcActive}*/; 
	text-decoration: none; 
}

#DL {
	font-family: arial;
}
 
/* EndOAWidget_Instance_2140022 */
</style>
<script type="text/xml">
<!--
<oa:widgets>
  <oa:widget wid="2140022" binding="#jQueryTabs" />
</oa:widgets>
-->
</script>
</head>
 
<body>
<script type="text/javascript"> 
// BeginOAWidget_Instance_2140022: #jQueryTabs
 
 
	$(function() {
      $("#jQueryTabs").tabs({
		event:"click",
		collapsible: false,
		selected:'0',
		fx: { opacity: 'toggle', duration: 75 }
        }).tabs( "none" , 1 , false ); 	
	});
 
// EndOAWidget_Instance_2140022
</script>
<div id="jQueryTabs">
  <ul>
    <li><a href="#tabs-1">Student FAQ</a></li>
    <li><a href="#tabs-2">Application Status Check/Residency FAQ</a></li>
    <!--<li><a href="#tabs-3">Aenean lacinia</a></li>-->
  </ul>
  <div id="tabs-1">
   	<iframe src ="high_school_students_FAQ.htm" width="950px" height="400" scrolling="auto" frameborder="0">
  <p>Your browser does not support iframes.</p>
</iframe>
  </div>
  <div id="tabs-2">
    <iframe src ="residency_FAQ.htm" width="950px" height="400" scrolling="auto" frameborder="0">
  <p>Your browser does not support iframes.</p>
</iframe>
  </div>
  <!--<div id="tabs-3">
    <p>Mauris eleifend est et turpis. Duis id erat. Suspendisse potenti. Aliquam vulputate, pede vel vehicula accumsan, mi neque rutrum erat, eu congue orci lorem eget lorem. Vestibulum non ante. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Fusce sodales. Quisque eu urna vel enim commodo pellentesque. Praesent eu risus hendrerit ligula tempus pretium. Curabitur lorem enim, pretium nec, feugiat nec, luctus a, lacus.</p>
    <p>Duis cursus. Maecenas ligula eros, blandit nec, pharetra at, semper at, magna. Nullam ac lacus. Nulla facilisi. Praesent viverra justo vitae neque. Praesent blandit adipiscing velit. Suspendisse potenti. Donec mattis, pede vel pharetra blandit, magna ligula faucibus eros, id euismod lacus dolor eget odio. Nam scelerisque. Donec non libero sed nulla mattis commodo. Ut sagittis. Donec nisi lectus, feugiat porttitor, tempor ac, tempor vitae, pede. Aenean vehicula velit eu tellus interdum rutrum. Maecenas commodo. Pellentesque nec elit. Fusce in lacus. Vivamus a libero vitae lectus hendrerit hendrerit.</p>
  </div>-->
</div>
<cfif isDefined("Session.student_id")>
	<cfinvoke component="applicantstatus.applicantStatus" method="addZeros" panther_id="#Session.student_id#" returnvariable="panther_no" />
	<cfquery name="insertLogin" datasource="eAcceptance">
	    insert into student_clicks (click_id, panther_id, click_event, click_date) values (studentclicks_seq.NEXTVAL, '#panther_no#', 3, #NOW()#)
	</cfquery>
</cfif>
</body>
</html>

