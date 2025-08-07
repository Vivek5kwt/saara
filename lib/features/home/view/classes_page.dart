import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:saara/widgets/custom_app_bar.dart';
import '../cubit/home_cubit.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final classes = context.watch<HomeCubit>().state.classes;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Classes'),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final item = classes[index];
          final videoCount = int.tryParse(RegExp(r'\d+').firstMatch(item.subtitle)?.group(0) ?? '') ?? 0;
          return ListTile(
            leading: Image.asset(item.image, width: 60, fit: BoxFit.cover),
            title: Text(item.title),
            subtitle: Text(item.subtitle),
            onTap: () => context.push('/class-detail', extra: {
              'title': item.title,
              'image': item.image,
              'videoCount': videoCount,
              'description': '',
            }),
          );
        },
      ),
    );
  }
}
