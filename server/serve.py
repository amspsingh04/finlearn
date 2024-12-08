import requests
from flask import Flask, json, request, jsonify

app = Flask(__name__)

@app.route('/chat', methods=['POST'])
def chat():
    data = request.json
    user_message = data.get("message", "")
    
    # Prepare Ollama server request
    ollama_url = "http://127.0.0.1:11434/api/chat"
    ollama_payload = {
        "model": "llama3",
        "messages": [{"role": "user", "content": user_message}]
    }
    headers = {"Content-Type": "application/json"}

    # Send request to Ollama and accumulate the response
    response = requests.post(ollama_url, json=ollama_payload, headers=headers, stream=True)
    full_response = ""

    for line in response.iter_lines():
        if line:
            chunk = line.decode("utf-8")
            chunk_data = json.loads(chunk)
            if "message" in chunk_data and "content" in chunk_data["message"]:
                full_response += chunk_data["message"]["content"]

            # Check if it's done
            if chunk_data.get("done"):
                break

    return jsonify({"response": full_response})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
