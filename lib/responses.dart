// responses.dart
import 'package:ollama_dart/ollama_dart.dart';

Future<String> getChatResponse(String userMessage) async {
  final client = OllamaClient();
  
  // Create a request with the user's message as input
  final response = await client.generateChatCompletion(
    request: GenerateChatCompletionRequest(
      model: 'llama3.2',
      messages: [
        Message(role: MessageRole.user, content: userMessage),
      ],
    ),
  );

  client.endSession();
  
  // Return the assistant's message content
  return response.message.content ?? 'Sorry, I did not understand that.';
}
