import 'package:flutter/material.dart';

class FieldInfo extends StatelessWidget {
  const FieldInfo({
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    super.key,
  });

  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText, 
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
