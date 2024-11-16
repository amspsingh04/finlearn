// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailPage extends StatelessWidget {
  final String courseTitle;

  CourseDetailPage({Key? key, required this.courseTitle}) : super(key: key);

  // Dummy video data
  final videos = [
    {
      'title': 'Introduction to Finance',
      'thumbnailUrl': 'https://img.youtube.com/vi/dummy1/0.jpg',
      'videoUrl': 'https://www.youtube.com/watch?v=dummy1',
    },
    {
      'title': 'Understanding Budgeting Basics',
      'thumbnailUrl': 'https://img.youtube.com/vi/dummy2/0.jpg',
      'videoUrl': 'https://www.youtube.com/watch?v=dummy2',
    },
    {
      'title': 'Saving Strategies for Beginners',
      'thumbnailUrl': 'https://img.youtube.com/vi/dummy3/0.jpg',
      'videoUrl': 'https://www.youtube.com/watch?v=dummy3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(courseTitle)),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Card(
            child: ListTile(
              leading: Image.network(video['thumbnailUrl'] as String),
              title: Text(video['title'] as String),
              onTap: () async {
                final url = video['videoUrl'] as String;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not open video: $url')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
