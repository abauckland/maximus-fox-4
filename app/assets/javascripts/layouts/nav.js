$(document).ready(function(){

//$('td.suffixed_line_menu').children('a').tipsy();
//$('td.prefixed_line_menu').children('img').tipsy();

//large_menu
	$('li.has_sub').mouseover(function (){
		$(this).children('ul.sub_menu').css('visibility', 'visible');
	});	
				
	$('ul.sub_menu').mouseout(function (){
		$(this).css('visibility', 'hidden');
	});
	
	$('li.has_sub').mouseout(function (){
		$(this).children('ul.sub_menu').css('visibility', 'hidden');
	});

//mob_menu
	$('.left_menu_mob_select').click(function (){
		$('ul.left_menu').toggle();
		$('ul.right_menu_mob').hide();
	});

//user_menu
	$('.user_menu').mouseover(function (){
		$('ul.right_menu').css('visibility', 'visible');
	});	
				
	$('ul.right_menu').mouseout(function (){
		$(this).css('visibility', 'hidden');
	});
	
	$('ul.right_menu').mouseover(function (){
		$('ul.right_menu').css('visibility', 'visible');
	});	
	
	$('.user_menu').mouseout(function (){
		$('ul.right_menu').css('visibility', 'hidden');
	});

//user_menu_mob
	$('.user_menu').click(function (){
		$('ul.right_menu').toggle();
		$('ul.left_menu').hide();
	});





});
