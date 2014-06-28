// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.sortable
//= require core
//= require projects
//= require jquery.jeditable
//= require jquery.selectBox
//= require jquery.selection
//= require autogrow
//= require symbols
//= require jquery.tipsy

$(document).ready(function(){
$('.menu_container').prepend('<div id="indicatorContainer"><div id="pIndicator"><div id="cIndicator"></div></div></div>');
    var activeElement = $('.menu_container>ul>li:first');

    $('.menu_container>ul>li').each(function() {
        if ($(this).hasClass('active')) {
            activeElement = $(this);
        }
    });


	var posLeft = activeElement.position().left;
	var elementWidth = activeElement.width();
	posLeft = posLeft + elementWidth/2 -6;
	if (activeElement.hasClass('has-sub')) {
		posLeft -= 6;
	}

	$('.menu_container #pIndicator').css('left', posLeft);
	var element, leftPos, indicator = $('.menu_container pIndicator');
	
	$(".menu_container>ul>li").hover(function() {
        element = $(this);
        var w = element.width();
        if ($(this).hasClass('has-sub'))
        {
        	leftPos = element.position().left + w/2 - 12;
        }
        else {
        	leftPos = element.position().left + w/2 - 6;
        }

        $('.menu_container #pIndicator').css('left', leftPos);
    }
    , function() {
    	$('.menu_container #pIndicator').css('left', posLeft);
    });


	$('.menu_container>ul>.has-sub>ul').append('<div class="submenuArrow"></div>');
	$('.menu_container>ul').children('.has-sub').each(function() {
		var posLeftArrow = $(this).width();
		posLeftArrow /= 2;
		posLeftArrow -= 12;
		$(this).find('.submenuArrow').css('left', posLeftArrow);

	});

	$('.menu_container>ul').prepend('<li id="menu-button"><a>MENU</a></li>');
	$( "#menu-button" ).click(function(){
    		if ($(this).parent().hasClass('open')) {
    			$(this).parent().removeClass('open');
    		}
    		else {
    			$(this).parent().addClass('open');
    		}
    	});
});