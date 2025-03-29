# Configurações automáticas
$PROJECT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$VENV_PATH = Join-Path $PROJECT_DIR "venv\Scripts"
$APP_MODULE = "app:app"

Write-Host "Diretório do projeto: $PROJECT_DIR"
Write-Host "Diretório do ambiente virtual: $VENV_PATH"

# Verifica se requirements.txt existe
$REQUIREMENTS_PATH = Join-Path $PROJECT_DIR "requirements.txt"
if (-not (Test-Path $REQUIREMENTS_PATH)) {
    Write-Host "ERRO: arquivo requirements.txt não encontrado em: $REQUIREMENTS_PATH"
    exit 1
}

# Verifica e ativa o venv
if (-not (Test-Path (Join-Path $VENV_PATH "activate.ps1"))) {
    Write-Host "Criando ambiente virtual..."
    python -m venv $VENV_PATH
    & "$VENV_PATH\activate.ps1"
    Write-Host "Instalando dependências..."
    pip install -r $REQUIREMENTS_PATH
} else {
    Write-Host "Ativando ambiente virtual existente..."
    & "$VENV_PATH\activate.ps1"
    Write-Host "Atualizando dependências..."
    pip install -r $REQUIREMENTS_PATH
}

# Muda para o diretório do backend
Write-Host "Mudando para o diretório: $PROJECT_DIR"
Set-Location $PROJECT_DIR

# Verifica se o arquivo app.py existe
$APP_PATH = Join-Path $PROJECT_DIR "app.py"
if (-not (Test-Path $APP_PATH)) {
    Write-Host "ERRO: arquivo app.py não encontrado em: $APP_PATH"
    exit 1
}

Write-Host "Iniciando o servidor..."
# Inicia o Waitress
waitress-serve --host=0.0.0.0 --port=8000 app:app 