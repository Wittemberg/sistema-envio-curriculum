library(shiny)
library(bslib)
library(readr)
library(glue)
library(blastula)
library(cli)
library(stringi)
library(fontawesome)
library(shinyjs)

source("R/01-config.R")
source("R/03-dados.R")
source("R/04-email.R")
source("R/05-ui.R")
source("R/02-server.R")

app_config <- read_config()

shinyApp(
  ui = ui,
  server = make_server(app_config)
)