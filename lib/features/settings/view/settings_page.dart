import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/cubit/theme_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFFA78BFA);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          value: _notificationsEnabled,
          activeColor: primaryPurple,
          title: const Text('Enable notifications'),
          onChanged: (value) {
            setState(() => _notificationsEnabled = value);
          },
        ),
        SwitchListTile(
          value: context.watch<ThemeCubit>().state == ThemeMode.dark,
          activeColor: primaryPurple,
          title: const Text('Dark mode'),
          onChanged: (value) {
            context.read<ThemeCubit>().toggle(value);
          },
        ),
      ],
    );
  }
}

