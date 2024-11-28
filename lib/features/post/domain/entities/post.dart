import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peer_circle/features/post/domain/comment.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timeStamp;
  final List<String> likes;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.imageUrl,
    required this.text,
    required this.timeStamp,
    required this.likes,
    required this.comments,
  });

  Post copyWith({String? imageUrl}) {
    return Post(
        id: id,
        userId: userId,
        userName: userName,
        imageUrl: imageUrl ?? this.imageUrl,
        text: text,
        timeStamp: timeStamp,
        likes: likes,
        comments: comments);
  }

  // convert to josn file so . for storing to the firebase.

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': userName,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timeStamp),
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }

  // convert to json to post

  factory Post.fromJson(Map<String, dynamic> json) {
    final List<Comment> comments = (json['comments'] as List<dynamic>?)?.map((commentJson)=> Comment.fromJson(commentJson)).toList()?? [];
    return Post(
      id: json['id'],
      userId: json['userId'],
      userName: json['name'],
      imageUrl: json['imageUrl'],
      text: json['text'],
      timeStamp: (json['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(json['likes'] ?? []),
      comments: comments,
    );
  }
}
