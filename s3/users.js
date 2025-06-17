
$( document ).ready(function() {
  
  const set_user = function (resp) {
    
    if (resp['auth_token']) {
      localStorage.setItem('auth_token', resp['auth_token']);
      $('body').removeClass('guest');
    }
    else if (resp['auth_token'] === '') {
      localStorage.removeItem('auth_token');
      $('body').addClass('guest');
      $('#username').text('');
      $('#full_name').val('');
      $('#affiliation').val('');
      $('#home_link').trigger('click');
    }
    
    if (resp['full_name'] !== undefined) {
      $('#username').text(resp['full_name'] || resp['email']);
      $('#full_name').val(resp['full_name']);
    }
    
    if (resp['affiliation'] !== undefined) {
      $('#affiliation').val(resp['affiliation']);
    }
    
  }
  
  
  /* Auto Log In */
  api({
    callback : set_user,
    payload  : { action: "token_login" }
  });

  
  /* Log In */
  $('#login_btn').on('click', function(e) {

    api({
      busy     : $(this),
      callback : set_user,
      payload  : { 
        action   : "log_in",
        email    : $('#email').val(),
        password : $('#password').val() }
    });
    
  });
  
  
  /* Log Out */
  $('#log_out_icon').on('click', function(e) {
    api({
      callback : set_user,
      payload: { action: "log_out" }
    });
  });
  
  
  
  /* My Account */
  $('#my_acct_icon').on('click', function(e) {
    openModal($('#my_acct_modal')[0]);
  });
  
  $('#my_acct_save').on('click', function(e) {
    api({
      busy     : $(this),
      callback : set_user,
      payload  : {
        action      : "my_acct", 
        full_name   : $('#full_name').val(),
        affiliation : $('#affiliation').val()
      }
    });
  });
  
  
  /* Add Users */
  $('#add_users_icon').on('click', function(e) {
    openModal($('#add_users_modal')[0]);
  });
  
  $('#add_users_save').on('click', function(e) {
    api({
      busy    : $(this),
      payload : {
        action : "add_users", 
        emails : $('#emails').val()
      }
    });
  });
  
  
  /* Register Account */
  $('#register_acct_link').on('click', function(e) {
    display_message(
      'Register Account', 
      'Please ask a current user to create a user account for you.' );
  });
  
  
  /* Forgot Password */
  $('#forgot_pw_link').on('click', function(e) {
    openModal($('#forgot_pw_modal')[0]);
  });
  
  
});
