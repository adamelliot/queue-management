import os
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/health', methods=['GET'])
def get_health():
    url = ""
    with open('/var/smartboard-url') as file:
        url = file.read().strip()

    response = jsonify({
        'connected': not os.path.exists("/var/network-down"),
        'url': url
    })

    response.headers.add('Access-Control-Allow-Origin', '*')
    return response
