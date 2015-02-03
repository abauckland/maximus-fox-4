$(document).ready(function(){

// show/hide menu and mob menu link
	$('table.line_table').on({
    	mouseenter:function(){ 
			$(this).css('background-color', '#efefef');
			$(this).find('td.line_menu').css('visibility', 'visible');
			$(this).find('td.line_menu_mob').css('visibility', 'visible');
    },
    	mouseleave:function(){ 
  			$(this).css('background-color', '#fff');
			$(this).find('td.line_menu').css('visibility', 'hidden');
			$(this).find('td.line_menu_mob').css('visibility', 'hidden');
    	}
	});

  	
// show/hide mob menu
	$('.line_menu_mob').click(function (){
		$(this).closest('table').find('.mob_menu_popup').toggle();
	});
 
	$('tr.mob_menu_popup').mouseleave(function (){
		$(this).hide();
	});


// specline linetype edit
	$(document).on('click','.submittable2', function() {
	 $(this).parents('form:first').submit();
	   return false;
	});

});