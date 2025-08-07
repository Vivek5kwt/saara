import 'package:flutter/material.dart';

/// A simple search interface that filters a static list of video titles.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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

  List<String> _filtered = const [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text.toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? const []
          : _allVideos
              .where((v) => v.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Center(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Search videos',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('No results'))
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final title = _filtered[index];
                      return ListTile(
                        title: Text(title),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected "$title"')),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

