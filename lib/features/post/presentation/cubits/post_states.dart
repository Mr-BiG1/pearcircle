import 'package:peer_circle/features/post/domain/entities/post.dart';

abstract class PostState {}

// initial state
class PostInitial extends PostState {}

// loading
class PostLoading extends PostState {}

// upload
class PostUploading extends PostState {}

// error
class PostError extends PostState {}

// loaded
class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded(this.posts);

}
