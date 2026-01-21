Seja bem vindo xomano!! 

This is a minimal example of a book based on R Markdown and **bookdown** (https://github.com/rstudio/bookdown). 

This template provides a skeleton file structure that you can edit to create your book. 

The contents inside the .Rmd files provide some pointers to help you get started, but feel free to also delete the content in each file and start fresh.

## Como visualizar (renderizar) no RStudio

### Dependências

No Console do R:

```r
install.packages(c("rmarkdown", "bookdown", "knitr"))
```

### Renderizar o livro (HTML)

No Console do R, com o projeto aberto (`Entre Florestas e Dados.Rproj`):

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

## Criar um novo ebook a partir deste projeto (template)

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
