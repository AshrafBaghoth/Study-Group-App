import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instproject/features/posts/data/appwrite_storage_post_repo.dart';
import '../../domain/post_repo.dart';
import '../../data/post_model.dart';
import 'post_states.dart';

class PostCubit extends Cubit<PostStates> {
  final PostRepo postRepo;
  final AppwritePostStorageRepo storageRepo;
  final _firestore = FirebaseFirestore.instance;

  List<Post> _posts = [];

  PostCubit({required this.postRepo, required this.storageRepo})
    : super(PostInitial());

  
  Future<void> fetchAllPosts() async {
    emit(PostLoading());
    try {
      final posts = await postRepo.fetchAllPosts();
      _posts = posts;
      emit(PostLoaded(posts));
    } catch (e, st) {
      print(' [PostCubit] Fetch failed: $e');
      print(st);
      emit(PostError(e.toString()));
    }
  }

  
  Future<void> fetchPostsByUserId(String userId) async {
    emit(PostLoading());
    try {
      final posts = await postRepo.fetchPostsByUserId(userId);
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  
  Future<void> createPost({
    required String userId,
    required String caption,
    required String imagePath,
  }) async {
    emit(PostLoading());
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();
      final userName = userData?['name'] ?? 'Unknown User';
      final userProfileImage = userData?['profileImg'] ?? '';

      final imageUrl = await storageRepo.uploadPostImage(imagePath, userId);

      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        userName: userName,
        userProfileImage: userProfileImage,
        caption: caption,
        imageUrl: imageUrl ?? '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        likeCount: 0,
        likes: [],
        savedBy: [],
        isSaved: false,
      );

      await postRepo.createPost(post);
      _posts.insert(0, post);
      emit(PostLoaded(List.from(_posts)));
    } catch (e, st) {
      print(' [PostCubit] Create post failed: $e');
      print(st);
      emit(PostError(e.toString()));
    }
  }

 
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
      _posts.removeWhere((p) => p.id == postId);
      emit(PostLoaded(List.from(_posts)));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  
  Future<void> toggleLike(String postId, String userId) async {
    try {
      final currentState = state;
      if (currentState is PostLoaded) {
        final updatedPosts = currentState.posts.map((post) {
          if (post.id == postId) {
            final newLikes = List<String>.from(post.likes);
            if (newLikes.contains(userId)) {
              newLikes.remove(userId);
            } else {
              newLikes.add(userId);
            }
            return post.copyWith(likes: newLikes);
          }
          return post;
        }).toList();

        emit(PostLoaded(updatedPosts));
      }

      final postRef = _firestore.collection('posts').doc(postId);
      final doc = await postRef.get();
      if (!doc.exists) return;

      final data = doc.data()!;
      final likes = List<String>.from(data['likes'] ?? []);

      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }

      await postRef.update({'likes': likes, 'likeCount': likes.length});
    } catch (e, st) {
      print(' [PostCubit] toggleLike error: $e');
      print(st);
      emit(PostError(e.toString()));
    }
  }

  
  Future<void> addComment(String postId, String userId, String text) async {
    try {
      await postRepo.addComment(postId, userId, text);
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<List<Map<String, dynamic>>> getComments(String postId) async {
    return await postRepo.getComments(postId);
  }

  
  Future<void> toggleSavePost(String postId, String userId) async {
  try {
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

    
    final currentState = state;
    if (currentState is PostLoaded) {
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(savedBy: savedBy);
        }
        return post;
      }).toList();
      emit(PostLoaded(List.from(updatedPosts)));

    }

    
    emit(SavedPostsUpdated());  
  } catch (e, st) {
    print(' [PostCubit] toggleSavePost error: $e');
    print(st);
    emit(PostError(e.toString()));
  }
}


  
  Future<List<Post>> getSavedPosts(String userId) async {
    try {
      final query = await _firestore
          .collection('posts')
          .where('savedBy', arrayContains: userId)
          .get();
      return query.docs.map((doc) => Post.fromMap(doc.data())).toList();
    } catch (e) {
      print(' [PostCubit] getSavedPosts error: $e');
      return [];
    }
  }
}
