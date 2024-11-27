import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_circle/features/post/domain/repos/post_repo.dart';
import 'package:peer_circle/features/post/presentation/cubits/post_states.dart';
import 'package:peer_circle/features/storage/domain/storage_repo.dart';

import '../../domain/entities/post.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({required this.postRepo, required this.storageRepo})
      : super(PostInitial());

// crating new post.

  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;
    try {
      //  handling image using file path
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl =
            await storageRepo.uploadPostProfileImageMobile(imagePath, post.id);
      }
      // handling image using web bytes.
      else if (imageBytes != null) {
        emit(PostUploading());
        imageUrl =
            await storageRepo.uploadPostProfileImageWeb(imageBytes, post.id);
      }
      // create  post in the backend.
      final newPost = post.copyWith(imageUrl: imageUrl);

      // getting pot the code.
      postRepo.createPost(newPost);

      // fetching all posts
      fetchAllPost();
    } catch (e) {
      throw Exception("Error on creating post:$e");
    }
  }

//   fetching all post
  Future<void> fetchAllPost() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      throw Exception("Error on creating post:$e");
    }
  }

// delete post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      throw Exception("Error on deleting post:$e");
    }
  }

  // like post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
      //  if im fetching all post again it will force screen to load again . so optimizing the code like it is change the values locale 
      // fetchAllPost();
    } catch (e) {
      throw Exception("Error on liking post $e");
    }
  }
}
