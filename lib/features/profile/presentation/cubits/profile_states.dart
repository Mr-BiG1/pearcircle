// profile states.

import 'package:peer_circle/features/profile/domain/entities/profile_user.dart';

abstract class ProfileStates {}

// initial

class ProfileInitial extends ProfileStates {}

//loading

class ProfileLoading extends ProfileStates {}

//loading

class ProfileLoaded extends ProfileStates {
  final ProfileUser profilUser;

  ProfileLoaded(this.profilUser);
}

// error
class ProfileError extends ProfileStates {
  final String message;
  ProfileError(this.message);
}
