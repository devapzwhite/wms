import 'package:flutter/material.dart';

class CustomLargeTextFormField extends StatelessWidget {
  final int minLines;
  final int maxLines;
  final double borderRadius;
  final String label;
  final String? hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  const CustomLargeTextFormField({
    this.hintText = '',
    this.controller,
    this.minLines = 1,
    this.maxLines = 1,
    this.borderRadius = 0,
    this.label = '',
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        label: Text(label),
      ),
      onChanged: onChanged,
    );
  }
}
