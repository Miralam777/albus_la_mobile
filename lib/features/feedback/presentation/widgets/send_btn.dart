import 'package:flutter/material.dart';

class SendBtnWidget extends StatelessWidget {
  const SendBtnWidget({super.key, required this.onPressed});

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        // TODO: text
        child: const Text('Feedback Senden'),
      ),
    );
  }
}
