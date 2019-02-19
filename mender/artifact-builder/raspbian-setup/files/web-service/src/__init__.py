from pathlib import Path
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/health', methods=['GET'])
def get_health():
    url = ""
    with open('/var/smartboard/url') as file:
        url = file.read().strip()

    response = jsonify({
        'connected': not Path("/var/network-down").is_file(),
        'videoCached': Path("/data/videos/video.mp4").is_file(),
        'url': url
    })

    response.headers.add('Access-Control-Allow-Origin', '*')
    return response
