# Script simplificado para configurar reticulate
# Use este se o setup_reticulate.R não funcionar

cat("========================================\n")
cat("Configuração Simplificada do reticulate\n")
cat("========================================\n\n")

# 1. Carregar reticulate
if (!require("reticulate", quietly = TRUE)) {
  install.packages("reticulate")
}
library(reticulate)

cat("[1/3] reticulate carregado!\n\n")

# 2. Verificar Python atual
cat("[2/3] Verificando Python...\n")
if (py_available()) {
  config <- py_config()
  cat(sprintf("✓ Python já disponível: %s\n", config$python))
  cat(sprintf("Versão: %s\n\n", config$version))
} else {
  cat("⚠️  Python não está disponível.\n")
  cat("Por favor, configure o Python no RStudio:\n")
  cat("Tools > Global Options > Python\n")
  cat("Ou use: reticulate::use_python('caminho/para/python.exe')\n\n")
  stop("Python não configurado.")
}

# 3. Configurar venv
cat("[3/3] Configurando ambiente virtual...\n")
venv_path <- "venv"

if (!dir.exists(venv_path)) {
  cat("Criando venv...\n")
  virtualenv_create(envname = venv_path)
  cat("✓ Venv criado!\n\n")
} else {
  cat(sprintf("✓ Venv existente encontrado: %s\n", normalizePath(venv_path, mustWork = FALSE)))
}

# Ativar venv
tryCatch({
  use_virtualenv(venv_path, required = TRUE)
  cat("✓ Venv configurado!\n\n")
  
  # Verificar configuração final
  config <- py_config()
  cat("Configuração final:\n")
  cat(sprintf("  Python: %s\n", config$python))
  cat(sprintf("  Versão: %s\n", config$version))
  
  if (grepl("venv", config$python, ignore.case = TRUE)) {
    cat("  ✓ Usando Python do venv!\n\n")
  }
  
}, error = function(e) {
  cat("⚠️  Aviso ao configurar venv: ", e$message, "\n")
  cat("O Python pode estar funcionando mesmo assim.\n\n")
})

cat("========================================\n")
cat("Configuração concluída!\n")
cat("========================================\n\n")
cat("Próximo passo: Instalar dependências Python\n")
cat("  source('install_python_deps.R')\n\n")
