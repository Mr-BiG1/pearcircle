import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_circle/features/profile/domain/entities/profile_user.dart';
import 'package:peer_circle/features/profile/domain/repos/profile_repo.dart';
import 'package:peer_circle/features/profile/presentation/cubits/profile_states.dart';
import 'package:peer_circle/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({required this.profileRepo, required this.storageRepo})
      : super(ProfileInitial());

  //  fetch user  profile  using  repo

  // update bio or profile image.
  Future<void> fetchUserprofile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserprofile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

//  return profile given uid  == to load profile posts
  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserprofile(uid);
    return user;
  }

  //  update  bio and  profile  picture.
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());

    try {
      final currentUser = await profileRepo.fetchUserprofile(uid);

      if (currentUser == null) {
        emit(ProfileError("Failed  to fetch user for profile  update"));
        return;
      }

      // profile picture update.

      String? imageDownloadUrl;

      if (imageWebBytes != null || imageMobilePath != null) {
        if (imageMobilePath != null) {
          imageDownloadUrl =
              await storageRepo.uploadProfileImageMobile(imageMobilePath, uid);
        } else if (imageWebBytes != null) {
          imageDownloadUrl =
              await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
        }

        if (imageDownloadUrl == null) {
          emit(ProfileError("Failed  to upload image"));
          return;
        }
      }

      //update new  profile.

      final updateProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImage,
      );

      //update  in repo

      await profileRepo.updateProfile(updateProfile);

      // re-fetch the update profile.

      await fetchUserprofile(uid);
    } catch (e) {
      emit(ProfileError("Error updating profile:" + e.toString()));
    }
  }

// toggle Follow and unFollow
  Future<void> toggleFlow(String currentUid, String targetUid) async {
    try {
      await profileRepo.toggleFlow(currentUid, targetUid);

      await fetchUserprofile(targetUid);
    } catch (e) {
      emit(ProfileError("Error  toggling  following"));
    }
  }
}
