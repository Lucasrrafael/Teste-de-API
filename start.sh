#!/bin/bash

# Cores para saída
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sem Cor

# Função para lidar com o encerramento
cleanup() {
    echo -e "${BLUE}Encerrando serviços...${NC}"
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
    fi
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID 2>/dev/null
    fi
    exit 0
}

# Configurar trap para limpeza ao encerrar o script
trap cleanup SIGINT SIGTERM

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para verificar se uma porta está em uso
port_in_use() {
    lsof -i :$1 >/dev/null 2>&1
}

echo -e "${BLUE}Iniciando o Sistema de Pesquisa de Operadoras de Saúde...${NC}"

# Verifica se o Python está instalado
if ! command -v python3 &> /dev/null; then
    echo "Python não encontrado. Por favor, instale o Python 3.8 ou superior."
    exit 1
fi

# Verifica se o Node.js/npm está instalado
if ! command_exists npm; then
    echo -e "${RED}Erro: Node.js/npm não está instalado${NC}"
    exit 1
fi

# Verificar se as portas estão disponíveis
if port_in_use 8000; then
    echo -e "${RED}Erro: A porta 8000 já está em uso${NC}"
    exit 1
fi

if port_in_use 8080; then
    echo -e "${RED}Erro: A porta 8080 já está em uso${NC}"
    exit 1
fi

# Entra no diretório do backend
cd backend || {
    echo "Erro: Diretório 'backend' não encontrado."
    exit 1
}

# Verifica se o ambiente virtual existe
if [ ! -d "venv" ]; then
    echo "Criando ambiente virtual..."
    python3 -m venv venv
fi

# Ativa o ambiente virtual
source venv/bin/activate

# Instala as dependências se necessário
if [ ! -f "venv/lib/python3.8/site-packages/flask" ]; then
    echo "Instalando dependências..."
    pip install -r requirements.txt
fi

# Limpa a tela
clear

# Mostra o banner
echo -e "${GREEN}==============================================${NC}"
echo -e "${GREEN}     Sistema de Pesquisa de Operadoras        ${NC}"
echo -e "${GREEN}==============================================${NC}"
echo -e "${BLUE}Servidor iniciado!${NC}"
echo -e "${BLUE}Acesse: http://localhost:8000${NC}"
echo -e "${BLUE}Para parar o servidor, pressione Ctrl+C${NC}"
echo -e "${GREEN}==============================================${NC}"

# Inicia o servidor
python app.py &
BACKEND_PID=$!

# Aguardar inicialização do backend
echo -e "${BLUE}Aguardando inicialização do backend...${NC}"
sleep 5

# Verificar se o backend está rodando
if ! port_in_use 8000; then
    echo -e "${RED}Erro: Falha ao iniciar o backend${NC}"
    cleanup
    exit 1
fi

# Iniciar frontend
echo -e "${BLUE}Iniciando serviço frontend...${NC}"
cd ../frontend

# Instalação limpa das dependências npm
echo -e "${BLUE}Instalando dependências Node.js...${NC}"
rm -rf node_modules package-lock.json
npm install

# Verificar configurações do Babel e ESLint
if [ ! -f "babel.config.js" ]; then
    echo -e "${RED}Erro: babel.config.js está faltando${NC}"
    cleanup
    exit 1
fi

if [ ! -f ".eslintrc.js" ]; then
    echo -e "${RED}Erro: .eslintrc.js está faltando${NC}"
    cleanup
    exit 1
fi

# Construir frontend para produção
echo -e "${BLUE}Construindo frontend para produção...${NC}"
npm run build

# Verificar se a construção foi bem-sucedida
if [ ! -d "dist" ]; then
    echo -e "${RED}Erro: Falha na construção do frontend${NC}"
    cleanup
    exit 1
fi

# Iniciar frontend em modo produção
echo -e "${BLUE}Iniciando servidor frontend...${NC}"
npm run serve &
FRONTEND_PID=$!

# Aguardar inicialização do frontend
echo -e "${BLUE}Aguardando inicialização do frontend...${NC}"
sleep 5

# Verificar se o frontend está rodando
if ! port_in_use 8080; then
    echo -e "${RED}Erro: Falha ao iniciar o frontend${NC}"
    cleanup
    exit 1
fi

echo -e "${GREEN}Aplicação iniciada com sucesso!${NC}"
echo -e "${GREEN}Backend rodando em http://localhost:8000${NC}"
echo -e "${GREEN}Frontend rodando em http://localhost:8080${NC}"
echo -e "${BLUE}Pressione Ctrl+C para encerrar todos os serviços${NC}"

# Manter script rodando
while true; do
    sleep 1
done 