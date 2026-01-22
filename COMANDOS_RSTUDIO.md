# Comandos RStudio para Servir o Ebook no Navegador

## Instalação de Dependências

No Console do RStudio, execute:

```r
install.packages(c("rmarkdown", "bookdown", "knitr", "servr"))
```

## Servir o Livro no Navegador (Live Preview)

O comando `serve_book()` compila o livro e abre automaticamente no navegador, atualizando em tempo real quando você salva os arquivos:

```r
bookdown::serve_book()
```

Este comando:
- Renderiza o livro automaticamente
- Abre no navegador padrão
- Atualiza automaticamente quando você salva alterações nos arquivos `.Rmd`
- Para parar, pressione `Esc` no Console ou feche a janela do servidor

## Renderizar o Livro (HTML) Manualmente

Se preferir renderizar manualmente sem o servidor:

```r
bookdown::render_book("index.Rmd", "bookdown::gitbook")
```

O resultado ficará em `_book/index.html`. Você pode abrir este arquivo diretamente no navegador.

## Renderizar Formato Específico

### HTML (GitBook)
```r
bookdown::render_book("index.Rmd", "bookdown::gitbook")
```

### PDF
```r
bookdown::render_book("index.Rmd", "bookdown::pdf_book")
```

### EPUB
```r
bookdown::render_book("index.Rmd", "bookdown::epub_book")
```

## Limpar Arquivos Gerados

Para limpar os arquivos de build anteriores:

```r
bookdown::clean_book()
```

## Dicas

- **Live Preview**: Use `serve_book()` durante o desenvolvimento para ver as mudanças em tempo real
- **Build Completo**: Use `render_book()` quando quiser gerar uma versão final para distribuição
- **Parar o Servidor**: Pressione `Esc` no Console do RStudio ou clique no botão de parar (Stop) na barra de ferramentas

## Otimizar Performance

Se `serve_book()` estiver lento:

1. **Preview de capítulo individual (mais rápido):**
   ```r
   bookdown::preview_chapter("3_conversoes_e_operacoes.Rmd")
   ```

2. **Renderizar manualmente (recomendado):**
   ```r
   bookdown::render_book("index.Rmd")
   # Depois abra _book/index.html no navegador
   ```

3. **Durante escrita, use eval=FALSE:**
   ````python
   ```{python, eval=FALSE}
   # Código que você está escrevendo
   ```
   ````
