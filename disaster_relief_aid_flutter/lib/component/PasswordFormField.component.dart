import 'package:disaster_relief_aid_flutter/DRA.config.dart';
import 'package:flutter/material.dart';

/// TODO: In the future may need some way to visualize the strength needed for password.
/// ex: password requires 1 uppercase, 1 lowercase, 1 number, 1 special character, and 8 characters long.

class PasswordFormField extends StatefulWidget {
  PasswordFormField(
      {required this.onSaved,
      this.onChanged,
      this.labelText = "Password",
      this.hintText = "Enter your password",
      this.checkStrength = false,
      this.eye = true,
      this.border = false,
      super.key});

  final String labelText;
  final String hintText;

  /// Whether the user is creating a new password or entering an existing one.
  /// If `true`, the password will be checked for strength.
  final bool checkStrength;

  /// Whether the field should show an eye icon to toggle visibility.
  final bool eye;

  /// whether to show the bottom border of the field.
  final bool border;

  /// Called when the form is submitted.
  /// If `checkStrength` is `true`, the password will be checked for strength.
  final dynamic Function(String password) onSaved;
  dynamic Function(String password)? onChanged;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          enabledBorder:
              widget.border ? const UnderlineInputBorder() : InputBorder.none,
          suffixIcon: widget.eye
              ? InkWell(
                  onTap: (() {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  }),
                  onLongPress: () {
                    /// Show a tooltip to explain the eye icon.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Press to ${_obscureText ? "show" : "hide"} password"),
                      ),
                    );
                  },
                  child: Ink(
                      child: Icon(_obscureText
                          ? Icons.visibility
                          : Icons.visibility_off)),
                )
              : null),
      autofillHints: const [AutofillHints.password],
      onSaved: ((pwd) {
        if (pwd != null && pwd.isNotEmpty) widget.onSaved(pwd);
      }),
      onChanged: (pwd) {
        if (pwd != null && pwd.isNotEmpty && widget.onChanged != null) {
          widget.onChanged!(pwd);
        }
      },
      validator: ((pwd) {
        if (pwd == null || pwd.isEmpty) {
          return 'Please enter a password';
        }

        if (widget.checkStrength) {
          // check password strength
          return Config.passwordValidator(pwd);
        } else {
          return null;
        }
      }),
    );
  }
}
