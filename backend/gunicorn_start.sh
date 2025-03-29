#!/bin/bash

# Configurações automáticas
PROJECT_DIR=$(dirname "$(realpath "$0")")
VENV_PATH="$PROJECT_DIR/venv/Scripts"
APP_MODULE="app:app"  # Substitua pelo seu módulo

# Verifica e ativa o venv
if [ ! -f "$VENV_PATH/Scripts/activate" ]; then
    echo "Criando ambiente virtual..."
    python -m venv "$VENV_PATH"
    source "$VENV_PATH/Scripts/activate"
    pip install -r requirements.txt
else
    source "$VENV_PATH/Scripts/activate"
fi

exec gunicorn -w 4 -b 0.0.0.0:8000 app:app