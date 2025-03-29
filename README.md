# Sistema de Pesquisa de Operadoras de Saúde

Sistema de pesquisa de operadoras de saúde com interface web moderna e API RESTful.

## Estrutura do Projeto

```
.
├── backend/
│   ├── app.py                 # API Flask
│   ├── requirements.txt       # Dependências Python
│   ├── Relatorio_cadop.csv   # Dados das operadoras
│   └── gunicorn_start.ps1    # Script de inicialização (Windows)
├── frontend/
│   ├── src/                  # Código fonte Vue.js
│   └── dist/                 # Arquivos compilados
├── start.sh                  # Script de inicialização (Linux/Mac)
├── start.ps1                 # Script de inicialização (Windows)
└── README.md
```

## Requisitos

- Python 3.8 ou superior
- Node.js 14 ou superior
- NPM ou Yarn

## Como Executar o Código

### 1. Configuração Inicial

1. Clone o repositório (se ainda não tiver feito)
2. Navegue até a pasta do projeto:
```bash
cd nome-do-repositorio
```

### 2. Iniciando o Sistema

#### Windows (PowerShell)
```bash
.\start.ps1
```

#### Linux/Mac
```bash
chmod +x start.sh
./start.sh
```

O script irá:
1. Verificar se o Python está instalado
2. Criar um ambiente virtual (se não existir)
3. Instalar as dependências necessárias
4. Iniciar o servidor
5. Mostrar o link para acessar o sistema

O servidor estará disponível em `http://localhost:8000`

### 3. Como Usar o Sistema

1. Abra seu navegador e acesse:
```
http://localhost:8000
```

2. Você verá duas opções de pesquisa:

   a) **Pesquisa Simples**:
   - Digite o termo que deseja pesquisar no campo de busca principal
   - Exemplo: Digite "SAUDE" e clique em "Pesquisar"
   - A pesquisa será feita em todos os campos do banco de dados

   b) **Pesquisa Avançada**:
   - Selecione um campo específico no menu dropdown
   - Digite o termo de busca
   - Exemplo: 
     - Selecione "Cidade" no dropdown
     - Digite "São Paulo"
     - Clique em "Pesquisar"

3. Os resultados serão exibidos em uma tabela abaixo da barra de pesquisa

4. Clique em qualquer resultado para ver mais detalhes da operadora

### 4. Solução de Problemas Comuns

Se encontrar algum problema:

1. **Servidor não inicia**:
   - Verifique se o Python está instalado corretamente
   - Confirme se todas as dependências foram instaladas
   - Verifique se o arquivo CSV está presente no diretório backend

2. **Pesquisas não retornam resultados**:
   - Verifique se o termo de busca está correto
   - Tente usar a pesquisa avançada com um campo específico
   - Abra o console do navegador (F12) para ver mensagens de erro

3. **Erro de conexão**:
   - Confirme se o servidor está rodando (deve aparecer "Running on http://localhost:8000")
   - Verifique se não há outro serviço usando a porta 8000

### 5. Parando o Servidor

Para parar o servidor:
- Pressione `Ctrl+C` no terminal onde o servidor está rodando
- Para sair do ambiente virtual, digite `deactivate`

## Funcionalidades

### Pesquisa Simples
- Pesquisa em todos os campos do banco de dados
- Exemplo de uso: `http://localhost:8000/api/pesquisa?consulta=SAUDE`

### Pesquisa Avançada
- Pesquisa em campos específicos
- Exemplo de uso: `http://localhost:8000/api/pesquisa/avancada?campo=Razao_Social&consulta=SAUDE`

### Campos Disponíveis para Pesquisa
- Registro_ANS
- CNPJ
- Razao_Social
- Nome_Fantasia
- Modalidade
- Logradouro
- Numero
- Complemento
- Bairro
- Cidade
- UF
- CEP
- DDD
- Telefone
- Fax
- Endereco_eletronico
- Representante
- Cargo_Representante
- Regiao_de_Comercializacao
- Data_Registro_ANS

## Exemplos de Pesquisa

1. Pesquisa por nome de operadora:
```
SAUDE
```

2. Pesquisa avançada por cidade:
```
São Paulo
```

3. Pesquisa por modalidade:
```
=Odontologia
```

## Notas Técnicas

- O backend utiliza Flask com Waitress (Windows) ou Gunicorn (Linux/Mac) como servidor WSGI
- O frontend é construído com Vue.js e Vuetify
- Os dados são carregados de um arquivo CSV com codificação UTF-8
- O sistema suporta diferentes codificações de arquivo (UTF-8, Latin1, ISO-8859-1)

```json
{
  "contagem": 10,
  "resultados": [
    {
      "Registro_ANS": "123456",
      "CNPJ": "12345678901234",
      "Razao_Social": "Empresa Exemplo"
    }
  ]
}
``` 