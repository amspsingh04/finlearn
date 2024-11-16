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
      'thumbnailUrl': 'lib/vid1.jpg',
      'videoUrl': ' https://www.youtube.com/watch?v=jwx92POes_Q',
    },
    {
      'title': 'Understanding Budgeting Basics',
      'thumbnailUrl': 'lib/vid2.jpg',
      'videoUrl': 'https://youtu.be/sVKQn2I4HDM?si=WJDzQhWCtL424zVk',
    },
    {
      'title': 'Saving Strategies for Beginners',
      'thumbnailUrl': 'lib/vid3.jpg',
      'videoUrl': 'https://youtu.be/HQzoZfc3GwQ?si=ECodnpPI2cukJsVe',
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
