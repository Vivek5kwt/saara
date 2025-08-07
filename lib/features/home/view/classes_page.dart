import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saara/widgets/custom_app_bar.dart';
import 'package:saara/widgets/class_card.dart';
import '../cubit/home_cubit.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final classes = context.watch<HomeCubit>().state.classes;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Classes'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: classes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            final item = classes[index];
            return ClassCard(
              image: item.image,
              title: item.title,
              subtitle: item.subtitle,
            );
          },
        ),
      ),
    );
  }
}
