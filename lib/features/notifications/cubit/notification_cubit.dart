import 'package:bloc/bloc.dart';

class NotificationCubit extends Cubit<List<String>> {
  NotificationCubit()
      : super(const [
          'Welcome to Saara!',
          'Your 14 day free trial has started.',
          'New classes have been added.'
        ]);
}
