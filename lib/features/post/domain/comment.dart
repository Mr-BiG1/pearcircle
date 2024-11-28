import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timeStamp;

  Comment({
    required this.id,
    required this.postId,
    required this.text,
    required this.timeStamp,
    required this.userId,
    required this.userName,
  });

  // converting to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'text': text,
      'timeStamp': Timestamp.fromDate(timeStamp),
    };
  }

  //converting json -> comment.
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      text: json['text'],
      timeStamp: (json['timestamp'] as Timestamp).toDate(),
      userId: json['userId'],
      userName: json['userName'],
    );
  }
}
