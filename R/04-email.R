send_curriculum_email <- function(candidate, attachment_path, config) {
  subject <- glue::glue("Novo currículo recebido - {candidate$name}")
  
  body <- glue::glue("
## Novo currículo recebido

**Nome:** {candidate$name}  
**Email:** {candidate$email}  
**WhatsApp:** {candidate$whatsapp}  
**Vaga desejada:** {candidate$job}

Currículo em anexo.
")
  
  email <- blastula::compose_email(
    body = blastula::md(body)
  ) |>
    blastula::add_attachment(file = attachment_path)
  
  smtp_password_env <- "SMTP_SENHA_CURRICULUM"
  
  do.call(
    Sys.setenv,
    stats::setNames(
      as.list(as.character(config[["smtp_password"]])),
      smtp_password_env
    )
  )
  
  credentials <- blastula::creds_envvar(
    user = as.character(config[["smtp_user"]]),
    pass_envvar = smtp_password_env,
    host = as.character(config[["smtp_host"]]),
    port = as.numeric(config[["smtp_port"]]),
    use_ssl = TRUE
  )
  
  blastula::smtp_send(
    email = email,
    from = as.character(config[["smtp_from"]]),
    to = as.character(config[["rh_email"]]),
    subject = as.character(subject),
    credentials = credentials
  )
  
  TRUE
}