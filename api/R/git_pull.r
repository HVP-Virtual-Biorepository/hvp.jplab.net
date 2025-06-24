api_git_pull <- function () {
  
  odir <- getwd()
  on.exit(setwd(dir = odir))
  
  setwd(dir = '/var/www/hvp')
  system2('/usr/bin/git',  c('pull', 'origin', 'main'))
  system2('/usr/bin/sudo', c('/usr/sbin/apache2ctl', 'restart'))
}
