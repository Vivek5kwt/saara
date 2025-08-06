import 'package:flutter/material.dart';
import 'package:saara/features/video/view/video_page.dart';

class ClassDetailPage extends StatelessWidget {
  final String title;
  final String image;
  final int videoCount;

  const ClassDetailPage({
    super.key,
    required this.title,
    required this.image,
    required this.videoCount,
  });

  @override
  Widget build(BuildContext context) {
    final videos = List.generate(videoCount, (index) => 'Video ${index + 1}');
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Start Watching'),
          ),
          const SizedBox(height: 16),
          const Text(
            'About this class',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This is a placeholder description for the class.',
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${videos.length} items',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...videos.map(
            (v) => ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: Text(v),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VideoPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

