import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Helper Widget for the Course Video List
class CourseDetailPage extends StatelessWidget {
  final String courseTitle;

  CourseDetailPage({Key? key, required this.courseTitle}) : super(key: key);

  final List<Map<String, String>> videos = [
    {
      'title': 'Introduction to Finance',
      'thumbnailUrl': 'https://img.youtube.com/vi/jwx92POes_Q/0.jpg',
      'videoUrl': 'https://youtu.be/jwx92POes_Q?si=jwe8eyd__nCNgGh1',
    },
    {
      'title': 'Understanding Budgeting Basics',
      'thumbnailUrl': 'https://img.youtube.com/vi/sVKQn2I4HDM/0.jpg',
      'videoUrl': 'https://youtu.be/sVKQn2I4HDM?si=WJDzQhWCtL424zVk',
    },
    {
      'title': 'Saving Strategies for Beginners',
      'thumbnailUrl': 'https://img.youtube.com/vi/HQzoZfc3GwQ/0.jpg',
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
          return VideoCard(
            title: video['title']!,
            thumbnailUrl: video['thumbnailUrl']!,
            videoUrl: video['videoUrl']!,
          );
        },
      ),
    );
  }
}

// Helper Widget for Individual Video Cards
class VideoCard extends StatelessWidget {
  final String title;
  final String thumbnailUrl;
  final String videoUrl;

  const VideoCard({
    Key? key,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      child: InkWell(
        onTap: () => _launchVideo(context, videoUrl),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              child: Image.network(
                thumbnailUrl,
                width: 120,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 50),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const SizedBox(
                    width: 120,
                    height: 90,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Function to Handle Video Launch
  Future<void> _launchVideo(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the video'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
