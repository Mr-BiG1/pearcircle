import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_circle/features/auth/domain/entities/app_user.dart';
import 'package:peer_circle/features/auth/domain/repos/auth_repo.dart';
import 'package:peer_circle/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo authRepo;

  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  // checking the user is already authenticated

  void checkAuth() async {
    final AppUser? user = await authRepo.getCurretnUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  // get current user
  AppUser? get currentUser => _currentUser;

  //login with email and pass

  Future<void> login(String email, String pass) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, pass);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // register with email and pass.
  Future<void> register(
    String name,
    String email,
    String collage,
    String campus,
    String pass,
  ) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailPassword(
          email, pass, name, collage, campus);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // logout

  Future<void> logout() async {
    try {
      authRepo.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed: $e'));
    }
  }
}
