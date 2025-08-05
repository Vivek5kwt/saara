import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    final isMember = user?.isMember ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yoga Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                context.go('/');
              },
            ),
            ListTile(
              title: const Text('Videos'),
              onTap: () {
                context.go('/video');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          if (isMember)
            ListTile(
              title: const Text('Morning Yoga Video'),
              onTap: () => context.go('/video'),
            )
          else
            const ListTile(
              title: Text('No membership'),
              subtitle: Text('Upgrade to view videos'),
            ),
        ],
      ),
    );
  }
}

