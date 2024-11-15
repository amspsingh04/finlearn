import 'package:flutter/material.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      body: const Center(
        child: Text(
          'Learn Content Goes Here',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
