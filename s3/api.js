

const hvp_lambda = "https://t33blvbzazbgf7vflqyp3tjhxy0hwddm.lambda-url.us-east-1.on.aws/";

//___________________________________________________________________
// Automatically handle common responses.
//___________________________________________________________________
$( document ).ajaxSuccess(function(event, jqXHR, params, resp) {
  if (resp['auth_token']) localStorage.setItem('auth_token', resp['auth_token']);
  if (resp['username'])   $('#username').text(resp['username']);
  if (resp['error'])      Swal.fire({ icon: "error", text: resp['error'] });
});

$( document ).ajaxError(function(event, jqXHR, params, thrownError) {
  Swal.fire({ icon: "warning", title: "AJAX Error", text: jqXHR.responseText });
});


//___________________________________________________________________
// AJAX wrapper for communicating with backend
//___________________________________________________________________
function api (args) {
  
  
  //-------------------------------------------------------
  // General/default xhr request parameters.
  //-------------------------------------------------------
  const params = {
    url  : hvp_lambda,
    type : "POST"
  };
  
  
  //-------------------------------------------------------
  // Configure the payload.
  // When uploading a file, use multipart/form-data.
  //-------------------------------------------------------
  const payload = args['payload'] || {};
  
  payload['auth_token'] = localStorage.getItem('auth_token');

  if (payload.constructor === FormData) {
    
    params['data']        = payload;
    params['contentType'] = false;
    params['processData'] = false;
    
  } else {
    
    params['data']        = JSON.stringify(payload);
    params['contentType'] = "application/json";
    params['dataType']    = "json";
  }
  
  
  //-------------------------------------------------------
  // Begin async processing with custom callbacks.
  //-------------------------------------------------------
  xhr = $.ajax(params);
  
  if (args['callback']) { xhr.done(args['callback']); }
  
  return xhr;
}
