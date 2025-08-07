import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saara/widgets/custom_app_bar.dart';
import '../cubit/notification_cubit.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationCubit(),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Notifications'),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFA78BFA), Color(0xFF6C63FF)],
            ),
          ),
          child: BlocBuilder<NotificationCubit, List<String>>(
            builder: (context, notifications) {
              if (notifications.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notifications_off,
                          size: 64, color: Colors.white70),
                      SizedBox(height: 16),
                      Text('No notifications',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.notifications),
                      title: Text(notifications[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
