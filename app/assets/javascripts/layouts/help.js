$(document).ready(function(){

	$(".form_tooltip").qtip({ // Grab some elements to apply the tooltip to
	
   		show: 'mouseover',
   		hide: 'mouseout',
	    content: {
	        text: function(event, api) {
                
	            $.ajax({
	                url: 'http://specify.specright.co.uk/helps/'+$(this).attr('id'),
	                type: 'GET', // POST or GET
	                dataType: 'html',
	            })
	            .then(function(content) {
	                // Now we set the content manually (required!)
	                api.set('content.text', content);
	            }, function(xhr, status, error) {
	                // Upon failure... set the tooltip content to the status and error value
	                api.set('content.text', status + ': ' + error);
	            });
	            return 'Loading...';
	       }
	    },
	        position: {
	        my: 'top center',  // Position my top left...
	        at: 'bottom center', // at the bottom right of...
	    }
	});


	$(".title_help").qtip({ // Grab some elements to apply the tooltip to
	
   		show: 'mouseover',
   		hide: 'mouseout',
	    content: {
	        text: function(event, api) {
                
	            $.ajax({
	                url: 'https://specify.specright.co.uk/helps/'+$(this).attr('id'),
	                type: 'GET', // POST or GET
	                dataType: 'html',
	            })
	            .then(function(content) {
	                // Now we set the content manually (required!)
	                api.set('content.text', content);
	            }, function(xhr, status, error) {
	                // Upon failure... set the tooltip content to the status and error value
	                api.set('content.text', status + ': ' + error);
	            });
	            return 'Loading...';
	       }
	    },
	        position: {
	        my: 'top center',  // Position my top left...
	        at: 'bottom center', // at the bottom right of...
	    }
	});


});
