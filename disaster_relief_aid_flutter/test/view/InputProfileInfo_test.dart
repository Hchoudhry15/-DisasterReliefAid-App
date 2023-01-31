import 'package:disaster_relief_aid_flutter/view/InputProfileInfo.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../mock.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  setupFirebaseAuthMocks();
  testWidgets("Input Profile Info view renders", (WidgetTester tester) async {
    await Firebase.initializeApp();
    // Render the widget
    await tester.pumpWidget(const MaterialApp(
      home: InputProfileInfo(),
    ));
  });
}
