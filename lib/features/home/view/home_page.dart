import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  static const primaryPurple = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    final pages = [
      _ExploreView(onVideoTap: () => context.go('/video')),
      const Center(child: Text('Classes Page')),
      const Center(child: Text('Search Page')),
      const Center(child: Text('Settings Page')),
    ];
    final titles = ['Explore', 'Classes', 'Search', 'Settings'];

    return Scaffold(
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: const [
          DrawerHeader(
            decoration: BoxDecoration(color: primaryPurple),
            child: Text('Menu', style: TextStyle(color: Colors.white)),
          ),
          ListTile(leading: Icon(Icons.person), title: Text('Profile')),
        ]),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(titles[_currentIndex],
            style: const TextStyle(color: Colors.black)),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: primaryPurple.withOpacity(0.1),
              child: const Icon(Icons.notifications_none,
                  color: primaryPurple),
            ),
          )
        ],
      ),

      body: IndexedStack(index: _currentIndex, children: pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primaryPurple,
        unselectedItemColor: Colors.grey.shade400,
        showUnselectedLabels: true,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement_outlined),
              label: 'Classes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}

class _ExploreView extends StatelessWidget {
  final VoidCallback onVideoTap;
  const _ExploreView({required this.onVideoTap});

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFFA78BFA);
    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        children: [
        // --- Big “May Challenge” card ---
        GestureDetector(
          onTap: onVideoTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/may_challenge.png',
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: const Text(
                    'May\nChallenge',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow,
                        size: 32, color: primaryPurple),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        // --- “Saara Classes” title + horizontal list ---
        const Text(
          'Saara Classes',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _ClassCard(
                image: 'assets/images/class1.png',
                title: 'Beginner Challenge',
                subtitle: '15 Videos',
              ),
              SizedBox(width: 12),
              _ClassCard(
                image: 'assets/images/class2.png',
                title: 'ABS Challenge',
                subtitle: '12 Videos',
              ),
              SizedBox(width: 12),
              _ClassCard(
                image: 'assets/images/class2.png',
                title: 'Daily Flow',
                subtitle: '20 Videos',
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // --- 14 day Free Trial banner ---
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '14 day Free Trial',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Try First & Decide Later,\nno Credit card Required',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Start Trial',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),

        const SizedBox(height: 32),

        // --- Two feature cards side-by-side ---
        Row(
          children: const [
            Expanded(
              child: _FeatureCard(
                image: 'assets/images/class1.png',
                title: 'Balanced body guide.',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _FeatureCard(
                image: 'assets/images/class2.png',
                title: '#1 Cycle Syncing Pilates.',
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // --- “More Programs” + horizontal list ---
        const Text(
          'More Programs',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _ProgramCard(
                image: 'assets/images/summer.png',
                title: 'Summer Challenge',
                subtitle: '15 Videos',
              ),
              SizedBox(width: 12),
              _ProgramCard(
                image: 'assets/images/abs_waist.png',
                title: 'ABS & Waist Program',
                subtitle: '36 Videos',
              ),
              SizedBox(width: 12),
              _ProgramCard(
                image: 'assets/images/abs_waist.png',
                title: 'Yoga Flow Series',
                subtitle: '24 Videos',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
      ],
    ),
  );
  }
}

class _ClassCard extends StatelessWidget {
  final String image, title, subtitle;
  const _ClassCard({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Image.asset(image, height: 160, width: 240, fit: BoxFit.cover),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFFA78BFA).withOpacity(0.9),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String image, title;
  const _FeatureCard({required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(image, height: 120, fit: BoxFit.cover, width: double.infinity),
          Container(
            color: Colors.black26,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final String image, title, subtitle;
  const _ProgramCard({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
