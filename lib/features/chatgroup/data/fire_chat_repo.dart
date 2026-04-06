import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instproject/features/chatgroup/models/message_model.dart';


class FireChatRepo {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> streamMessages(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((e) => MessageModel.fromMap(e.data())).toList(),
        );
  }

  Future<void> sendMessage(String groupId, MessageModel msg) async {
    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(msg.id)
        .set(msg.toMap());
  }
}
