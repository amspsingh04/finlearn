import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = "http://127.0.0.1:11434"; // Ollama server address

  // Send a message to the Llama3 model
  Future<String> sendMessage(String message) async {
    final url = Uri.parse('$baseUrl/chat'); // Assuming '/chat' is the endpoint
    
    // Prepare request body with your message
    final body = jsonEncode({
      "input": message,  // Message to send
      "model": "llama3.2", // Specify the Llama3 model
    });

    // Set up headers
    final headers = {
      "Content-Type": "application/json",
    };

    // Send POST request
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Parse the response
      final data = jsonDecode(response.body);
      return data['response']; // Assuming the response is in this format
    } else {
      throw Exception('Failed to get response');
    }
  }
}
