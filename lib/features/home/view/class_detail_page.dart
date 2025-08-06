import 'package:flutter/material.dart';
import 'package:saara/features/video/view/video_page.dart';

/// A detailed page for a class, matching the design shown: large header image
/// with overlay buttons, a bold title, a prominent "Start Watching" button,
/// a truncated description with "More" expandable prompt, and a styled
/// list of video items with thumbnails, durations, and lock indicators.
class ClassDetailPage extends StatelessWidget {
  final String title;
  final String image;
  final String description;
  final int videoCount;

  const ClassDetailPage({
    Key? key,
    required this.title,
    required this.image,
    required this.description,
    required this.videoCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate a list of video items for demonstration
    final videos = List.generate(
      videoCount,
          (index) => VideoItem(
        title: index == 0
            ? '*Start Here* Welcome to Saara & Define'
            : 'Day ${index + 1} $title Pilates',
        thumbnail: image,
        duration: '${(index + 5)}:${(index * 7 % 60).toString().padLeft(2, '0')}',
        locked: index != 0,
      ),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header with image, back button, and menu button
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          // Content below the header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Start Watching button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          'Start Watching',
                          style: TextStyle(fontSize: 16,color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ), backgroundColor: const Color(0xFF9B65DE), // Purple shade
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // About section
                  const Text(
                    'About this class',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('More'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Items header with filter icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${videos.length} Items',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Video list
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final video = videos[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: InkWell(
                    onTap: video.locked
                        ? null
                        : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VideoPage(),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Thumbnail with lock and duration overlays
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                video.thumbnail,
                                width: 120,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (video.locked)
                              const Positioned(
                                bottom: 6,
                                right: 6,
                                child: Icon(
                                  Icons.lock,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            Positioned(
                              bottom: 6,
                              left: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  video.duration,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 12),

                        // Video title
                        Expanded(
                          child: Text(
                            video.title,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),

                        // More options icon
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: videos.length,
            ),
          ),
        ],
      ),
    );
  }
}

/// A simple model for demo video items
class VideoItem {
  final String title;
  final String thumbnail;
  final String duration;
  final bool locked;

  VideoItem({
    required this.title,
    required this.thumbnail,
    required this.duration,
    this.locked = false,
  });
}
