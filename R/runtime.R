
handler <- function(context, ...) {
  source('https://raw.githubusercontent.com/cmmr/hvp.jplab.net/refs/heads/master/R/functions.R')
  return (response(context, ...))
}
lambdr::start_lambda()
