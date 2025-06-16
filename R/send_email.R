
#______________________________________________________________________________
#' Send an email for email verifications, password resets, etc.
#' 
send_email <- function (to, subject, message) {
  tryCatch(
    error = function (e) stop("Unable to send email.", e),
    expr  = {
      
      #________________________________________________________
      # Blastula wants to read credentials from a json file.
      #________________________________________________________
      creds <- paste0(
        '{',
          '"type":"list",',
          '"attributes":{',
            '"names":{',
              '"type":"character",',
              '"attributes":{},',
              '"value":["version","host","port","use_ssl","user","password"]}},',
          '"value":[',
            '{"type":"integer","attributes":{},"value":[1]},',
            '{"type":"character","attributes":{},"value":["', Sys.getenv('SMTP_SERVER'),   '"]},',
            '{"type":"double","attributes":{},"value":[',     Sys.getenv('SMTP_PORT'),     ']},',
            '{"type":"logical","attributes":{},"value":[',    Sys.getenv('SMTP_SSL'),      ']},',
            '{"type":"character","attributes":{},"value":["', Sys.getenv('SMTP_USERNAME'), '"]},',
            '{"type":"character","attributes":{},"value":["', Sys.getenv('SMTP_PASSWORD'), '"]}]}\n' )
      
      creds_file <- tempfile()
      on.exit(unlink(creds_file))
      writeChar(con = creds_file, object = creds, eos = NULL)
      creds <- blastula::creds_file(file = creds_file)
      
      
      #________________________________________________________
      # Ensure message is a proper blastula object.
      #________________________________________________________
      if (!is(message, 'blastula_message')) {
        footer  <- blastula::md("sent by the [HVP Virtual Biorepository](https://hvp.jplab.net)")
        message <- blastula::compose_email(body = message, footer = footer)
      }
      
      
      #________________________________________________________
      # Transmit the message.
      #________________________________________________________
      blastula::smtp_send(
          email       = message,
          to          = to,
          from        = Sys.getenv('SMTP_FROMADDR'), 
          subject     = subject, 
          credentials = creds )
    })
}