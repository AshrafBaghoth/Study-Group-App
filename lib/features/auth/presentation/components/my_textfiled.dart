import 'package:flutter/material.dart';

class MyTextfiled extends StatelessWidget {
  final String hint;
  final bool? obsecure;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  const MyTextfiled({
    super.key,
    required this.hint,
    required this.obsecure,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      obscureText: obsecure!,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.brown),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.brown),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
