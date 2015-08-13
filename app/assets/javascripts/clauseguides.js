$(document).ready(function(){

	$('select#clone_guide_section_id').change(function (){
	    var section = $('select#clone_guide_section_id').val();
	    var plan = $('input#plan_id').val();
	    jQuery.get('/clauseguides/'+ section + '/clone_clause_list?plan_id=' + plan);
	});


//	$('input#search_text').click(function (){
//	    var clauseguide_id = $('input#clauseguide_id').val();
//	    var text = $('input#search_text').val();
//	    jQuery.get('/clauseguides/'+ clauseguide_id +'/assign?search_text=' + text );
//	});


//end
});
