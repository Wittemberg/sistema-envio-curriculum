# Sistema de envio de curriculos

Aplicacao web em R/Shiny para recebimento de curriculos da rede Porto Novo Supermercados.

O candidato preenche os dados, anexa o curriculo e o sistema envia o arquivo por SMTP para o RH, mantendo uma copia persistida no diretorio de uploads do servidor.

## Tecnologias

- R 4.4.1
- Shiny
- bslib / Bootstrap 5
- blastula
- shinyjs
- Docker, Portainer, Traefik e SSL em producao

## Estrutura

```text
app.R
R/
  01-config.R
  02-server.R
  03-dados.R
  04-email.R
  05-ui.R
www/
  logo.png
_config/
  smtp_config.example.csv
uploads/
```

## Configuracao

Copie o arquivo de exemplo e preencha os dados reais de SMTP:

```powershell
Copy-Item _config\smtp_config.example.csv _config\smtp_config.csv
```

O arquivo `_config/smtp_config.csv` contem credenciais e nao deve ser versionado.

## Execucao local

Abra o projeto no RStudio ou execute:

```r
shiny::runApp()
```

## Producao

No container, os uploads devem ser salvos em:

```text
/srv/shiny-server/uploads
```

O contexto completo do projeto esta documentado em `contexto.md`.
