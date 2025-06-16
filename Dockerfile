FROM docker.io/rocker/r-ver:4.5.0

RUN Rscript -e "\
  options(warn = 2); \
  install.packages('pak'); \
  options(repos = c(CRAN = 'https://p3m.dev/cran/__linux__/jammy/2025-06-12')); \
  pak::pak(c('bcrypt', 'blastula', 'DBI', 'jsonlite', 'lambdr', 'openssl', 'readxl', 'RMariaDB'))"

# Lambda setup
RUN mkdir /R
COPY R/ /R
RUN chmod 755 -R /R

ENTRYPOINT ["Rscript", "R/runtime.R"]
CMD ["handler"]
