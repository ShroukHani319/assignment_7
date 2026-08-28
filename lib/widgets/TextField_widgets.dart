import 'package:flutter/material.dart';

class TextfieldWidgets extends StatelessWidget {
  const TextfieldWidgets({
    super.key,
    required this.controller,
    required this.vali,
    required this.hint,
  });

  final TextEditingController controller;
  final String vali;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return vali;
        }
        return null;
      },
      decoration: InputDecoration(hintText: hint, border: OutlineInputBorder()),
    );
  }
}
