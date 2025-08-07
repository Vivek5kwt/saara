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
        body: BlocBuilder<NotificationCubit, List<String>>(
          builder: (context, notifications) {
            if (notifications.isEmpty) {
              return const Center(child: Text('No notifications'));
            }
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(notifications[index]));
              },
            );
          },
        ),
      ),
    );
  }
}
