import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:saara/widgets/custom_app_bar.dart';
import '../cubit/home_cubit.dart';

class ProgramsPage extends StatelessWidget {
  const ProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final programs = context.watch<HomeCubit>().state.programs;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Programs'),
      body: ListView.builder(
        itemCount: programs.length,
        itemBuilder: (context, index) {
          final item = programs[index];
          final videoCount = int.tryParse(
                RegExp(r'\\d+').firstMatch(item.subtitle)?.group(0) ?? '') ??
              0;
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
