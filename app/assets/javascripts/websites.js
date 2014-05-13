//NEW JQUERY

function roundDown(x) {
	//rounds number up to next number
	if (x < x.toFixed(0)) {
		var n = x.toFixed(0);
		x = +n - 1;
	}else{
		x = x.toFixed(0);
	}
	return x;
}



//function content_tiling(tile_name, container_name){
function content_tiling(tile_frame, tile_container, tile, tile_id) {

	//total tiles		
	var n = $(tile).length;
	var content_tile_width = $(tile).outerWidth();
	var window_width = $(tile_frame).width();
	//number fit in width
	var max_tiles_in_row = window_width/content_tile_width;	
	var max_tiles_in_row_rounded = roundDown(max_tiles_in_row);
	
	if (max_tiles_in_row_rounded == 1){
		var margin = (window_width - content_tile_width)/2;
		var sub_margin = 0;
		$(tile_container).css('margin-left',margin+'px');
		$(tile).css('margin-left',sub_margin+'px');	
	}
	else
	{	
		//number of rows
		var number_of_rows = n/max_tiles_in_row_rounded;
		var number_of_rows_rounded = roundDown(number_of_rows);
		//number in left over (in last row)
		var number_last_row = (n - (number_of_rows_rounded * max_tiles_in_row_rounded));

		//width of content block
		var content_block_width = max_tiles_in_row_rounded * content_tile_width;
		
		var last_row_tile_ref = ((n-number_last_row));
	
		//set margins if wider than
		if (number_last_row == 0){
			var margin = (window_width - content_block_width)/2;
			var sub_margin = 0;
			
			$(tile_container).css('margin-left',margin+'px');
			$(tile).css('margin-left',sub_margin+'px');	
		}
		else
		{
			var margin = (window_width - content_block_width)/2;
			var sub_margin = (content_block_width - (number_last_row * content_tile_width))/2;
			var id = last_row_tile_ref;
			
			$(tile_container).css('margin-left',margin+'px');
			$(tile_id + id).css('margin-left',sub_margin+'px');	
		}
	}
}




$(document).ready(function(){


//NEW JQUERY
	//responsive layout of content
	var tile_frame = '.content_tile';
	var tile = ".content_tile_item";
	var tile_container = '.content_tile_container';
	var tile_id = '#content_tile_';	
	content_tiling(tile_frame, tile_container, tile, tile_id);

	$(window).resize(function(){
		content_tiling(tile_frame, tile_container, tile, tile_id);
	});


	//responsive layout of large tile menu
	var lrg_menu_tile_frame = '.lrg_menu_tile';
	var lrg_menu_tile = ".lrg_menu_tile_item";
	var lrg_menu_tile_container = '.lrg_menu_tile_container';
	var lrg_menu_tile_id = '#lrg_menu_tile_';	
	content_tiling(lrg_menu_tile_frame, lrg_menu_tile_container, lrg_menu_tile, lrg_menu_tile_id);

	$(window).resize(function(){
		content_tiling(lrg_menu_tile_frame, lrg_menu_tile_container, lrg_menu_tile, lrg_menu_tile_id);
	});



	//responsive layout of small tile menu
	var sml_menu_tile_frame = '.sml_menu_tile';
	var sml_menu_tile = ".sml_menu_tile_item";
	var sml_menu_tile_container = '.sml_menu_tile_container';
	var sml_menu_tile_id = '#sml_menu_tile_';	
	content_tiling(sml_menu_tile_frame, sml_menu_tile_container, sml_menu_tile, sml_menu_tile_id);

	$(window).resize(function(){
		content_tiling(sml_menu_tile_frame, sml_menu_tile_container, sml_menu_tile, sml_menu_tile_id);
	});


	//responsive layout of price plan
	var price_tile_frame = '.content_tile';
	var price_tile = ".content_price_item";
	var price_tile_container = '.content_tile_container';
	var price_tile_id = '#content_price_';	
	content_tiling(price_tile_frame, price_tile_container, price_tile, price_tile_id);

	$(window).resize(function(){
		content_tiling(price_tile_frame, price_tile_container, price_tile, price_tile_id);
	});




//show or hide website mobile menu settings menu
	$('nav.web_menu_mob').click(function (){
		$('nav.web_mob_menu').toggle();
	});
  
	$('nav.web_mob_menu').mouseleave(function (){
		$(this).hide();
	});

//faq accordian js 
	$('.firstpane p.faq_menu_head').click(function(){
    	$(this).css({'background-color': '#f6f6f6'}).next('div.faq_menu_body').slideToggle(300).siblings('div.faq_menu_body').slideUp('slow');
    	$(this).siblings().css({'background-color': '#f6f6f6'});
	});




});