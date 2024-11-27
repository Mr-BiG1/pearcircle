// profile repo file.


import 'package:peer_circle/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserprofile(String uid);
  Future<void> updateProfile(ProfileUser updateProfile);
  Future<void> toggleFlow(String currentUid, String targetUid);
}
