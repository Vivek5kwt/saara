import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saara/app.dart';

void main() {
  testWidgets('Splash screen shows logo', (tester) async {
    await tester.pumpWidget(const App());
    expect(find.image(const AssetImage('assets/images/splash_logo.png')), findsOneWidget);
  });
}
