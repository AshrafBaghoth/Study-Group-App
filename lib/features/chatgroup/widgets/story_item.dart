import 'package:flutter/material.dart';

class StoryItem extends StatelessWidget {
  final String? img;
  final VoidCallback onTap;
  final String title;
  const StoryItem({
    super.key,
    required this.img,
    required this.onTap,
    required this.title,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: img != null ? NetworkImage(img!) : null,
          child: img == null ? const Icon(Icons.person) : null,
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    ),
  );
}
