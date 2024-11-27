import 'package:peer_circle/features/auth/domain/entities/app_user.dart';

abstract class AuthStates {}

// starting ..
class AuthInitial extends AuthStates {}

//loading..
class AuthLoading extends AuthStates {}

// authenticated
class Authenticated extends AuthStates {
  final AppUser user;
  Authenticated(this.user);
}

// unauthenticated

class Unauthenticated extends AuthStates {}

// error

class AuthError extends AuthStates {
  final String message;
  AuthError(this.message);
}
