import 'package:albus_la_mobile/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PwTextFieldWidget extends StatefulWidget {
  const PwTextFieldWidget({
    super.key,
    required this.controller,
    this.fillColor,
    required this.hintText,
    this.errorText,
    this.helperText,
    this.onChanged,
  });
  final TextEditingController controller;
  final Color? fillColor;
  final String hintText;
  final String? errorText;
  final String? helperText;
  final void Function(String)? onChanged;

  @override
  State<PwTextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<PwTextFieldWidget> {
  bool _isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscureText,
      maxLines: 1,
      maxLength: 100,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: widget.fillColor,
        hintText: widget.hintText,
        errorText: widget.errorText,
        label: Text(widget.hintText),
        helperText: widget.helperText,
        suffixIcon: IconButton(
          icon: Icon(
            _isObscureText ? I.visibilityOff : I.visibility,
            color: widget.errorText == null
                ? null
                : Theme.of(context).colorScheme.error,
          ),
          onPressed: () => setState(() => _isObscureText = !_isObscureText),
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'[a-zA-Z0-9!@#$%^&*(),.?":{}|<>]'),
        ),
      ],
      onChanged: widget.onChanged,
    );
  }
}
