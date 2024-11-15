import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user;
  bool _isLoading = true;
  List<Map<String, dynamic>> _responses = [];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _fetchResponses();
  }

  Future<void> _fetchResponses() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('quiz_responses')
          .where('user_id', isEqualTo: _user.uid)
          .get();

      setState(() {
        _responses = snapshot.docs
            .map((doc) => Map<String, dynamic>.from(doc.data()))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch responses: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Email: ${_user.email}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Quiz Responses:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ..._responses.isEmpty
                    ? [const Text('No responses found')]
                    : _responses.map((response) {
                        return ListTile(
                          title: Text('Question: ${response['user_responses'].keys.first}'),
                          subtitle: Text('Answer: ${response['user_responses'].values.first}'),
                        );
                      }).toList(),
              ],
            ),
    );
  }
}
