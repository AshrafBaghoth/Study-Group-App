import 'package:flutter/material.dart';

class StoryItemShow extends StatelessWidget {
  final String? imageUrl;
  final String? quote;
  const StoryItemShow({super.key, this.imageUrl, this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                ? NetworkImage(imageUrl!)
                : null,
            child: imageUrl == null ? const Icon(Icons.format_quote) : null,
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              quote ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
