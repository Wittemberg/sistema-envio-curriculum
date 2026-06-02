# =========================================================
# SERVER
# =========================================================

make_server <- function(config) {
  force(config)
  
  function(input, output, session) {
    observeEvent(input$send, {
      output$message <- shiny::renderUI(NULL)
      
      tryCatch(
        {
          shiny::req(input$name)
          shiny::req(input$email)
          shiny::req(input$whatsapp)
          shiny::req(input$curriculum)
          
          shiny::withProgress(
            message = "Enviando currículo...",
            detail = "Preparando arquivo e enviando para o RH.",
            value = 0,
            {
              # -------------------------------------------
              # Validação do arquivo
              # -------------------------------------------
              shiny::incProgress(
                amount = 0.2,
                detail = "Validando arquivo."
              )
              
              validate_curriculum(
                file = input$curriculum,
                max_file_mb = as.numeric(config[["max_file_mb"]])
              )
              
              # -------------------------------------------
              # Salvamento local
              # -------------------------------------------
              shiny::incProgress(
                amount = 0.2,
                detail = "Salvando currículo."
              )
              
              attachment_path <- save_curriculum(
                file = input$curriculum,
                candidate_name = input$name
              )
              
              # -------------------------------------------
              # Monta dados do candidato
              # -------------------------------------------
              shiny::incProgress(
                amount = 0.1,
                detail = "Preparando dados."
              )
              
              candidate <- list(
                name = input$name,
                email = input$email,
                whatsapp = input$whatsapp,
                job = input$job
              )
              
              # -------------------------------------------
              # Envio do e-mail
              # -------------------------------------------
              shiny::incProgress(
                amount = 0.4,
                detail = "Enviando e-mail para o RH."
              )
              
              send_curriculum_email(
                candidate = candidate,
                attachment_path = attachment_path,
                config = config
              )
              
              # -------------------------------------------
              # Finalização
              # -------------------------------------------
              shiny::incProgress(
                amount = 0.1,
                detail = "Finalizando."
              )
            }
          )
          
          # -----------------------------------------------
          # Mensagem de sucesso
          # -----------------------------------------------
          output$message <- shiny::renderUI(
            shiny::div(
              class = "alert alert-success mt-3",
              fontawesome::fa("check-circle"),
              " Currículo enviado com sucesso!"
            )
          )
          
          # -----------------------------------------------
          # Limpa todo o formulário, inclusive o arquivo
          # -----------------------------------------------
          shinyjs::reset("curriculum_form")
          
          },
        
        # -----------------------------------------------
        # Tratamento de erros
        # -----------------------------------------------
        error = function(e) {
          output$message <- shiny::renderUI(
            shiny::div(
              class = "alert alert-danger mt-3",
              fontawesome::fa("triangle-exclamation"),
              " Erro: ",
              e$message
            )
          )
        }
      )
    })
  }
}