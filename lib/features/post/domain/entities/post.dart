import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timeStamp;
  final List<String> likes;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.imageUrl,
    required this.text,
    required this.timeStamp,
    required this.likes,
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
    );
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
    };
  }

  // convert to json to post

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      userName: json['name'],
      imageUrl: json['imageUrl'],
      text: json['text'],
      timeStamp: (json['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(json['likes'] ?? []),
    );
  }
}
