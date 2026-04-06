import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentsPage extends StatefulWidget {
  final String postId;
  final String currentUserId;

  const CommentsPage({
    super.key,
    required this.postId,
    required this.currentUserId,
  });

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final _controller = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _scrollController = ScrollController();

  Future<void> _sendComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final userDoc = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();
    final userData = userDoc.data() ?? {};

    await _firestore
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .add({
          'text': text,
          'userId': currentUser.uid,
          'userName': userData['name'] ?? 'Unknown User',
          'photoUrl': userData['profileImg'] ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });

    _controller.clear();

    // Auto-scroll to the latest comment
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final comments = snapshot.data?.docs ?? [];

                if (comments.isEmpty) {
                  return const Center(child: Text('No comments yet'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: comments.length,
                  itemBuilder: (context, i) {
                    final c = comments[i].data() as Map<String, dynamic>;
                    final name = c['userName'] ?? 'Unknown User';
                    final text = c['text'] ?? '';
                    final photoUrl =
                        c['photoUrl'] ??
                        'https://cdn-icons-png.flaticon.com/512/149/149071.png';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(photoUrl),
                      ),
                      title: Text(name),
                      subtitle: Text(text),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.brown),
                  onPressed: _sendComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
