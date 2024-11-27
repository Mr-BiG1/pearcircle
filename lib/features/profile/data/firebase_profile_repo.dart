import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peer_circle/features/profile/domain/entities/profile_user.dart';
import 'package:peer_circle/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<ProfileUser?> fetchUserprofile(String uid) async {
    // try {
    //   // get user document  from  firestore.
    //   final UserDoc =
    //       await firebaseFirestore.collection('users').doc("N2GOFKtEPzTquCREXhHYYA3p8BE2").get();

    //   if (UserDoc.exists) {
    //     final userDate = UserDoc.data();
    //     // fetching the followers and following.
    //     final userDoc =
    //         await firebaseFirestore.collection('users').doc(uid).get();
    //     if (userDate != null) {
    //       final followers = List<String>.from(userDoc['followers'] ?? []);
    //       final following = List<String>.from(userDoc['following'] ?? []);

    //       return ProfileUser(
    //         uid: uid,
    //         email: userDate['email'],
    //         collage: userDate['collage'],
    //         campus: userDate['campus'],
    //         name: userDate['name'],
    //         bio: userDate['bio'] ?? '',
    //         profileImage: userDate['profileImage'].toString(),
    //         followers: followers,
    //         following: following,
    //       );
    //     }
    //   }

    //   return null;
    // } catch (e) {
    //   return null;
    // }

    // gpt version
    try {
      // Get user document from Firestore.
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          // Fetch followers and following lists (if they exist).
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);

          // Construct and return a ProfileUser object.
          return ProfileUser(
            uid: uid,
            email: userData['email'],
            collage: userData['collage'],
            campus: userData['campus'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImage: userData['profileImage'].toString(),
            followers: followers,
            following: following,
          );
        }
      }

      // Return null if the document doesn't exist or has no data.
      return null;
    } catch (e) {
      // Log or handle the error appropriately.
      print("Error fetching user profile: $e");
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updateProfile) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(updateProfile.uid)
          .update({
        'bio': updateProfile.bio,
        'profileImage': updateProfile.profileImage,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> toggleFlow(String currentUid, String targetUid) async {
    try {
      final currentUserDoc =
          await firebaseFirestore.collection('users').doc(currentUid).get();

      final targetUserDoc =
          await firebaseFirestore.collection('users').doc(targetUid).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing =
              List<String>.from(currentUserData['following'] ?? []);

          // if already a follower
          if (currentFollowing.contains(targetUid)) {
            // unfollow
            await firebaseFirestore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayRemove([targetUid])
            });
            await firebaseFirestore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayRemove([currentUid])
            });
          } else {
            // following
            await firebaseFirestore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayUnion([targetUid])
            });

            await firebaseFirestore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayUnion([currentUid])
            });
          }
        }
      }
    } catch (e) {}
  }
}
