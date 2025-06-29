

//___________________________________________________________________
// Automatically handle common responses.
//___________________________________________________________________
$( document ).ajaxSuccess(function(event, jqXHR, params, resp) {
  if (resp['message']) display_message('success', resp['message']);
  if (resp['error'])   display_message('error',   resp['error']);
});

$( document ).ajaxError(function(event, jqXHR, params, thrownError) {
  display_message('error', jqXHR.responseText);
});


//___________________________________________________________________
// AJAX wrapper for communicating with backend
//___________________________________________________________________
function api (args) {
  
  
  //-------------------------------------------------------
  // Add a spinner to a button until xhr returns.
  //-------------------------------------------------------
  if (args['busy']) {
    args['busy'].attr('aria-busy', 'true');
  }
  
  
  //-------------------------------------------------------
  // General/default xhr request parameters.
  //-------------------------------------------------------
  
  
  //-------------------------------------------------------
  // Configure the payload.
  // When uploading a file, use multipart/form-data.
  //-------------------------------------------------------
  const payload = args['payload'] || {};
  
  payload['auth_token'] = localStorage.getItem('auth_token');

  if (payload.constructor === FormData) {
    
    xhr = $.ajax({
      url         : 'api',
      type        : 'POST',
      crossDomain : true,
      data        : payload,
      contentType : false,
      processData : false
    });
    
  } else {
    xhr = $.post('api', payload);
  }
  
  
  //-------------------------------------------------------
  // What to do after the xhr completes.
  //-------------------------------------------------------
  if (args['busy'])     { xhr.always(()   => { args['busy'].attr('aria-busy', 'false')    }); }
  if (args['modal'])    { xhr.always(()   => { closeModal(args['modal']);                 }); }
  if (args['callback']) { xhr.done((resp) => { if (!resp['error']) args['callback'](resp) }); }
  
  return xhr;
}
