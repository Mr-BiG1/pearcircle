// import 'package:peer_circle/features/auth/domain/entities/app_user.dart';

// abstract class AuthRepo {
//   Future<AppUser?> loginWithEmailPassword(String email, String password);
//   Future<AppUser?> registerWithEmailPassword(String name, String email,
//       String collage, String campus, String password);
//   Future<void> logout();
//   Future<AppUser?> getCurretnUser(){
//     throw UnimplementedError();
//   }
// }

import 'package:peer_circle/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(String name, String email,
      String collage, String campus, String password);
  Future<void> logout();
  Future<AppUser?> getCurretnUser();
}
 