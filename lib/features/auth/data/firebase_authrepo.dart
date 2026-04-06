import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instproject/features/auth/domain/entities/app_user.dart';
import 'package:instproject/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> RegisterWithEmailAndPassword(
    String username,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return null;

      await user.updateDisplayName(username);

      
      final appUser = AppUser(
        uid: user.uid,
        name: username,
        email: email,
        bio: "Hey there! I'm using InstProject 💬",
        profileImg:
            "https://cdn-icons-png.flaticon.com/512/3135/3135715.png", 
      );

      await _firestore.collection('users').doc(user.uid).set(appUser.toMap());

      return appUser;
    } catch (e) {
      print(" Registration Error: $e");
      rethrow;
    }
  }

  @override
  Future<AppUser?> LoginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) return null;

      return AppUser.fromMap(doc.data()!);
    } catch (e) {
      print(" Login Error: $e");
      rethrow;
    }
  }

  @override
  Future<void> Logout() async {
    await _auth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) return null;

    return AppUser.fromMap(doc.data()!);
  }
}
