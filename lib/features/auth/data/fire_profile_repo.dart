import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instproject/features/auth/domain/entities/app_user.dart';
import 'package:instproject/features/auth/domain/repos/profile_repo.dart';


class FireProfileRepo implements ProfileRepo {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> fetchUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data()!);
  }

  @override
  Future<void> updateProfile(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }
}
