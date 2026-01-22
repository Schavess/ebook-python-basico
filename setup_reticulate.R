# Script para configurar reticulate no projeto bookdown
# Execute este script no RStudio Console ou R Console

cat("========================================\n")
cat("Configuração do reticulate para bookdown\n")
cat("========================================\n\n")

# 1. Instalar reticulate se necessário
cat("[1/4] Verificando instalação do reticulate...\n")
if (!require("reticulate", quietly = TRUE)) {
  cat("Instalando reticulate...\n")
  install.packages("reticulate")
  library(reticulate)
  cat("✓ reticulate instalado!\n\n")
} else {
  library(reticulate)
  cat("✓ reticulate já está instalado!\n\n")
}

# 2. Verificar se Python está disponível
cat("[2/4] Verificando Python...\n")

# Verificar se Python já foi inicializado
if (py_available()) {
  config <- py_config()
  cat(sprintf("Python já inicializado: %s\n", config$python))
  cat(sprintf("Versão: %s\n", config$version))
  
  # Se estiver usando o venv, isso é perfeito!
  if (grepl("venv", config$python, ignore.case = TRUE)) {
    cat("✓ Usando Python do venv (recomendado)!\n\n")
  } else {
    cat("⚠️  Python do sistema em uso. Recomendado usar venv.\n\n")
  }
} else if (!py_available()) {
  # Tentar descobrir Python automaticamente
  cat("Python não encontrado automaticamente. Tentando descobrir...\n")
  
  # Tentar descobrir configuração Python
  python_configured <- FALSE
  tryCatch({
    config <- py_discover_config()
    if (!is.null(config$python) && file.exists(config$python)) {
      cat(sprintf("Python descoberto em: %s\n", config$python))
      
      # Priorizar Python do venv se encontrado
      if (grepl("venv", config$python, ignore.case = TRUE)) {
        cat("✓ Python do venv encontrado (recomendado)!\n")
        tryCatch({
          use_python(config$python, required = TRUE)
          if (py_available()) {
            python_configured <- TRUE
            cat("✓ Python do venv configurado com sucesso!\n\n")
          }
        }, error = function(e) {
          cat("Aviso: Não foi possível usar Python do venv. Tentando outros...\n")
        })
      } else {
        # Tentar usar Python descoberto (mas não do venv)
        tryCatch({
          use_python(config$python, required = TRUE)
          if (py_available()) {
            python_configured <- TRUE
            cat("✓ Python configurado com sucesso!\n\n")
          }
        }, error = function(e) {
          cat("Não foi possível usar este Python. Continuando...\n")
        })
      }
    }
  }, error = function(e) {
    cat("Não foi possível descobrir Python automaticamente.\n")
  })
  
  # Se já encontrou e configurou, pular as outras tentativas
  if (python_configured && py_available()) {
    config <- py_config()
    cat(sprintf("✓ Python encontrado: %s\n", config$python))
    cat(sprintf("Versão: %s\n\n", config$version))
  }
  
  # Tentar usar o launcher py do Windows (só se ainda não encontrou e configurou)
  if (!python_configured && !py_available()) {
    cat("Tentando usar o launcher 'py' do Windows...\n")
    python_found <- FALSE
    
    # Tentar versão específica primeiro (evita usar venv se estiver ativo)
    tryCatch({
      python_path <- system2("py", args = c("-3.14", "-c", "import sys; print(sys.executable)"), stdout = TRUE, stderr = TRUE)
      if (length(python_path) > 0 && file.exists(python_path[1])) {
        python_exe <- trimws(python_path[1])
        # Verificar se não é do venv
        if (!grepl("venv", python_exe, ignore.case = TRUE)) {
          cat(sprintf("Python encontrado via 'py -3.14': %s\n", python_exe))
          use_python(python_exe, required = TRUE)
          if (py_available()) {
            python_found <- TRUE
          }
        }
      }
    }, error = function(e) {
      # Continuar tentando outros métodos
    })
    
    # Se não encontrou, tentar py sem versão específica
    if (!python_found) {
      tryCatch({
        python_path <- system2("py", args = c("-c", "import sys; print(sys.executable)"), stdout = TRUE, stderr = TRUE)
        if (length(python_path) > 0 && file.exists(python_path[1])) {
          python_exe <- trimws(python_path[1])
          cat(sprintf("Python encontrado via 'py' launcher: %s\n", python_exe))
          use_python(python_exe, required = TRUE)
          if (py_available()) {
            python_found <- TRUE
          }
        }
      }, error = function(e) {
        cat("Launcher 'py' não retornou caminho válido.\n")
      })
    }
  }
  
  # Tentar caminhos comuns no Windows (só se ainda não encontrou e configurou)
  if (!python_configured && !py_available()) {
    cat("Tentando caminhos comuns do Windows...\n")
    user_name <- Sys.getenv("USERNAME")
    common_paths <- c(
      file.path(Sys.getenv("LOCALAPPDATA"), "Python", "pythoncore-3.14-64", "python.exe"),
      file.path(Sys.getenv("LOCALAPPDATA"), "Programs", "Python", "Python314", "python.exe"),
      file.path(Sys.getenv("LOCALAPPDATA"), "Programs", "Python", "Python3.14", "python.exe"),
      sprintf("C:\\Users\\%s\\AppData\\Local\\Python\\pythoncore-3.14-64\\python.exe", user_name),
      sprintf("C:\\Users\\%s\\AppData\\Local\\Programs\\Python\\Python314\\python.exe", user_name),
      sprintf("C:\\Users\\%s\\AppData\\Local\\Programs\\Python\\Python3.14\\python.exe", user_name),
      "C:\\Python314\\python.exe",
      "C:\\Python3.14\\python.exe"
    )
    
    python_found <- FALSE
    for (path in common_paths) {
      # Verificar se arquivo existe e é acessível antes de tentar usar
      if (file.exists(path) && file.access(path, mode = 0) == 0) {
        cat(sprintf("Tentando Python em: %s\n", path))
        tryCatch({
          use_python(path, required = TRUE)
          if (py_available()) {
            python_found <- TRUE
            cat(sprintf("✓ Python configurado: %s\n", path))
            break
          }
        }, error = function(e) {
          # Continuar tentando outros caminhos
          cat(sprintf("  Não foi possível usar este Python\n"))
        })
      }
    }
    
    if (!python_found && !py_available()) {
      cat("\n⚠️  Python não foi encontrado automaticamente.\n")
      cat("Por favor, especifique o caminho do Python manualmente:\n")
      cat("Exemplo:\n")
      cat("  library(reticulate)\n")
      cat("  use_python('C:\\\\caminho\\\\para\\\\python.exe', required = TRUE)\n")
      cat("\nOu execute no terminal para encontrar o Python:\n")
      cat("  where python\n")
      cat("  py --version\n")
      stop("Python não encontrado. Por favor, configure manualmente ou instale Python.")
    }
  }
  
  # Verificar novamente após todas as tentativas
  if (py_available()) {
    config <- py_config()
    cat(sprintf("✓ Python encontrado: %s\n", config$python))
    cat(sprintf("Versão: %s\n\n", config$version))
  } else {
    stop("Não foi possível configurar Python. Por favor, verifique a instalação.")
  }
}

