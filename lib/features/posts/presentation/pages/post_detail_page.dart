import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instproject/features/posts/data/post_model.dart';
import 'package:instproject/features/posts/domain/post_repo.dart';
import 'package:instproject/features/storage/domain/appwrite_storage_repo.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = post.userId == currentUid;

    return Scaffold(
      appBar: AppBar(
        title: Text(post.userName ?? 'Post'),
        actions: [
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Delete Post"),
                    content: const Text(
                      "Are you sure you want to delete this post?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    
                    await context.read<PostRepo>().deletePost(post.id);

                    if (post.imageUrl != null && post.imageUrl!.isNotEmpty) {
                      final storageRepo = context.read<AppwriteStorageRepo>();
                      await storageRepo.deleteFileByUrl(post.imageUrl!);
                    }

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Post deleted successfully'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete post: $e')),
                    );
                  }
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              Image.network(post.imageUrl!, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                post.caption ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Posted by ${post.userName ?? "User"}",
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
