import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
   final VoidCallback? function;
  final String text;
  final Size minimumSize;
  const MyButton({
    super.key,
    required this.function,
    required this.text,
    required this.minimumSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        minimumSize: Size(120, 40),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      onPressed: function,
      child: Text(text, style: TextStyle(fontSize: 18)),
    );
  }
}
