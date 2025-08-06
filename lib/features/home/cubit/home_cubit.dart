import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class ClassItem extends Equatable {
  const ClassItem({required this.image, required this.title, required this.subtitle});
  final String image;
  final String title;
  final String subtitle;
  @override
  List<Object?> get props => [image, title, subtitle];
}

class ProgramItem extends Equatable {
  const ProgramItem({required this.image, required this.title, required this.subtitle});
  final String image;
  final String title;
  final String subtitle;
  @override
  List<Object?> get props => [image, title, subtitle];
}

class HomeState extends Equatable {
  const HomeState({required this.classes, required this.programs});
  final List<ClassItem> classes;
  final List<ProgramItem> programs;
  @override
  List<Object?> get props => [classes, programs];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(const HomeState(classes: [
          ClassItem(image: 'assets/images/class1.png', title: 'Beginner Challenge', subtitle: '15 Videos'),
          ClassItem(image: 'assets/images/class2.png', title: 'ABS Challenge', subtitle: '12 Videos'),
          ClassItem(image: 'assets/images/class2.png', title: 'Daily Flow', subtitle: '20 Videos'),
        ], programs: [
          ProgramItem(image: 'assets/images/summer.png', title: 'Summer Challenge', subtitle: '15 Videos'),
          ProgramItem(image: 'assets/images/abs_waist.png', title: 'ABS & Waist Program', subtitle: '36 Videos'),
          ProgramItem(image: 'assets/images/abs_waist.png', title: 'Yoga Flow Series', subtitle: '24 Videos'),
        ]));
}
