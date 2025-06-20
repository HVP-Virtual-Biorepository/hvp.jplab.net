api_git_pull <- function () {
  system2('/usr/bin/bash', shQuote('/var/www/hvp/bin/update.sh'))
}
