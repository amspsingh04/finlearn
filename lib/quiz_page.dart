import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Map<String, dynamic> _userResponses = {};
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Questions list for Page 1
  final List<Map<String, dynamic>> _page1Questions = [
    {
      'type': 'text',
      'question': 'What is your age?',
      'key': 'age',
    },
    {
      'type': 'single',
      'question': 'What is your highest level of education?',
      'key': 'education',
      'options': ['High School', 'Undergraduate', 'Postgraduate', 'Other'],
    },
    {
      'type': 'single',
      'question': 'What is your current profession?',
      'key': 'profession',
      'options': ['Student', 'Employee', 'Business Owner', 'Unemployed', 'Other'],
    },
  ];

  // Questions list for Page 2
  final List<Map<String, dynamic>> _page2Questions = [
    {
      'type': 'single',
      'question': 'How would you rate your understanding of financial literacy?',
      'key': 'financial_literacy',
      'options': ['Poor', 'Basic', 'Intermediate', 'Advanced'],
    },
    {
      'type': 'single',
      'question': 'Which of these terms do you understand?',
      'key': 'financial_terms',
      'options': ['Savings', 'Investments', 'Loans', 'Credit Score', 'None of these'],
    },
    {
      'type': 'single',
      'question': 'Which of these financial tools have you used?',
      'key': 'financial_tools',
      'options': ['Bank Account', 'Loan', 'Insurance', 'None of these'],
    },
    {
      'type': 'single',
      'question': 'Which of these savings methods are you familiar with?',
      'key': 'savings_methods',
      'options': ['Emergency Fund', 'Retirement Savings', 'High-Yield Savings Accounts', 'Investments', 'None of these'],
    },
  ];

  Future<void> _saveResponsesToFirebase() async {
    try {
      // Get the current user ID from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      String userId = user?.uid ?? 'anonymous'; // If the user is not logged in, use 'anonymous'

      // Save responses to Firestore
      CollectionReference responses = FirebaseFirestore.instance.collection('quiz_responses');
      await responses.add({
        'user_id': userId,  // Include the user ID in the response document
        'user_responses': _userResponses,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thank You!'),
          content: const Text('Your responses have been saved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                // Navigate to the Home page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(), // Navigate to home page
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error saving to Firebase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details & Financial Literacy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildPage(_page1Questions),
                  _buildPage(_page2Questions),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _currentPage == 1
                ? ElevatedButton(
                    onPressed: _saveResponsesToFirebase,
                    child: const Text('Submit'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: const Text('Next'),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(List<Map<String, dynamic>> questions) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var question in questions) _buildQuestion(question),
        ],
      ),
    );
  }

  Widget _buildQuestion(Map<String, dynamic> question) {
    final String type = question['type'] as String;

    switch (type) {
      case 'text':
        return _buildTextQuestion(question);
      case 'single':
        return _buildSingleChoiceQuestion(question);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextQuestion(Map<String, dynamic> question) {
    final TextEditingController _controller = TextEditingController(
      text: _userResponses[question['key']] as String? ?? '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          question['question'] as String,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Enter your answer',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            _userResponses[question['key']] = value;
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSingleChoiceQuestion(Map<String, dynamic> question) {
    final String? selectedOption = _userResponses[question['key']] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          question['question'] as String,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        ...List<Widget>.generate(
          (question['options'] as List<String>).length,
          (index) {
            final option = question['options'][index];
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  _userResponses[question['key']] = value;
                });
              },
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
