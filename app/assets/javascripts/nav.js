




$(document).ready(function(){

//$('td.suffixed_line_menu').children('a').tipsy();
//$('td.prefixed_line_menu').children('img').tipsy();

	$(window).resize(function(){
		var window_width = $(window).width();
	
		if (window_width > 800){
			$('ul.left_menu, ul.right_menu').css('display', 'block');
			$('ul.sub_menu').css('visibility', 'hidden');
			
			$('.has_sub').mouseover(function (){
				$(this).children('ul.sub_menu').css('visibility', 'visible');
			});
		
			$('ul.sub_menu').mouseout(function (){
				$(this).css('visibility', 'hidden');
			});
		
			$('.has_sub').mouseout(function (){
				$('ul.sub_menu').css('visibility', 'hidden');
			});
		}else{
			//$('ul.left_menu, ul.right_menu').css('visibility', 'hidden');		
			$('nav.app_mob_menu').click(function (){
				$('ul.left_menu').toggle();
			});
			$('nav.app_user_menu').click(function (){
				$('ul.right_menu').toggle();
			});
		};	
	});


	var window_width = $(window).width();
	
	if (window_width > 800){				

	}else{		
		//$('ul.left_menu, ul.right_menu').css('visibility', 'hidden');		
		$('nav.app_mob_menu').click(function (){
			$('ul.left_menu').toggle();
		});
		$('nav.app_user_menu').click(function (){
			$('ul.right_menu').toggle();
		});					 
	};		

});
