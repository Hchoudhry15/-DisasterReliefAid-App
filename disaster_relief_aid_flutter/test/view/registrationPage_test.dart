import 'package:disaster_relief_aid_flutter/firebase_options.dart';
import 'package:disaster_relief_aid_flutter/view/RegistrationPage.view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import the widget to test

import 'package:disaster_relief_aid_flutter/view/CreateProfile.view.dart';

void main() {
  testWidgets("Registration Page view renders", (WidgetTester tester) async {
    // Render the widget
    await tester.pumpWidget(const MaterialApp(
      home: RegistrationPage(),
    ));
  });
}

/*
testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  // Build our app and trigger a frame.
  await tester.pumpWidget(const MyApp());

  // Verify that our counter starts at 0.
  expect(find.text('0'), findsOneWidget);
  expect(find.text('1'), findsNothing);

  // Tap the '+' icon and trigger a frame.
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  // Verify that our counter has incremented.
  expect(find.text('0'), findsNothing);
  expect(find.text('1'), findsOneWidget);
});
*/