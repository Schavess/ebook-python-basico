Seja bem vindo xomano!! 

Este é um livro sobre **Python** criado com **bookdown** (https://github.com/rstudio/bookdown) e **reticulate** para executar código Python.

O livro apresenta os fundamentos e conceitos básicos da linguagem Python para programação e análise de dados.

## Como visualizar (renderizar) no RStudio

### Pacotes R Necessários

No Console do RStudio:

```r
install.packages(c("rmarkdown", "bookdown", "knitr", "reticulate"))
```

### Configuração do Python com reticulate

Este projeto usa **reticulate** para executar código Python dentro dos arquivos .Rmd. Para configurar:

1. **Instalar e configurar reticulate:**
   ```r
   source("setup_reticulate.R")
   ```

2. **Instalar dependências Python no venv:**
   ```r
   source("install_python_deps.R")
   ```

   Ou instale manualmente no venv:
   ```powershell
   .\venv\Scripts\Activate.ps1
   python -m pip install -r requirements.txt
   ```

3. **Verificar configuração:**
   ```r
   library(reticulate)
   use_virtualenv("venv", required = TRUE)
   py_config()
   ```

O chunk de setup já está configurado no `index.Rmd` e será executado automaticamente ao renderizar o livro.

### Renderizar o livro (HTML)

No Console do RStudio, com o projeto aberto (`Python_Basico.Rproj`):

```r
bookdown::render_book("index.Rmd", "bookdown::gitbook")
```

O resultado fica em `_book/index.html`.

### Servir e atualizar em tempo real (live preview)

O `serve_book()` recompila ao salvar os arquivos e atualiza o navegador automaticamente:

```r
install.packages("servr")
bookdown::serve_book()
```

## Criar um novo ebook a partir deste projeto

1) Copie a pasta do projeto para um novo diretório (ex.: `meu-novo-livro/`).

2) Edite os metadados do livro em `index.Rmd`:
- `title`
- `author`
- `cover-image` (troque a imagem em `images/` se quiser)
- `description`

3) Ajuste a lista e a ordem dos capítulos em `_bookdown.yml` (campo `rmd_files:`).

4) Troque o favicon/capa em `images/` se desejar:
- `images/favicon.ico` ou `images/favicon.png`
- `images/capa.png`

5) Renderize o livro (HTML):

```r
bookdown::render_book("index.Rmd", "bookdown::gitbook")
```

Additional resources:

The **bookdown** book: https://bookdown.org/yihui/bookdown/

The **bookdown** package reference site: https://pkgs.rstudio.com/bookdown
