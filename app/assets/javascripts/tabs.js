//function for setting column width depending on size of window	
function tab_format(){
	if ($('ul').hasClass('tabs_2')) {
       var listWidth = 40;
		$('.tabs_2 li').each(function(){
    		listWidth += ($(this).outerWidth()+4);
		});
		if($(window).width() >= listWidth) {
			$('ul.tabs_2').removeClass('tabs_2').addClass('tabs');			
			var tab_content_top = 36 + $('.tabs').position().top - 4;
			$('.tab_content').css('top', tab_content_top+"px").css('border-top', "none");
		}
		else{
			var tab_content_top = $('.tabs_2').height() + $('.tabs_2').position().top +10;
			$('.tab_content').css('top', tab_content_top+"px");
		}				
	}
	if ($('ul').hasClass('tabs')) {
		var listWidth = 40;
		$('.tabs li').each(function(){
    		listWidth += ($(this).outerWidth()+4);
		});
		if($(window).width() <= listWidth) {
			$('ul.tabs').removeClass('tabs').addClass('tabs_2');			 
			var tab_content_top = $('.tabs_2').height() + $('.tabs_2').position().top + 10;
			$('.tab_content').css('top', tab_content_top+"px").css('border-top', "2px solid #dddddd");	
		}
		else{
			var tab_content_top = 36 + $('.tabs').position().top - 4;
			$('.tab_content').css('top', tab_content_top+"px").css('border-top', "none");
		}		
	}
}

function tab_2_label_width(){
//limit label size in document end tabs
	if ($(window).width()<400){
		$('.document_tabs ul').find('a').each(function(){
			var text=$(this).text();
			if (text.length>14)
				$(this).val(text).text(text.substr(0,11)+'..');
		});
	}	
}


$(document).ready(function(){

//variables for setting column widths - where 3 coloumns
var s_tab = '1240';
var mob = '720';
var limit = '310';

//Set size and location of elements depending on screen size	
	tab_format();
	tab_2_label_width();
	$(window).resize(function(){
		tab_format();
		tab_2_label_width();
	});


});