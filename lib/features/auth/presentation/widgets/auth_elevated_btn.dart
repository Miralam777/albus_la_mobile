import 'package:flutter/material.dart';

class AuthElevatedBotton extends StatelessWidget {
  const AuthElevatedBotton({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
  });
  final IconData icon;
  final String title;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(title),
        onPressed: onPressed,
      ),
    );
  }
}
