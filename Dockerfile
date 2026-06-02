FROM rocker/shiny:4.4.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libicu-dev \
    libuv1 \
    libuv1-dev \
    pandoc \
  && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('shiny', 'bslib', 'readr', 'glue', 'blastula', 'cli', 'stringi', 'fontawesome', 'shinyjs'), repos = 'https://packagemanager.posit.co/cran/__linux__/jammy/latest')"

WORKDIR /srv/shiny-server

COPY app.R ./app.R
COPY R ./R
COPY www ./www

RUN mkdir -p /srv/shiny-server/_config /srv/shiny-server/uploads \
  && chown -R shiny:shiny /srv/shiny-server

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
