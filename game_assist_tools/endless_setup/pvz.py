from flask import Flask, request, jsonify, send_from_directory
import os, json

app = Flask(__name__, static_folder='static')
CONFIG_FILE = 'config.json'

@app.route('/')
def index():
    return send_from_directory('static', 'index.html')

@app.route('/save_config', methods=['POST'])
def save_config():
    try:
        data = request.get_json()
        with open(CONFIG_FILE, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        return jsonify({'status': 'success', 'msg': '已保存'})
    except Exception as e:
        return jsonify({'status': 'error', 'msg': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)