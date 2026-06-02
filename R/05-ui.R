# =========================================================
# INTERFACE
# =========================================================

ui <- bslib::page_fluid(
  shinyjs::useShinyjs(),
  
  theme = bslib::bs_theme(
    version = 5,
    primary = "#0057A8",
    secondary = "#E30613",
    base_font = bslib::font_google("Inter")
  ),
  
  shiny::tags$style(shiny::HTML("
    body {
      background: #f5f7fb;
    }

    .main-card {
      max-width: 620px;
      margin: 32px auto;
      border: 0;
      border-radius: 18px;
      box-shadow: 0 8px 24px rgba(0, 87, 168, 0.14);
      overflow: hidden;
    }

    .brand-header {
      background: #0057A8;
      color: white;
      text-align: center;
      padding: 28px 24px;
      border-bottom: 8px solid #E30613;
    }

    .brand-logo {
      max-width: 340px;
      width: 100%;
      margin-bottom: 16px;
    }

    .brand-title {
      font-size: 28px;
      font-weight: 800;
      margin: 0;
    }

    .brand-subtitle {
      margin: 8px 0 0;
      opacity: 0.95;
    }

    .form-body {
      padding: 28px;
      background: white;
    }

    .btn-submit {
      background: #E30613;
      border-color: #E30613;
      color: white;
      font-weight: 700;
      padding: 12px 22px;
      border-radius: 999px;
      min-width: 190px;
    }

    .btn-submit:hover,
    .btn-submit:focus {
      background: #0057A8;
      border-color: #0057A8;
      color: white;
    }

    .form-control:focus {
      border-color: #0057A8;
      box-shadow: 0 0 0 0.2rem rgba(0, 87, 168, 0.18);
    }

    .submit-area {
      text-align: right;
      margin-top: 18px;
    }
  ")),
  
  bslib::card(
    class = "main-card",
    
    shiny::div(
      class = "brand-header",
      shiny::img(
        src = "logo.png",
        class = "brand-logo"
      ),
      shiny::h1(
        class = "brand-title",
        "Trabalhe conosco"
      ),
      shiny::p(
        class = "brand-subtitle",
        "Envie seu currículo para nossa equipe de RH."
      )
    ),
    
    shiny::div(
      class = "form-body",
      
      shiny::p(
        "Preencha seus dados e envie seu currículo em PDF, DOC, DOCX ou TXT."
      ),
      
      # ---------------------------------------------------
      # Formulário completo (necessário para shinyjs::reset)
      # ---------------------------------------------------
      shiny::div(
        id = "curriculum_form",
        
        shiny::textInput(
          "name",
          "Nome completo"
        ),
        
        shiny::textInput(
          "email",
          "Email"
        ),
        
        shiny::textInput(
          "whatsapp",
          "WhatsApp"
        ),
        
        shiny::textInput(
          "job",
          "Vaga desejada"
        ),
        
        shiny::fileInput(
          "curriculum",
          "Currículo",
          accept = c(".pdf", ".doc", ".docx", ".txt")
        ),
        
        shiny::div(
          class = "submit-area",
          shiny::actionButton(
            "send",
            "Enviar currículo",
            class = "btn-submit"
          )
        )
      ),
      
      shiny::uiOutput("message")
    )
  )
)