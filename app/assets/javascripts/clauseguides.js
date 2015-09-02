$(document).ready(function(){

	$('select#clone_guide_section_id').change(function (){
	    var section = $('select#clone_guide_section_id').val();
	    var plan = $('input#plan_id').val();
	    $('select#clone_guide_clause_id').attr('disabled', 'disabled');
	    jQuery.get('/clauseguides/'+ section + '/clone_clause_list?plan_id=' + plan);
	});

});
