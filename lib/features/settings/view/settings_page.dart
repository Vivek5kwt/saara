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
        _SettingsTile(
          icon: Icons.notifications_active_outlined,
          title: 'Enable notifications',
          subtitle: 'Stay up to date with new classes and events',
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() => _notificationsEnabled = value);
          },
        ),
        _SettingsTile(
          icon: context.watch<ThemeCubit>().state == ThemeMode.dark
              ? Icons.dark_mode_outlined
              : Icons.light_mode_outlined,
          title: 'Dark mode',
          subtitle: 'Reduce eye strain with a darker theme',
          value: context.watch<ThemeCubit>().state == ThemeMode.dark,
          onChanged: (value) {
            context.read<ThemeCubit>().toggle(value);
          },
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFFA78BFA);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SwitchListTile.adaptive(
        secondary: Icon(icon, color: primaryPurple),
        value: value,
        activeColor: primaryPurple,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        onChanged: onChanged,
      ),
    );
  }
}

