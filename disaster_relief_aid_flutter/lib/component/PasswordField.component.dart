import 'package:disaster_relief_aid_flutter/DRA.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PasswordField extends StatelessWidget {
  const PasswordField(
      {required this.checkStrength, required this.onSaved, super.key});

  /// Whether the user is creating a new password or entering an existing one.
  /// If `true`, the password will be checked for strength.
  final bool checkStrength;

  /// Called when the form is submitted.
  /// If `checkStrength` is `true`, the password will be checked for strength.
  ///
  final dynamic Function(String password) onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Password',
      ),
      onSaved: ((pwd) {
        if (pwd != null && pwd.isNotEmpty) onSaved(pwd);
      }),
      validator: ((pwd) {
        if (pwd == null || pwd.isEmpty) {
          return 'Please enter a password';
        }

        if (checkStrength) {
          // check password strength
          return Config.passwordValidator(pwd);
        } else {
          return null;
        }
      }),
    );
  }
}
