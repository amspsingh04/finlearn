import 'package:flutter/material.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      body: ListView(
        children: [
          _buildChapterCard(context, "Chapter 1: Intro to Finances", [
            {
              'title': 'Understanding Finances',
              'thumbnailUrl': 'https://via.placeholder.com/150', // Example placeholder
              'videoUrl': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
            },
            {
              'title': 'Personal Finance Basics',
              'thumbnailUrl': 'https://via.placeholder.com/150',
              'videoUrl': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
            }
          ]),
          _buildChapterCard(context, "Chapter 2: Budgeting", [
            {
              'title': 'How to Budget Effectively',
              'thumbnailUrl': 'https://via.placeholder.com/150',
              'videoUrl': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
            },
            {
              'title': 'The 50/30/20 Rule',
              'thumbnailUrl': 'https://via.placeholder.com/150',
              'videoUrl': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
            }
          ]),
          _buildChapterCard(context, "Chapter 3: Saving", [
            {
              'title': 'Saving for Emergencies',
              'thumbnailUrl': 'https://via.placeholder.com/150',
              'videoUrl': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
            },
            {
              'title': 'Building Wealth Through Savings',
              'thumbnailUrl': 'https://via.placeholder.com/150',
              'videoUrl': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
            }
          ]),
        ],
      ),
    );
  }

  // Build Chapter Card with a list of videos
  Widget _buildChapterCard(BuildContext context, String chapterTitle, List<Map<String, String>> videos) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(chapterTitle),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to VideoPage with the videos for the chapter
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPage(videos: videos),
            ),
          );
        },
      ),
    );
  }
}

class VideoPage extends StatelessWidget {
  final List<Map<String, String>> videos;

  const VideoPage({Key? key, required this.videos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Videos')),
      body: ListView(
        children: videos.map((video) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(video['thumbnailUrl']!), // Display video thumbnail
              title: Text(video['title']!),
              onTap: () {
                // Navigate to the YouTube video or open the video in a web browser
                _openVideo(video['videoUrl']!, context);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // Open the YouTube video URL
  void _openVideo(String videoUrl, BuildContext context) {
    // Open URL in browser (you can use `url_launcher` for real functionality)
    // Example: url_launcher package: https://pub.dev/packages/url_launcher
    print("Opening video: $videoUrl");
    // Here you would use url_launcher to open the URL in a browser:
    // launch(videoUrl);
  }
}
