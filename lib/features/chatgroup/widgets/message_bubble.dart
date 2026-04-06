import 'package:flutter/material.dart';
import 'package:instproject/features/chatgroup/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel msg;
  const MessageBubble({super.key, required this.msg});

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMe = msg.senderId == FirebaseAuth.instance.currentUser?.uid;

    return FutureBuilder<Map<String, dynamic>?>(
      future: getUserData(msg.senderId),
      builder: (context, snapshot) {
        final userData = snapshot.data;
        final userName = userData?['name'] ?? 'User';
        final userImage = userData?['photoUrl'];

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: userImage != null
                            ? NetworkImage(userImage)
                            : null,
                        child: userImage == null
                            ? const Icon(Icons.person, size: 16)
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.brown : Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: msg.imageUrl != null && msg.imageUrl!.isNotEmpty
                      ? Image.network(msg.imageUrl!, width: 180)
                      : Text(msg.text, style: const TextStyle(fontSize: 15, color: Colors.black)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
