import 'package:disaster_relief_aid_flutter/view/InputProfileInfo.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Input Profile Info view renders", (WidgetTester tester) async {
    // Render the widget
    await tester.pumpWidget(const MaterialApp(
      home: InputProfileInfo(),
    ));
  });
}
