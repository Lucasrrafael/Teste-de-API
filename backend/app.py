from flask import Flask, request, jsonify, render_template, send_from_directory
import pandas as pd
import os
import logging
import sys

# Configuração de logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    stream=sys.stdout
)
logger = logging.getLogger(__name__)

app = Flask(__name__, 
           static_folder='../frontend/dist/static', 
           template_folder='../frontend/dist')

# Carrega o arquivo CSV com a codificação e delimitador corretos
def carregar_csv():
    try:
        logger.debug("Tentando carregar o arquivo CSV...")
        # Tenta diferentes codificações
        encodings = ['utf-8', 'latin1', 'iso-8859-1']
        df = None
        
        for encoding in encodings:
            try:
                logger.debug(f"Tentando carregar com encoding {encoding}...")
                df = pd.read_csv('Relatorio_cadop.csv', 
                              encoding=encoding, 
                              delimiter=';',
                              quotechar='"')
                logger.debug(f"CSV carregado com sucesso usando encoding {encoding}")
                break
            except UnicodeDecodeError:
                logger.debug(f"Falha ao carregar com encoding {encoding}")
                continue
        
        if df is None:
            raise Exception("Não foi possível carregar o arquivo CSV com nenhuma codificação")
            
        logger.debug(f"Colunas encontradas: {df.columns.tolist()}")
        logger.debug(f"Total de linhas: {len(df)}")
        return df
    except Exception as e:
        logger.error(f"Erro ao carregar CSV: {str(e)}")
        raise

@app.route('/')
def indice():
    # Em produção, servir o app Vue.js
    if os.path.exists(os.path.join(app.static_folder, '../index.html')):
        return send_from_directory(os.path.dirname(app.static_folder), 'index.html')
    # Durante o desenvolvimento, servir o template HTML
    return render_template('index.html')

@app.route('/js/<path:path>')
def serve_js(path):
    return send_from_directory('../frontend/dist/js', path)

@app.route('/css/<path:path>')
def serve_css(path):
    return send_from_directory('../frontend/dist/css', path)

@app.route('/api/pesquisa', methods=['GET'])
def pesquisar():
    try:
        # Obtém a consulta de pesquisa dos parâmetros da requisição
        consulta = request.args.get('consulta', '')
        logger.debug(f"Recebida consulta: {consulta}")
        
        if not consulta:
            return jsonify({'erro': 'O parâmetro de consulta é obrigatório'}), 400
        
        # Carrega os dados do CSV
        df = carregar_csv()
        
        # Converte todas as colunas para o tipo string para pesquisa
        for col in df.columns:
            df[col] = df[col].astype(str)
        
        # Cria uma máscara para linhas que contêm a consulta (sem diferenciar maiúsculas e minúsculas)
        mascara = pd.Series(False, index=df.index)
        
        for col in df.columns:
            mascara = mascara | df[col].str.contains(consulta, case=False, regex=False, na=False)
        
        # Filtra o DataFrame e converte para dict para resposta JSON
        resultado = df[mascara].to_dict(orient='records')
        logger.debug(f"Encontrados {len(resultado)} resultados")
        
        return jsonify({
            'contagem': len(resultado),
            'resultados': resultado
        })
    
    except Exception as e:
        logger.error(f"Erro na pesquisa: {str(e)}")
        return jsonify({'erro': str(e)}), 500

@app.route('/api/pesquisa/avancada', methods=['GET'])
def pesquisa_avancada():
    try:
        # Obtém parâmetros de pesquisa
        campo = request.args.get('campo', '')
        consulta = request.args.get('consulta', '')
        logger.debug(f"Recebida pesquisa avançada - Campo: {campo}, Consulta: {consulta}")
        
        if not consulta or not campo:
            return jsonify({'erro': 'Os parâmetros campo e consulta são obrigatórios'}), 400
        
        # Carrega os dados do CSV
        df = carregar_csv()
        
        # Converte todas as colunas para o tipo string para pesquisa
        for col in df.columns:
            df[col] = df[col].astype(str)
        
        # Verifica se o campo existe no dataframe
        if campo not in df.columns:
            logger.error(f"Campo não encontrado: {campo}")
            return jsonify({'erro': f'Campo {campo} não encontrado nos dados'}), 400
        
        # Filtra pelo campo específico
        mascara = df[campo].str.contains(consulta, case=False, regex=False, na=False)
        resultado = df[mascara].to_dict(orient='records')
        logger.debug(f"Encontrados {len(resultado)} resultados na pesquisa avançada")
        
        return jsonify({
            'contagem': len(resultado),
            'resultados': resultado
        })
    
    except Exception as e:
        logger.error(f"Erro na pesquisa avançada: {str(e)}")
        return jsonify({'erro': str(e)}), 500

@app.route('/api/campos', methods=['GET'])
def obter_campos():
    try:
        # Carrega os dados do CSV e retorna os nomes das colunas
        df = carregar_csv()
        campos = list(df.columns)
        logger.debug(f"Campos disponíveis: {campos}")
        return jsonify({
            'campos': campos
        })
    
    except Exception as e:
        logger.error(f"Erro ao obter campos: {str(e)}")
        return jsonify({'erro': str(e)}), 500

# Rota de teste
@app.route('/teste')
def teste():
    return jsonify({"status": "ok", "mensagem": "Servidor funcionando!"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True) 