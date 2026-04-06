import '../data/post_model.dart';

abstract class PostRepo {
  Future<List<Post>> fetchAllPosts();
  Future<void> createPost(Post post);
  Future<void> deletePost(String postId);
  Future<List<Post>> fetchPostsByUserId(String userId);

   Stream<List<Post>> streamPostsByUserId(String userId);
   Stream<List<Post>> streamAllPosts();

  
  Future<void> toggleLike(String postId, String userId);
  Future<bool> isPostLiked(String postId, String userId);
  Future<void> addComment(String postId, String userId, String text);
  Future<List<Map<String, dynamic>>> getComments(String postId);

  Future<void> toggleSavePost(String postId, String userId);
  Future<List<String>> getSavedPostsIds(String userId);
  Future<List<Post>> getSavedPosts(String userId);
}
