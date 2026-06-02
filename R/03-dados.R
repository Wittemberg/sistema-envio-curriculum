# =========================================================
# FUNÇÕES DE DADOS
# =========================================================

sanitize_file_name <- function(x) {
  x |>
    stringi::stri_trans_general("Latin-ASCII") |>
    tolower() |>
    gsub("[^a-z0-9]+", "-", x = _) |>
    gsub("(^-|-$)", "", x = _)
}

validate_curriculum <- function(file, max_file_mb) {
  allowed_extensions <- c("pdf", "doc", "docx", "txt")

  extension <- tolower(tools::file_ext(file$name))
  size_mb <- file$size / 1024 / 1024

  if (!extension %in% allowed_extensions) {
    cli::cli_abort("Formato inválido. Envie PDF, DOC, DOCX ou TXT.")
  }

  if (size_mb > max_file_mb) {
    cli::cli_abort("O arquivo deve ter no máximo {max_file_mb} MB.")
  }

  invisible(TRUE)
}

save_curriculum <- function(file, candidate_name) {
  upload_dir <- "/srv/shiny-server/uploads"
  
  dir.create(
    upload_dir,
    showWarnings = FALSE,
    recursive = TRUE
  )
  
  safe_name <- sanitize_file_name(candidate_name)
  extension <- tolower(tools::file_ext(file$name))
  timestamp <- format(Sys.time(), "%Y%m%d-%H%M%S")
  
  destination <- file.path(
    upload_dir,
    glue::glue("{timestamp}-{safe_name}.{extension}")
  )
  
  copied <- file.copy(
    from = file$datapath,
    to = destination,
    overwrite = TRUE
  )
  
  if (!copied) {
    stop("Não foi possível salvar o currículo na pasta uploads.")
  }
  
  destination
}