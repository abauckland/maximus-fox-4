

$(document).ready(function(){


//query for tabulated views	
$('ul.tabs, ul.tabs_2').each(function(){
    // For each set of tabs, we want to keep track of
    // which tab is active and it's associated content
    var $active, $content, $links = $(this).find('a');

    // If the location.hash matches one of the links, use that as the active tab.
    // If no match is found, use the first link as the initial active tab.
    $active = $($links.filter('[href="'+location.hash+'"]')[0] || $links[0]);
    $active.addClass('active');
    $content = $($active.attr('href'));

    // Hide the remaining content
    $links.not($active).each(function () {
        $($(this).attr('href')).hide();
    });

    // Bind the click event handler
    $(this).on('click', 'a', function(e){
        // Make the old tab inactive.
        $active.removeClass('active');
        $content.hide();

        // Update the variables with the new link and content
        $active = $(this);
        $content = $($(this).attr('href'));

        // Make the tab active.
        $active.addClass('active');
        $content.show();

        // Prevent the anchor's default click action
        e.preventDefault();
    });
});


//sortable specline
	$('.1, .2, .3, .4, .5, .6, 7, .8, .prelim_show').sortable({
		axis: 'y',
		cancel: '.clause_title, span',
		cursor: 'pointer',
		handle: 'td.prefixed_line_menu img',
		stop: function(event, ui){
			var sortorder=$(this).sortable('toArray');
			var moved = $(ui.item).attr('id');	
   
			$.ajax({
				type: 'put',
				url: '/speclines/'+moved+'/move_specline',
				dataType: 'script',
				data: 'table_id_array='+sortorder +'',
				complete: function(){}
			});   
		}	 		
	});

 $('table.specline_table').on({
    mouseenter:function(){ 
		$(this).css('background-color', '#efefef');
		$(this).find('td.prefixed_line_menu').css('visibility', 'visible');
		$(this).find('td.suffixed_line_menu').css('visibility', 'visible');
		$(this).find('td.suffixed_line_menu_mob').css('visibility', 'visible');
    },
    mouseleave:function(){ 
  		$(this).css('background-color', '#fff');
		$(this).find('td.prefixed_line_menu').css('visibility', 'hidden');
		$(this).find('td.suffixed_line_menu').css('visibility', 'hidden');
		$(this).find('td.suffixed_line_menu_mob').css('visibility', 'hidden');
    }
  });


  	
//show/hide specline mob menu
	$('.suffixed_line_menu_mob').click(function (){
		$(this).closest('table').find('.specline_mob_menu_popup').toggle();
	});
 
	$('tr.specline_mob_menu_popup').mouseleave(function (){
		$(this).hide();
	});
	


//show/hide functions for rev lines
	$('.rev_table').hover(function (){
		$(this).css('background-color', '#efefef');
		$(this).find('td.rev_line_menu').css('visibility', 'visible');
		$(this).find('td.rev_line_menu_mob').css('visibility', 'visible');
  	},
  	function (){
		$(this).css('background-color', '#fff');
		$(this).find('td.rev_line_menu').css('visibility', 'hidden');
		$(this).find('td.rev_line_menu_mob').css('visibility', 'hidden');
  	});

//show/hide rev mob menu
	$('.rev_line_menu_mob').click(function (){
		$(this).closest('table').find('.rev_mob_menu_popup').toggle();
	});
 
	$('tr.rev_mob_menu_popup').mouseleave(function (){
		$(this).hide();
	});


$.editable.addInputType('autogrow', {
                element : function(settings, original) {
                    var textarea = $('<textarea />');
                    if (settings.rows) {
                        textarea.attr('rows', settings.rows);
                    } else if (settings.height != "none") {
                        textarea.height(settings.height + 8);
                    }

                   	textarea.width(settings.width);	                       	                       	

                    textarea.css("font", "normal 12px arial").css("padding-top", "0px");
                    $(this).append(textarea);
                    return(textarea);
                },
    			plugin : function(settings, original) {
        			$('textarea', this).autogrow();
        			$('textarea', this).symbols();
    			},
});

$('.editable_text3').mouseover(function(){
var spec_id = $(this).attr('id');
$(this).editable('/speclines/'+spec_id+'/update_specline_3', {id: spec_id, width: ($(this).width() +10)+'px', type: 'text', onblur: 'submit', method: 'PUT', indicator: 'Saving..', submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}});    
}); 
$('.editable_text4').mouseover(function(){
var spec_id = $(this).attr('id');
var text_width = $(this).width();
$(this).editable('/speclines/'+spec_id+'/update_specline_4', {id: spec_id, width: ($(this).width() +10)+'px', type: 'autogrow', onblur: 'submit', method: 'PUT', indicator: 'Saving..', autogrow : {lineHeight : 16, maxHeight  : 512}, submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}});    
}); 
$('.editable_text5').mouseover(function(){
var spec_id = $(this).attr('id');
$(this).editable('/speclines/'+spec_id+'/update_specline_5', {id: spec_id, width: ($(this).width() +10)+'px', type: 'autogrow', onblur: 'submit', method: 'PUT', indicator: 'Saving..', autogrow : {lineHeight : 16, maxHeight  : 512}, submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}});    
});    
$('.editable_text6').mouseover(function(){
var spec_id = $(this).attr('id');
	$(this).editable('/speclines/'+spec_id+'/update_specline_6', {
		id: spec_id, width: ($(this).width() +10)+'px',
		type: 'text',
		onblur: 'submit',
		method: 'PUT',
		indicator: 'Saving..',
		submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
	});    
});    

