import 'package:peer_circle/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImage;
  final List<String> followers;
  final List<String> following;

  ProfileUser(
      {required super.uid,
      required super.email,
      required super.collage,
      required super.campus,
      required super.name,
      required this.bio,
      required this.profileImage,
      required this.following,
      required this.followers});

  ProfileUser copyWith(
      {String? newBio,
      String? newProfileImageUrl,
      List<String>? newFollowers,
      List<String>? newFollowing}) {
    return ProfileUser(
        uid: uid,
        email: email,
        collage: collage,
        campus: campus,
        name: name,
        bio: newBio ?? bio,
        profileImage: newProfileImageUrl ?? profileImage,
        followers: newFollowers ?? followers,
        following: newFollowing ?? following);
  }

  // covert the user to json file.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'collage': collage,
      'campus': campus,
      'ProfileImageUrl': profileImage,
      'followers':followers,
      'following':following,
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> Json) {
    return ProfileUser(
        uid: Json['uid'],
        email: Json['email'],
        collage: Json['collage'],
        campus: Json['campus'],
        name: Json['name'],
        bio: Json['bio'] ?? '',
        profileImage: Json['profileImage'],
        followers: List<String>.from(Json['followers'] ??[]),
        following: List<String>.from(Json['following'] ?? []));
  }
}
