/***********************************************************************************************************************
DOCUMENT: includes/javascript.js
DEVELOPED BY: Ryan Stemkoski
COMPANY: Zipline Interactive
EMAIL: ryan@gozipline.com
PHONE: 509-321-2849
DATE: 3/26/2009
UPDATED: 3/25/2010
DESCRIPTION: This is the JavaScript required to create the accordion style menu.  Requires jQuery library
NOTE: Because of a bug in jQuery with IE8 we had to add an IE stylesheet hack to get the system to work in all browsers. I hate hacks but had no choice :(.
************************************************************************************************************************/

/* Modified by M Industrie */

$(document).ready(function() {
	
	$.easing.def = "easeOutBounce";
	 
	//ACCORDION BUTTON ACTION (ON CLICK DO THE FOLLOWING)
	$('.accordionButton').click(function() {

		//REMOVE THE ON CLASS FROM ALL BUTTONS
		  
		//NO MATTER WHAT WE CLOSE ALL OPEN SLIDES
	 	$('.accordionContent').slideUp(900);
   
		//IF THE NEXT SLIDE WASN'T OPEN THEN OPEN IT
		
		if($(this).next().is(':hidden') == true) {
			
			//ADD THE ON CLASS TO THE BUTTON
			  
			//OPEN THE SLIDE
			$(this).next().slideDown(900);
		 }
	 });
	
	/*  
	$('.accordionLink').click(function() {
		$('.accordionButton').removeClass('on');
		$('.accordionLink').removeClass('on');
		$('.accordionContent li').removeClass('on');
		$(this).addClass('on');
	});
	
	$('.accordionContent li').click(function() {
		$('.accordionLink').removeClass('on');
		$('.accordionContent li').removeClass('on');
		$(this).addClass('on');
		$(this).parents('.accordionContent').prev().addClass('on');
	}); */
	
	
	/********************************************************************************************************************
	CLOSES ALL S ON PAGE LOAD
	********************************************************************************************************************/	
	$('.accordionContent').hide();
/*
});

window.onload(function() { */;

	/* M Industrie */

	var filename = location.pathname.substr(location.pathname.lastIndexOf("/")+1,location.pathname.length);
	var file = filename.replace(/\.(html|htm)$/, "");
	var page = document.getElementById(file);
	if ($(page).hasClass('accordionLink')) {
		$(page).addClass('on');}
	else {
		$(page).addClass('on');
		$(page).parents('.accordionContent').prev().addClass('on');
		$(page).parents('.accordionContent').show();
	};
 });