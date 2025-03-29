# Cores para output
$Green = [System.ConsoleColor]::Green
$Blue = [System.ConsoleColor]::Blue

Write-Host "Iniciando o Sistema de Pesquisa de Operadoras de Saúde..." -ForegroundColor $Blue

# Verifica se o Python está instalado
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Python não encontrado. Por favor, instale o Python 3.8 ou superior." -ForegroundColor Red
    exit 1
}

# Entra no diretório do backend
Set-Location backend -ErrorAction Stop

# Verifica se o ambiente virtual existe
if (-not (Test-Path "venv")) {
    Write-Host "Criando ambiente virtual..."
    python -m venv venv
}

# Ativa o ambiente virtual
.\venv\Scripts\activate

# Instala as dependências se necessário
if (-not (Test-Path "venv\Lib\site-packages\flask")) {
    Write-Host "Instalando dependências..."
    pip install -r requirements.txt
}

# Limpa a tela
Clear-Host

# Mostra o banner
Write-Host "==============================================" -ForegroundColor $Green
Write-Host "     Sistema de Pesquisa de Operadoras        " -ForegroundColor $Green
Write-Host "==============================================" -ForegroundColor $Green
Write-Host "Servidor iniciado!" -ForegroundColor $Blue
Write-Host "Acesse: http://localhost:8000" -ForegroundColor $Blue
Write-Host "Para parar o servidor, pressione Ctrl+C" -ForegroundColor $Blue
Write-Host "==============================================" -ForegroundColor $Green

# Inicia o servidor
python app.py 