import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String? errorText;
  final TextInputType? keyboardType;
  final Function(String)? onChange;
  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.errorText,
    this.keyboardType = TextInputType.text,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        errorText: errorText,
      ),
      onChanged: onChange,
    );
  }
}
