import 'package:albus_la_mobile/constants/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedbackTextFieldWidget extends StatelessWidget {
  const FeedbackTextFieldWidget({
    super.key,
    required this.tecController,
    this.maxLines = 1,
    required this.title,
    required this.hintText,
    required this.label,
    this.errorText,
    this.isKeyboardTypeEmail = false,
    this.onChanged,
  });
  final TextEditingController tecController;
  final int maxLines;
  final String title;
  final String hintText;
  final String label;
  final String? errorText;
  final bool isKeyboardTypeEmail;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.only(left: 12.0.w, bottom: 4.0.h),
            child: Text(title, style: textTheme.bodyMedium),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(K.rl),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0.w),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(K.rl),
                ),
                child: TextField(
                  controller: tecController,
                  keyboardType: isKeyboardTypeEmail
                      ? TextInputType.emailAddress
                      : TextInputType.text,
                  maxLines: maxLines,
                  style: textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: hintText,
                    labelText: label,
                    errorText: errorText,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5.h,
                      horizontal: 10.w,
                    ),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
