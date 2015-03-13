function main_menu() {
		$('li.has_sub').mouseover(function (){
			$(this).children('ul.sub_menu').css('visibility', 'visible');
		});	

		$('ul.sub_menu').mouseout(function (){
			$(this).css('visibility', 'hidden');
		});

		$('li.has_sub').mouseout(function (){
			$(this).children('ul.sub_menu').css('visibility', 'hidden');
		});


		$('p.mob_menu').click(function (){
			$(this).siblings('ul.sub_menu_mob').toggle();
		});	
};

function reset_menu() {
		$('ul.left_menu_mob').hide();
		$('ul.right_menu').show();
		$('ul.right_menu').css('visibility', 'hidden');
};


function position_right_menu() {

	var grid_width = $('.grid-container').width()
	var window_width = $(window).width();

	if(window_width > 1200) {
		var right_margin = ((window_width - 1200)/2) + 28
		$('ul.right_menu').css('right', right_margin+'px');
	}
};


$(document).ready(function(){

	main_menu();
	position_right_menu();
//	reset_menu();
	$(window).resize(function(){
		main_menu();
		reset_menu();
		position_right_menu();
	});


//mob_menu
	$('.left_menu_mob_select').click(function (){
		$('ul.left_menu_mob').toggle();
//		$('ul.right_menu_mob').hide();
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
//		$('ul.left_menu').hide();
	});






});
