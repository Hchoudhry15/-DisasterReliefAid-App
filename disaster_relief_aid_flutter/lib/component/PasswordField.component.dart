import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PasswordField extends StatelessWidget {
  const PasswordField(
      {required this.checkStrength, required this.onChanged, super.key});

  /// Whether the user is creating a new password or entering an existing one.
  /// If `true`, the password will be checked for strength.
  final bool? checkStrength;

  /// Called when the user changes the value of the password field.
  /// The password is passed as a parameter.
  final dynamic Function(String password) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Password',
      ),
      onChanged: ((value) {
        onChanged(value);
      }),
    );
  }
}
