import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.errorText,
    this.keyType = TextInputType.text,
    this.suffixIcon,
    this.maxLength,
    this.fillColor,
    this.maxLines,
    this.minLines,
    this.inputFormatters,
    this.helperText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final String? errorText;
  final IconData? suffixIcon;
  final TextInputType keyType;
  final int? maxLength;
  final Color? fillColor;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? helperText;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines ?? 1,
      minLines: minLines,
      keyboardType: keyType,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: maxLength != null ? null : '',
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        errorText: errorText,
        label: Text(labelText ?? hintText),
        helperText: helperText,
        suffixIcon: suffixIcon != null
            ? Icon(
                suffixIcon,
                color: errorText == null
                    ? null
                    : Theme.of(context).colorScheme.error,
              )
            : null,
      ),
      onChanged: onChanged,
      inputFormatters: inputFormatters,
    );
  }
}
