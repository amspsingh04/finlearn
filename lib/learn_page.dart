import 'package:flutter/material.dart';
import 'courses.dart';

class LearnPage extends StatelessWidget {
  final String email;

  const LearnPage({Key? key, required this.email}) : super(key: key);

  String getUsernameFromEmail(String email) {
    return email.split('@')[0]; // Extract username from email
  }

  @override
  Widget build(BuildContext context) {
    final username = getUsernameFromEmail(email);

    // Dummy course data
    final courses = [
      {'title': 'Course 1: Introduction', 'progress': 40.0},
      {'title': 'Course 2: Budgeting', 'progress': 70.0},
      {'title': 'Course 3: Savings', 'progress': 30.0},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi $username!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Courses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Card(
                    child: ListTile(
                      title: Text(course['title'] as String),
                      subtitle: Text('Progress: ${course['progress']}%'),
                      trailing: SizedBox(
                        width: 50,
                        height: 250,
                        child: CircularProgressIndicator(
                          value: (course['progress'] as double) / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      ),
                      onTap: () {
                        // Navigate to Course Detail Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetailPage(
                              courseTitle: course['title'] as String,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
