import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A creative search experience with animated results and quick suggestions.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();

  /// Example list of video titles. In a real app this could come from a backend
  /// or a local database.
  final List<String> _allVideos = const [
    'Beginner Challenge Day 1',
    'Beginner Challenge Day 2',
    'ABS Challenge Warmup',
    'Daily Flow Session',
    'Yoga Flow Series Intro',
    'Summer Challenge Finale',
  ];

  /// Demo mapping of titles to video URLs. Normally this would come from
  /// an API or database.
  final Map<String, String> _videoUrls = const {
    'Beginner Challenge Day 1':
        'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'Beginner Challenge Day 2':
        'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'ABS Challenge Warmup':
        'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'Daily Flow Session':
        'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'Yoga Flow Series Intro':
        'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'Summer Challenge Finale':
        'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
  };

  List<String> _filtered = const [];

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text.toLowerCase();
    final results = query.isEmpty
        ? const []
        : _allVideos.where((v) => v.toLowerCase().contains(query)).toList();
    setState(() {
      _filtered = results;
    });
    if (_filtered.isNotEmpty) {
      _fadeController.forward();
    } else {
      _fadeController.reverse();
    }
  }

  void _useSuggestion(String text) {
    _controller.text = text;
    _controller.selection = TextSelection.fromPosition(TextPosition(offset: text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFA78BFA), Color(0xFF6C63FF)],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search videos',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.15),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            if (_controller.text.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: _allVideos.take(4).map((s) {
                    return ActionChip(
                      label: Text(s),
                      labelStyle: const TextStyle(color: Colors.white),
                      backgroundColor: Colors.white.withOpacity(0.15),
                      onPressed: () => _useSuggestion(s),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No results',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) => const Divider(
                          color: Colors.white24,
                          height: 1,
                        ),
                        itemBuilder: (context, index) {
                          final title = _filtered[index];
                          return ListTile(
                            title: Text(title,
                                style: const TextStyle(color: Colors.white)),
                            trailing:
                                const Icon(Icons.play_arrow, color: Colors.white),
                            onTap: () {
                              final url = _videoUrls[title];
                              if (url != null) {
                                context.push(
                                  '/video',
                                  extra: {'title': title, 'url': url},
                                );
                              }
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
