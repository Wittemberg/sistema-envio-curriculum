# =========================================================
# CONFIGURAÇÕES GERAIS
# =========================================================

read_config <- function(path = "_config/smtp_config.csv") {
  if (!file.exists(path)) {
    cli::cli_abort("Arquivo de configuração não encontrado: {.path {path}}.")
  }

  config <- readr::read_csv(path, show_col_types = FALSE)

  required_columns <- c("key", "value")

  if (!all(required_columns %in% names(config))) {
    cli::cli_abort("O arquivo de configuração precisa ter as colunas `key` e `value`.")
  }

  stats::setNames(config$value, config$key)
}
