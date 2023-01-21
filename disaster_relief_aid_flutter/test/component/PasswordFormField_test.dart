import 'package:disaster_relief_aid_flutter/DRA.config.dart';
import 'package:disaster_relief_aid_flutter/component/PasswordFormField.component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// import the widget to test

// import 'package:disaster_relief_aid_flutter/App.dart';

void main() {
  testWidgets("PasswordFormField renders", (WidgetTester tester) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    // Render the widget
    await tester.pumpWidget(MaterialApp(
        title: "test",
        home: Scaffold(
            body: Form(
          key: _formKey,
          child: PasswordFormField(
            onSaved: (password) {},
          ),
        ))));
  });

  testWidgets("PasswordFormField retains input and saves",
      (WidgetTester tester) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String enteredPassword = "";
    String passwordToEnter = "password";

    // Render the widget
    await tester.pumpWidget(MaterialApp(
        title: "test",
        home: Scaffold(
            body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    PasswordFormField(
                      onSaved: (password) {
                        enteredPassword = password;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                          }
                        },
                        child: const Text("Submit"))
                  ],
                )))));

    // test that the TextFormField can be found
    expect(find.byType(TextFormField), findsOneWidget);

    // test that the TextFormField can be typed into
    await tester.enterText(find.byType(TextFormField), passwordToEnter);

    // test that the TextFormField can be submitted
    await tester.tap(find.byType(ElevatedButton));

    // test that the password was saved
    expect(enteredPassword, passwordToEnter);
  });

  testWidgets("PasswordFormField checks password security",
      (WidgetTester tester) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    String enteredPassword = "";
    String passwordToEnter = "password";

    // Render the widget
    await tester.pumpWidget(MaterialApp(
        title: "test",
        home: Scaffold(
            body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    PasswordFormField(
                      onSaved: (password) {
                        enteredPassword = password;
                      },
                      checkStrength: true,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                          }
                        },
                        child: const Text("Submit"))
                  ],
                )))));

    // test that the TextFormField can be found
    expect(find.byType(TextFormField), findsOneWidget);

    // test that the TextFormField can be typed into
    await tester.enterText(find.byType(TextFormField), passwordToEnter);

    // test that the TextFormField can be submitted
    await tester.tap(find.byType(ElevatedButton));

    // test that the password was not saved
    expect(enteredPassword, "");

    // add delay
    await tester.pumpAndSettle();

    // test that the error message is displayed
    final errorMessage = find.text(Config.passwordWeakMessage);
    expect(errorMessage, findsOneWidget);

    // change the password to a strong password
    passwordToEnter = "#@JHSD()F*)(DSF*DS";

    // test that the TextFormField can be typed into
    await tester.enterText(find.byType(TextFormField), passwordToEnter);

    // test that the TextFormField can be submitted
    await tester.tap(find.byType(ElevatedButton));

    // test that the password was saved
    expect(enteredPassword, passwordToEnter);
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
