import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home page with bottom navigation and explore content.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [
      _ExploreView(),
      Center(child: Text('Classes Page')),
      Center(child: Text('Searches Page')),
      Center(child: Text('Settings Page')),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Explore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          )
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Searches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _ExploreView extends StatelessWidget {
  const _ExploreView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GestureDetector(
          onTap: () => context.go('/video'),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(child: Text('Video Thumbnail')),
                ),
              ),
              const Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Saara Classes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _ClassCard(title: 'Beginner Challenge'),
              _ClassCard(title: 'ABS Challenge'),
              _ClassCard(title: 'Daily Challenges'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Card(
          color: Colors.purple.shade100,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: Text('14 day free trial'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Start trial'),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Balanced Body Guide',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const ListTile(
          title: Text('#1 Cycle Syncing Pilates'),
          subtitle: Text('More programs coming soon'),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {},
            child: const Text('More Programs'),
          ),
        ),
      ],
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

