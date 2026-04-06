import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/group_repo.dart';
import '../models/group_model.dart';

class FireGroupRepo implements GroupRepo {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<List<GroupModel>> getGroups() async {
    final snap = await _firestore.collection('groups').get();
    return snap.docs.map((e) => GroupModel.fromMap(e.data())).toList();
  }

  @override
  Future<void> createGroup(
    String name,
    List<String> memberUids,
    String imageUrl,
  ) async {
    final groupRef = FirebaseFirestore.instance.collection('groups').doc();

    await groupRef.set({
      'id': groupRef.id,
      'name': name,
      'members': memberUids,
      'imageUrl': imageUrl,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<void> joinGroup(String groupId, String userId) async {
    final groupRef = _firestore.collection('groups').doc(groupId);
    final doc = await groupRef.get();

    if (!doc.exists) return;

    final data = doc.data()!;
    final members = List<String>.from(data['members'] ?? []);

    if (!members.contains(userId)) {
      members.add(userId);
      await groupRef.update({'members': members});
      print(' User $userId joined group $groupId');
    } else {
      print(' User $userId already in group $groupId');
    }
  }
}
