import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peer_circle/features/post/domain/entities/post.dart';
import 'package:peer_circle/features/post/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //storing into  a collection called post.
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('post');

  @override
  // Creating post
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

// deleting post
  @override
  Future<void> deletePost(String postId) async {
    try {
      await postsCollection.doc(postId).delete();
    } catch (e) {
      throw Exception("Error deleting post: $e");
    }
  }

// fetching single post
  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final postsSnapshot =
          await postsCollection.orderBy('timestamp', descending: true).get();

      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allPosts;
    } catch (e) {
      throw Exception("Error deleting post: $e");
    }
  }

// fetching all post.
  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      final postsSnapshot =
          await postsCollection.where('userId', isEqualTo: userId).get();

      // converting the doc to json

      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;
    } catch (e) {
      throw Exception("Error deleting post: $e");
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      // getting up the doc.
      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // if liked
        final hasLiked = post.likes.contains(userId);

        if (hasLiked) {
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }

        // updating the changes

        await postsCollection.doc(postId).update({
          'likes': post.likes,
        });
      } else {
        throw Exception("Post Not found");
      }
    } catch (e) {
      throw Exception("error toggling like: $e");
    }
  }
}
