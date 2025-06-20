options(warn = 2)
install.packages('pak')
options(repos = c(CRAN = 'https://p3m.dev/cran/__linux__/jammy/2025-06-20'))
pak::pak(c('bcrypt', 'blastula', 'DBI', 'jsonlite', 'openssl', 'readxl', 'RMariaDB'))"
