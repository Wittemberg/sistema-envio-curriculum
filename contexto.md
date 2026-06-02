# CONTEXTO DO PROJETO — SISTEMA DE ENVIO DE CURRÍCULOS

## Objetivo

Desenvolver e manter um sistema web para recebimento de currículos da rede de supermercados Porto Novo.

O sistema permite que candidatos:

1. Preencham seus dados.
2. Anexem um currículo.
3. Enviem para o RH.
4. Recebam confirmação visual do envio.

---

# Cliente

Porto Novo Supermercados

---

# Tecnologias

## Backend

- R 4.4.1
- Shiny
- blastula
- shinyjs

## Frontend

- Bootstrap 5 (bslib)
- CSS customizado

## Infraestrutura

- Docker
- Portainer
- Traefik
- SSL (Let's Encrypt)

---

# Domínio

```text
https://curriculum.awecloudsolution.com
```

---

# Estrutura do Projeto

```text
curriculum-app/
│
├── app.R
│
├── R/
│   ├── 01-config.R
│   ├── 02-server.R
│   ├── 03-dados.R
│   ├── 04-email.R
│   └── 05-ui.R
│
├── www/
│   └── logo.png
│
├── _config/
│   └── smtp_config.csv
│
└── uploads/
```

---

# Arquitetura

O sistema é modular.

Cada responsabilidade está isolada em um arquivo.

---

# app.R

Responsável por:

- carregar bibliotecas;
- carregar módulos;
- ler configurações;
- iniciar o Shiny.

Fluxo:

```r
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
```

---

# 01-config.R

Responsável pela leitura do CSV de configuração.

Função principal:

```r
read_config()
```

Lê:

```csv
key,value
smtp_host,smtppro.zoho.com
smtp_port,465
smtp_user,email@empresa.com
smtp_password,SENHA
smtp_from,email@empresa.com
rh_email,rh@empresa.com
max_file_mb,5
```

Retorna:

```r
named vector
```

Exemplo:

```r
config[["smtp_host"]]
```

---

# 03-dados.R

Responsável por:

- validação dos arquivos;
- sanitização dos nomes;
- salvamento dos currículos.

---

## Extensões permitidas

```text
pdf
doc
docx
txt
```

---

## Limite

Configurável:

```csv
max_file_mb
```

Padrão:

```text
5 MB
```

---

## Sanitização

Remove:

- acentos;
- caracteres especiais;
- espaços.

Exemplo:

```text
Wittemberg Mesquita de Oliveira
```

vira:

```text
wittemberg-mesquita-de-oliveira
```

---

## Salvamento

IMPORTANTE:

Foi abandonado o pacote `fs`.

Motivo:

```text
libuv.so.1 not found
```

em Docker.

---

### Implementação atual

Usar:

```r
dir.create()
```

e

```r
file.copy()
```

---

### Caminho absoluto

Obrigatório:

```r
upload_dir <- "/srv/shiny-server/uploads"
```

Nunca utilizar:

```r
uploads/
```

pois falha em produção.

---

### Nome final do arquivo

Formato:

```text
20260513-195023-wittemberg-mesquita-de-oliveira.pdf
```

---

# 04-email.R

Responsável pelo envio SMTP.

---

# MUITO IMPORTANTE

NÃO utilizar:

```r
creds()
```

com:

```r
pass=
```

ou

```r
password=
```

A versão do blastula utilizada no servidor não suporta.

---

## Implementação correta

Utilizar:

```r
blastula::creds_envvar()
```

---

### Fluxo

```r
Sys.setenv()
↓
creds_envvar()
↓
smtp_send()
```

---

## SMTP

Servidor atual:

```text
Host: smtppro.zoho.com
Porta: 465
SSL: TRUE
```

---

## Dados enviados ao RH

Corpo do e-mail:

- Nome
- Email
- WhatsApp
- Vaga desejada

Anexo:

- currículo enviado

---

# 05-ui.R

Responsável pela interface.

---

# Identidade Visual

Baseada na marca Porto Novo.

---

## Azul principal

```css
#0057A8
```

---

## Vermelho principal

```css
#E30613
```

---

# Estrutura da página

## Header

Contém:

- logo;
- título;
- subtítulo.

---

## Formulário

Campos:

```text
Nome completo
Email
WhatsApp
Vaga desejada
Currículo
```

---

## Botão

Texto:

```text
Enviar currículo
```

Cor:

```css
#E30613
```

Hover:

```css
#0057A8
```

---

# shinyjs

Utilizado para resetar o formulário.

---

## Configuração

UI:

```r
shinyjs::useShinyjs()
```

---

## Formulário

Todo formulário deve ficar dentro:

```r
div(
  id = "curriculum_form"
)
```

---

## Reset

Após envio:

```r
shinyjs::reset("curriculum_form")
```

---

# 02-server.R

Responsável por:

- validação;
- upload;
- envio SMTP;
- feedback visual.

---

# Estrutura

A função principal é:

```r
make_server <- function(config)
```

NÃO utilizar:

```r
server <- function(...)
```

---

# Fluxo

```text
Usuário envia
↓
Validação
↓
Salvamento
↓
Montagem do e-mail
↓
SMTP
↓
Sucesso
↓
Reset do formulário
```

---

# Barra de progresso

Implementada com:

```r
withProgress()
```

Etapas:

```text
Validando arquivo
Salvando currículo
Preparando dados
Enviando e-mail
Finalizando
```

---

# Mensagens

Sucesso:

```r
alert-success
```

Erro:

```r
alert-danger
```

---

# NÃO UTILIZAR

```r
bslib::alert()
```

Motivo:

```text
não existe na versão instalada
```

---

# Infraestrutura

Servidor:

Docker + Portainer

---

# Estrutura no Host

```text
/root/curriculum-app/
│
├── app/
├── config/
└── uploads/
```

---

# Volumes

```yaml
volumes:
  - /root/curriculum-app/app:/app
  - /root/curriculum-app/config:/srv/shiny-server/_config
  - /root/curriculum-app/uploads:/srv/shiny-server/uploads
```

---

# Uploads

Todos os currículos ficam em:

```text
/root/curriculum-app/uploads
```

e dentro do container:

```text
/srv/shiny-server/uploads
```

---

# Permissões

Necessárias:

```bash
chmod -R 777 /root/curriculum-app/uploads
```

e

```bash
chmod -R 777 /srv/shiny-server/uploads
```

---

# Problemas Históricos do Projeto

## Problema 1

```text
app_config not found
```

### Solução

Usar:

```r
make_server(app_config)
```

---

## Problema 2

```text
updateFileInput não existe
```

### Solução

```r
shinyjs::reset()
```

---

## Problema 3

```text
bslib::alert não existe
```

### Solução

```r
div(
  class = "alert ..."
)
```

---

## Problema 4

```text
blastula creds password/pass
```

### Solução

```r
creds_envvar()
```

---

## Problema 5

```text
fs -> libuv.so.1
```

### Solução

Remover completamente a dependência do pacote `fs`.

---

## Problema 6

```text
No such file or directory
uploads/arquivo.pdf
```

### Solução

Utilizar caminho absoluto:

```r
/srv/shiny-server/uploads
```

---

# Estado Atual

Sistema funcional.

Funcionalidades validadas:

- Upload de currículo
- Validação de arquivo
- SMTP
- Anexo no e-mail
- Barra de progresso
- Reset do formulário
- Interface Porto Novo
- SSL
- Deploy via Portainer
- Persistência dos uploads

---

# Próximas Melhorias Sugeridas

## Banco de Dados

Registrar:

- candidatos;
- data/hora;
- vaga.

Sugestão:

```text
SQLite
```

---

## Painel Administrativo

Listar:

- currículos;
- candidatos;
- filtros.

---

## Anti-Spam

Adicionar:

- Cloudflare Turnstile

ou

- Google reCAPTCHA

---

## Logs

Criar:

```text
logs/envios.csv
```

para auditoria.