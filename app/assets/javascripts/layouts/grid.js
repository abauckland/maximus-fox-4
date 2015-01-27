function separate_column_height(tab_lndscp, tab_prtrt) {

	var col_1 = $('.column_1').height();
	var col_2 = $('.column_2').height();		
	var col_3 = $('.column_3').height();	
	
	var highestCol = Math.max(col_1, col_2, col_3);

	var window_width = $(window).width();

	if(window_width <= tab_prtrt) {
		$('.column_1, .column_2, .column_3').css('height','auto');
		$('.column_2, .column_3').find('.border').css('border','none').css('padding','0px');
	}else if(window_width <= tab_lndscp && window_width > tab_prtrt) {
		$('.column_1, .column_2').height(highestCol+'px');
		$('.column_1, .column_2').find('.border').css('border','solid 1px #888888').css('padding','12px');		

		$('.column_3').css('height','auto');
		$('.column_3').find('.border').css('border','none').css('padding','0px');
	}else{
		$('.column_1, .column_2, .column_3').height(highestCol+'px');
		$('.column_1, .column_2, .column_3').find('.border').css('border','solid 1px #888888').css('padding','12px');
	}	
};



$(document).ready(function(){

	var tab_lndscp = '960';
	var tab_prtrt = '760';
	var mob_lndscp = '480';
	var mob_prtrt = '320';
	
	separate_column_height(tab_lndscp, tab_prtrt);
	$(window).resize(function(){
		separate_column_height(tab_lndscp, tab_prtrt);
	});
	
});