$('.editable_xref').mouseover(function(){
var spec_id = $(this).attr('id');
	$(this).editable('http://specify.specright.co.uk/speclines/'+spec_id+'/update_specline_5', {
		id: spec_id, width: ($(this).width() +10)+'px',
		loadurl : 'http://specify.specright.co.uk/speclines/'+spec_id+'/xref_data',
		type: 'select',
		onblur: 'submit',
		method: 'PUT',
		indicator: 'Saving..',
		submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
	});    
});

$('.editable_product_key').mouseover(function(){
var spec_id = $(this).attr('id');
	$(this).editable_2('/speclines/'+spec_id+'/update_product_key', {
		id: spec_id, width: ($(this).width() +10)+'px',
		loadurl : 'http://specify.specright.co.uk/products/'+spec_id+'/product_keys',
		type: 'select',
		onblur: 'submit',
		method: 'PUT',
		indicator: 'Saving..',
		submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
	});    
});

$('.editable_product_value').mouseover(function(){
var spec_id = $(this).attr('id');
	$(this).editable_2('/speclines/'+spec_id+'/update_product_value', {
		id: spec_id, width: ($(this).width() +10)+'px',
		loadurl : 'http://specify.specright.co.uk/products/'+spec_id+'/product_values',
		type: 'select',
		onblur: 'submit',
		method: 'PUT',
		indicator: 'Saving..',
		submitdata: {_method: 'put', 'id': '<%= @line.id%>', authenticity_token: AUTH_TOKEN}
	});    
});





//specline linetype edit
$(document).on('click','.submittable2', function() {
 $(this).parents('form:first').submit();
   return false;
});

//new clause title template select
//$('#clone_template_id').change(function(){
//	var text = $('select#clone_clause_id option:selected').text();
//	$('select#clone_clause_id option:selected').text('updating...').css("color", "#006699");
//})


$('input#clause_content_clone_content').click(function (){
  $('select#clone_template_id').removeAttr('disabled');
	$('.column_submit').css('visibility', 'hidden');
    $('.clone_template').css('color', '#000');
    var template = $('input#clause_project_id').val();
    jQuery.get('/clauses/'+ template + '/new_clone_project_list');
});

$('select#clone_template_id').change(function (){
	$('.column_submit').css('visibility', 'hidden');
  	$('select#clone_section_id').attr('disabled', 'disabled');
  	$('select#clone_clause_id').attr('disabled', 'disabled');

});



$('input#clause_content_blank_content').click(function (){
  $('select#clone_template_id').attr('disabled', 'disabled');
  $('select#clone_section_id').attr('disabled', 'disabled');
  $('select#clone_clause_id').attr('disabled', 'disabled');
  $('.clone_template, .clone_section, .clone_clause').css('color', '#7b7b7b');
  $('.column_submit').css('visibility', 'visible');
  
	var select = $('select#clone_template_id');
	var length = select.options.length;
	for (i = 1; i < length; i++) {select.options[i] = null;}
	select.options[0] = 'Select Project';
});




//new clause reference field
var $enter_clause_ref = $('#enter_clause_ref');
        $enter_clause_ref.hide(); //hide input with type=password

        $("#enter_clause_ref_default").click(function() {
                $( this ).hide();
                $('#enter_clause_ref').show();
                $('#enter_clause_ref').focus();
        });

$('#enter_clause_ref').focusout(function() {
    if ($(this).val().length === 0) { //if password field is empty            
        $(this).hide();
        $('#enter_clause_ref_default').show();
        $('#enter_clause_ref_default').default_value('????'); //will clear on click
    }
});




$('span').filter(function(){
  return $(this).text() === 'Not specified';
}).css('color', 'blue');




//end
});
