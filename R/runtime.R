
handler <- function(context, ...) {
  source(
    file = 'https://raw.githubusercontent.com/cmmr/hvp.jplab.net/refs/heads/master/R/functions.R',
    local = TRUE )
  return (response(context, ...))
}

lambdr::start_lambda()
