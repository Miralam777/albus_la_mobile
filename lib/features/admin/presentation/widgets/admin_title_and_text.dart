import 'package:flutter/material.dart';

class AdminTitleAndTextWidget extends StatelessWidget {
  const AdminTitleAndTextWidget({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            text ?? '',
            textAlign: TextAlign.left,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
