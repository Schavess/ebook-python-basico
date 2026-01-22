# Script para instalar dependências Python no venv usando reticulate
# Execute este script após configurar reticulate

cat("========================================\n")
cat("Instalação de Dependências Python no venv\n")
cat("========================================\n\n")

# Carregar reticulate
if (!require("reticulate", quietly = TRUE)) {
  stop("reticulate não está instalado. Execute setup_reticulate.R primeiro.")
}
library(reticulate)

# Configurar venv usando caminho completo
venv_path <- normalizePath("venv", mustWork = FALSE)
use_virtualenv(venv_path, required = TRUE)

cat("Venv configurado: ", normalizePath(venv_path, mustWork = FALSE), "\n\n")

# Ler requirements.txt
requirements_file <- "requirements.txt"
if (!file.exists(requirements_file)) {
  stop(sprintf("Arquivo %s não encontrado!", requirements_file))
}

cat(sprintf("Lendo %s...\n", requirements_file))
requirements <- readLines(requirements_file)
requirements <- requirements[!grepl("^#", requirements) & nchar(trimws(requirements)) > 0]

cat(sprintf("Encontrados %d pacotes para instalar.\n\n", length(requirements)))

# Instalar cada pacote
for (req in requirements) {
  req <- trimws(req)
  if (nchar(req) == 0) next
  
  # Extrair nome do pacote (remover versão se houver)
  pkg_name <- gsub("([^>=<]+).*", "\\1", req)
  pkg_name <- trimws(pkg_name)
  
  cat(sprintf("Instalando %s...\n", req))
  tryCatch({
    py_install(req, envname = venv_path, pip = TRUE)
    cat(sprintf("  ✓ %s instalado\n", pkg_name))
  }, error = function(e) {
    cat(sprintf("  ✗ Erro ao instalar %s: %s\n", pkg_name, e$message))
  })
}

cat("\n========================================\n")
cat("Instalação concluída!\n")
cat("========================================\n\n")

# Verificar pacotes principais
cat("Verificando pacotes principais...\n")
main_packages <- c("numpy", "pandas", "matplotlib", "jupyter-book", "sphinx")

for (pkg in main_packages) {
  tryCatch({
    py_run_string(sprintf("import %s", gsub("-", "_", pkg)))
    cat(sprintf("  ✓ %s disponível\n", pkg))
  }, error = function(e) {
    cat(sprintf("  ✗ %s não disponível\n", pkg))
  })
}

cat("\n✓ Pronto para usar!\n")