# 3. Configurar venv
cat("[3/4] Configurando ambiente virtual...\n")
venv_path <- "venv"

if (!dir.exists(venv_path)) {
  cat(sprintf("Criando venv em: %s\n", normalizePath(venv_path, mustWork = FALSE)))
  virtualenv_create(envname = venv_path)
  cat("✓ Venv criado!\n\n")
} else {
  cat(sprintf("Usando venv existente em: %s\n", normalizePath(venv_path, mustWork = FALSE)))
}

# Ativar venv
use_virtualenv(venv_path, required = TRUE)
cat("✓ Venv configurado para uso!\n\n")

# 4. Instalar pacotes Python básicos
cat("[4/4] Verificando pacotes Python...\n")
packages_to_check <- c("numpy", "pandas", "matplotlib")

for (pkg in packages_to_check) {
  tryCatch({
    py_run_string(sprintf("import %s", pkg))
    cat(sprintf("  ✓ %s disponível\n", pkg))
  }, error = function(e) {
    cat(sprintf("  ✗ %s não encontrado - instalando...\n", pkg))
    py_install(pkg, envname = venv_path, pip = TRUE)
    cat(sprintf("  ✓ %s instalado\n", pkg))
  })
}

cat("\n========================================\n")
cat("Configuração concluída com sucesso!\n")
cat("========================================\n\n")
cat("Próximos passos:\n")
cat("1. Adicione o chunk de setup no index.Rmd:\n")
cat("   ```{r setup, include=FALSE}\n")
cat("   library(reticulate)\n")
cat("   use_virtualenv('venv', required = TRUE)\n")
cat("   ```\n\n")
cat("2. Renderize o livro:\n")
cat("   bookdown::render_book('index.Rmd')\n\n")
