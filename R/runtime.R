handler <- function(context) {
  return(jsonlite::toJSON(context))
}

lambdr::start_lambda()