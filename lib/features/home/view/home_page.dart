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
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
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

