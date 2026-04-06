import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/post_repo.dart';
import 'post_model.dart';

class FirePostRepo implements PostRepo {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createPost(Post post) async {
    print(' [FirePostRepo] Creating new post for ${post.userName}');
    await FirebaseFirestore.instance.collection('posts').doc(post.id).set({
      'id': post.id,
      'userId': post.userId,
      'userName': post.userName,
      'userProfileImage': post.userProfileImage,
      'caption': post.caption,
      'imageUrl': post.imageUrl,
      'likes': post.likes,
      'likeCount': post.likeCount,
      'isSaved': post.isSaved,
      'createdAt': post.createdAt,
    });

  }

  @override
 


  

  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }



  @override
  Future<List<Post>> fetchAllPosts() async {
    print(' [FirePostRepo] Getting all posts from Firestore...');
    try {
      final snapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      print(' [FirePostRepo] Found ${snapshot.docs.length} docs');
      return snapshot.docs.map((doc) => Post.fromMap(doc.data())).toList();
    } catch (e, st) {
      print(' [FirePostRepo] Error while loading posts: $e');
      print(st);
      return [];
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    final snapshot = await _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((d) => Post.fromMap(d.data())).toList();
  }

  
  @override
  Future<void> toggleLike(String postId, String userId) async {
    print(' Firestore toggleLike() updating post $postId');
    final likeRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId);
    final doc = await likeRef.get();

    if (doc.exists) {
      await likeRef.delete();
      await _firestore.collection('posts').doc(postId).update({
        'likeCount': FieldValue.increment(-1),
      });
    } else {
      await likeRef.set({
        'userId': userId,
        'likedAt': DateTime.now().millisecondsSinceEpoch,
      });
      await _firestore.collection('posts').doc(postId).update({
        'likeCount': FieldValue.increment(1),
      });
    }
  }

  @override
  Future<bool> isPostLiked(String postId, String userId) async {
    final doc = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId)
        .get();
    return doc.exists;
  }

  
  @override
  Future<void> addComment(String postId, String userId, String text, ) async {
    final commentRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc();
    await commentRef.set({
      'id': commentRef.id,
      'userId': userId,
      'text': text,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getComments(String postId) async {
    final snapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((d) => d.data()).toList();
  }

  
  @override
  Future<void> toggleSavePost(String postId, String userId) async {
    final postRef = _firestore.collection('posts').doc(postId);
    final doc = await postRef.get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final savedBy = List<String>.from(data['savedBy'] ?? []);

    if (savedBy.contains(userId)) {
      savedBy.remove(userId);
    } else {
      savedBy.add(userId);
    }

    await postRef.update({'savedBy': savedBy});
  }


  @override
  Future<List<String>> getSavedPostsIds(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('saved')
        .get();
    return snapshot.docs.map((d) => d.id).toList();
  }

  @override
 Future<List<Post>> getSavedPosts(String userId) async {
    final snapshot = await _firestore
        .collection('posts')
        .where('savedBy', arrayContains: userId)
        .get();
    return snapshot.docs.map((d) => Post.fromMap(d.data())).toList();
  }


  Stream<List<Post>> streamPostsByUserId(String userId) {
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Post.fromMap(doc.data())).toList(),
        );
  }

  Stream<List<Post>> streamAllPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Post.fromMap(doc.data())).toList(),
        );
  }
}
