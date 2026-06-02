# Sistema de envio de curriculos

Aplicacao web em R/Shiny para recebimento de curriculos.

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

## Deploy WRTEC

Este repositorio esta preparado para publicar a imagem Docker no GitHub Container Registry:

```text
ghcr.io/wittemberg/sistema-envio-curriculum:latest
```

A stack do Portainer esta em `docker-compose.yml` e usa:

- dominio: `curriculum.wrtec.com.br`
- rede Traefik: `interna`
- certresolver: `letsencryptresolver`
- volume de config: `/root/sistema-envio-curriculum/config`
- volume de uploads: `/root/sistema-envio-curriculum/uploads`

Antes de subir a stack no Portainer, criar no servidor:

```bash
mkdir -p /root/sistema-envio-curriculum/config
mkdir -p /root/sistema-envio-curriculum/uploads
chmod -R 777 /root/sistema-envio-curriculum/uploads
```

Depois, enviar o arquivo real de configuracao para:

```text
/root/sistema-envio-curriculum/config/smtp_config.csv
```

## GitHub Actions

O workflow `.github/workflows/docker.yml` faz build e push da imagem em todo push na branch `main`.

O redeploy no Portainer fica bloqueado por padrao. Para ativar depois que o DNS estiver criado e a stack pronta, configurar no GitHub:

- Secret: `PORTAINER_WEBHOOK_CURRICULUM`
- Variable: `ENABLE_PORTAINER_DEPLOY` com valor `true`

Enquanto a variavel nao existir ou nao for `true`, o workflow publica a imagem, mas nao chama o webhook do Portainer.

O contexto completo do projeto esta documentado em `contexto.md`.
