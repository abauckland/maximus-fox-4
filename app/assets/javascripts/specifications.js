//function for setting height of edit box depending on height of window	
function doc_format(){
	var window_height = $(window).height();
	var edit_box_height = (window_height - 190);
	$('.document').height(edit_box_height);
}


$(document).ready(function(){

	doc_format();
	$(window).resize(function(){
		doc_format();
	});

});