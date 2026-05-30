import 'package:flutter/material.dart';

class AuthTextBtn extends StatelessWidget {
  const AuthTextBtn({super.key, required this.text, required this.onPressed});

  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
