import 'package:flutter/material.dart';
import '../../data/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/post_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/pages/comments_page.dart';

class PostTile extends StatelessWidget {
  final Post post;
  const PostTile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUid = currentUser?.uid ?? '';

    final isLiked = post.likes.contains(currentUid);
    final isMark = post.isSavedBy(currentUid);
    final profileImage = post.userProfileImage.isNotEmpty
        ? post.userProfileImage
        : 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
    final userName = post.userName.isNotEmpty ? post.userName : 'Unknown User';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(profileImage),
              radius: 22,
            ),
            title: Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateTime.fromMillisecondsSinceEpoch(
                post.createdAt,
              ).toLocal().toString().substring(0, 16),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (_) => PostDetailPage(post: post)),
            //   );
            // },
          ),
          if (post.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: 250,
                    color: Colors.brown,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  debugPrint(' Failed to load ${post.imageUrl}');
                  debugPrint(error.toString());
                  return Container(
                    height: 250,
                    color: Colors.black12,
                    child: const Icon(
                      Icons.broken_image,
                      size: 60,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Row(
              children: [
                // IconButton(
                //   icon: Icon(
                //     isLiked ? Icons.favorite : Icons.favorite_border,
                //     color: isLiked ? Colors.red : null,
                //   ),
                //   onPressed: () =>
                //       context.read<PostCubit>().toggleLike(post.id, currentUid),
                // ),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CommentsPage(
                          postId: post.id,
                          currentUserId: currentUid,
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(),
                IconButton(
                  icon: Icon(
                    isMark ? Icons.bookmark : Icons.bookmark_border,
                    color: isMark ? Colors.brown : null,
                  ),
                  onPressed: () => context.read<PostCubit>().toggleSavePost(
                    post.id,
                    currentUid,
                  ),
                ),
              ],
            ),
          ),

          
          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4,
              ),
              child: Text(post.caption),
            ),
        ],
      ),
    );
  }
}
