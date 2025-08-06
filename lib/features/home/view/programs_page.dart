import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';

class ProgramsPage extends StatelessWidget {
  const ProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final programs = context.watch<HomeCubit>().state.programs;
    return Scaffold(
      appBar: AppBar(title: const Text('Programs')),
      body: ListView.builder(
        itemCount: programs.length,
        itemBuilder: (context, index) {
          final item = programs[index];
          return ListTile(
            leading: Image.asset(item.image, width: 60, fit: BoxFit.cover),
            title: Text(item.title),
            subtitle: Text(item.subtitle),
          );
        },
      ),
    );
  }
}
