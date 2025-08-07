import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:saara/widgets/custom_app_bar.dart';
import '../cubit/home_cubit.dart';
import 'classes_page.dart';
import 'package:saara/widgets/class_card.dart';
import 'programs_page.dart';
import '../../settings/view/settings_page.dart';
import '../../search/view/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  static const primaryPurple = Color(0xFFA78BFA);

  Widget _buildNavItem(int index, IconData icon, String label) {
    final selected = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: selected ? Colors.white.withOpacity(0.3) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: selected ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 250),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassNavBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [primaryPurple, Color(0xFF6C63FF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Container(
              color: Colors.white.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  _buildNavItem(0, Icons.explore, 'Explore'),
                  _buildNavItem(1, Icons.self_improvement, 'Classes'),
                  _buildNavItem(2, Icons.search, 'Search'),
                  _buildNavItem(3, Icons.settings, 'Settings'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _ExploreView(),
      const ClassesPage(),
      const SearchPage(),
      const SettingsPage(),
    ];
    final titles = ['Explore', 'Classes', 'Search', 'Settings'];

    return BlocProvider(
      create: (_) => HomeCubit(),
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: primaryPurple),
                child: Text('Menu', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                leading: const Icon(Icons.explore_outlined),
                title: const Text('Explore'),
                onTap: () {
                  setState(() => _currentIndex = 0);
                  context.pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.self_improvement_outlined),
                title: const Text('Classes'),
                onTap: () {
                  setState(() => _currentIndex = 1);
                  context.pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.search_outlined),
                title: const Text('Search'),
                onTap: () {
                  setState(() => _currentIndex = 2);
                  context.pop();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                onTap: () {
                  setState(() => _currentIndex = 3);
                  context.pop();
                },
              ),
            ],
          ),
        ),
        appBar: _currentIndex == 1
            ? null
            : CustomAppBar(
                title: titles[_currentIndex],
                leading: Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () => context.push('/notifications'),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        child: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
        body: IndexedStack(index: _currentIndex, children: pages),
        bottomNavigationBar: _buildGlassNavBar(),
      ));
  }
}

class _ExploreView extends StatefulWidget {
  const _ExploreView({super.key});

  @override
  State<_ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<_ExploreView> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFFA78BFA);
    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        children: [
          // --- Big “May Challenge” video card ---
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: _controller.value.isInitialized
                      ? FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        )
                      : Container(color: Colors.black12),
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
                const Positioned(
                  top: 16,
                  left: 16,
                  child: Text(
                    'May\nChallenge',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _togglePlay,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 32,
                      color: primaryPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 32),

        // --- “Saara Classes” title + horizontal list ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Saara Classes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => context.push(
                '/classes',
                extra: context.read<HomeCubit>(),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.classes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = state.classes[index];
                  return SizedBox(
                    width: 240,
                    child: ClassCard(
                      image: item.image,
                      title: item.title,
                      subtitle: item.subtitle,
                    ),
                  );
                },
              );
            },
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'More Programs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => context.push(
                '/programs',
                extra: context.read<HomeCubit>(),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.programs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = state.programs[index];
                  return _ProgramCard(
                    image: item.image,
                    title: item.title,
                    subtitle: item.subtitle,
                    onTap: () => context.push('/video'),
                  );
                },
              );
            },
          ),
        ),

        const SizedBox(height: 24),
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
  final VoidCallback? onTap;
  const _ProgramCard({
    required this.image,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
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
      ),
    );
  }
}
