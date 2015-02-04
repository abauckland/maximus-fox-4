//function for setting height of edit box depending on height of window	
function tab_format(){
	var window_height = $(window).height();
	var edit_box_height = (window_height - 190);
	$('.document').height(edit_box_height);
}


$(document).ready(function(){

	tab_format();
	$(window).resize(function(){
		tab_format();
	});

});