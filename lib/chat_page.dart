// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    if (userId == null) {
      print("Error: User ID is null");
    }
  }

  void _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty || userId == null) return;

    // Add user message to Firestore
    await _firestore.collection('chat_messages').add({
      'role': 'user',
      'content': message,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Clear the input field
    _controller.clear();

    try {
      // Send the message to the chatbot service
      final response = await _chatService.sendMessage(message);

      // Add bot response to Firestore
      await _firestore.collection('chat_messages').add({
        'role': 'bot',
        'content': response,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error while getting response from chatbot: $e");

      // Handle errors gracefully
      const errorResponse = 'Error: Unable to get response';

      // Save error message to Firestore
      await _firestore.collection('chat_messages').add({
        'role': 'bot',
        'content': errorResponse,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot"),
      ),
      body: Column(
        children: <Widget>[
          // StreamBuilder to load chat messages from Firestore
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chat_messages')
                  .where('userId', isEqualTo: userId) // Filter by userId
                  .snapshots(),
              builder: (context, snapshot) {
                // Check for loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Check for any errors
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return {
                    'role': data['role'] ?? '',
                    'content': data['content'] ?? '',
                    'timestamp': data['timestamp'] ?? Timestamp.now(), // Use Timestamp here
                  };
                }).toList();

                // Sort messages by timestamp locally after fetching
                messages.sort((a, b) {
                  final timestampA = a['timestamp'] as Timestamp;
                  final timestampB = b['timestamp'] as Timestamp;
                  return timestampA.compareTo(timestampB);
                });

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUser = message['role'] == 'user';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      child: Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            message['content']!,
                            style: TextStyle(
                              color: isUser ? Colors.black : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
