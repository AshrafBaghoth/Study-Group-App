import 'package:equatable/equatable.dart';
import '../../data/post_model.dart';

abstract class PostStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostInitial extends PostStates {}

class PostLoading extends PostStates {}

class PostLoaded extends PostStates {
  final List<Post> posts;
  PostLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostError extends PostStates {
  final String message;
  PostError(this.message);

  @override
  List<Object?> get props => [message];
}

class PostSaving extends PostStates {
  final String postId;
  PostSaving(this.postId);
}

class SavedPostsUpdated extends PostStates {
  final List<String> savedIds;
  SavedPostsUpdated([this.savedIds = const []]);

  @override
  List<Object?> get props => [savedIds];
}

