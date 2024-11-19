import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  // Base URL of the Flask server exposed via Ngrok
  final String baseUrl = "https://6d1e-2401-4900-234e-5324-d956-4a34-e251-54c1.ngrok-free.app/";

  // Send a message to the Llama3 model
  Future<String> sendMessage(String message) async {
    final url = Uri.parse('$baseUrl/chat'); // Endpoint for the chat API

    // Prepare request body with your message
    final body = jsonEncode({
      "message": message, // Message to send
    });

    // Set up headers
    final headers = {
      "Content-Type": "application/json",
    };

    try {
      // Send POST request
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Parse the response
        final data = jsonDecode(response.body);
        return data['response'] ?? "No response from server."; // Safely access response
      } else {
        throw Exception('Failed to get response. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors
      return "Error occurred: $e";
    }
  }
}


