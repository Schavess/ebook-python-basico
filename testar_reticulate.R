# Script para testar se reticulate está funcionando corretamente

library(reticulate)

cat("========================================\n")
cat("Teste do reticulate\n")
cat("========================================\n\n")

# Verificar Python
cat("1. Verificando Python...\n")
if (py_available()) {
  config <- py_config()
  cat(sprintf("✓ Python: %s\n", config$python))
  cat(sprintf("✓ Versão: %s\n\n", config$version))
} else {
  stop("Python não está disponível!")
}

# Configurar venv usando caminho completo
cat("2. Configurando venv...\n")
venv_path <- normalizePath("venv", mustWork = FALSE)
cat(sprintf("Caminho do venv: %s\n", venv_path))

if (dir.exists(venv_path)) {
  tryCatch({
    use_virtualenv(venv_path, required = TRUE)
    cat("✓ Venv configurado!\n\n")
  }, error = function(e) {
    cat("⚠️  Erro ao configurar venv: ", e$message, "\n")
    cat("Tentando usar Python diretamente...\n")
  })
} else {
  cat("⚠️  Diretório venv não encontrado!\n\n")
}

# Verificar configuração final
cat("3. Configuração final:\n")
config <- py_config()
cat(sprintf("Python: %s\n", config$python))
cat(sprintf("Versão: %s\n", config$version))

if (grepl("venv", config$python, ignore.case = TRUE)) {
  cat("✓ Usando Python do venv!\n\n")
} else {
  cat("⚠️  Não está usando o venv do projeto\n\n")
}

# Testar importação básica
cat("4. Testando importação básica...\n")
tryCatch({
  py_run_string("import sys")
  py_run_string("print('Python funcionando!')")
  cat("✓ Python básico funcionando!\n\n")
}, error = function(e) {
  cat("✗ Erro: ", e$message, "\n\n")
})

# Testar numpy (se instalado)
cat("5. Testando numpy...\n")
tryCatch({
  py_run_string("import numpy as np")
  cat("✓ numpy disponível!\n\n")
}, error = function(e) {
  cat("⚠️  numpy não encontrado (pode instalar depois)\n\n")
})

cat("========================================\n")
cat("Teste concluído!\n")
cat("========================================\n\n")

cat("Se tudo estiver OK, você pode:\n")
cat("1. Instalar dependências: source('install_python_deps.R')\n")
cat("2. Renderizar o livro: bookdown::render_book('index.Rmd')\n\n")
