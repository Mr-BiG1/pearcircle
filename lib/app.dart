import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_circle/features/auth/data/firebase_auth_repo.dart';
import 'package:peer_circle/features/Home/presentation/pages/home_page.dart';
import 'package:peer_circle/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:peer_circle/features/auth/presentation/cubits/auth_states.dart';
import 'package:peer_circle/features/auth/presentation/pages/auth_pages.dart';
import 'package:peer_circle/features/post/data/firebase_post_repo.dart';
import 'package:peer_circle/features/post/presentation/cubits/post_cubits.dart';
import 'package:peer_circle/features/profile/data/firebase_profile_repo.dart';
import 'package:peer_circle/features/profile/presentation/cubits/progile_cubit.dart';
import 'package:peer_circle/features/storage/data/firebase_storage_repo.dart';
import 'package:peer_circle/features/theams/light_mode.dart';

/* 
root level file.
*/
class MyApp extends StatelessWidget {
  //Auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();

  //profile repo.
  final firebaseProfileRepo = FirebaseProfileRepo();

  // storage repo
  final firebaseStorageRepo = FirebaseStorageRepo();

  // post  repo

  final firebasePostRepo = FirebasePostRepo();
  MyApp({
    super.key,
  });

// providing the  cubit to app.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // auth vubit
        BlocProvider<AuthCubit>(
            create: (context) =>
                AuthCubit(authRepo: firebaseAuthRepo)..checkAuth()),

        //profile cubit
        BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
                profileRepo: firebaseProfileRepo,
                storageRepo: firebaseStorageRepo)),

        // post  cubit
        BlocProvider<PostCubit>(
            create: (context) => PostCubit(
                  postRepo: firebasePostRepo,
                  storageRepo: firebaseStorageRepo,
                ))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthStates>(
          builder: (context, authState) {
            print(authState); 
            if (authState is Unauthenticated) {
              return const AuthPages();
            }

            if (authState is Authenticated) {
              return const HomePage();
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}

// MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: lightMode,
//       home: const AuthPages(),
//     );
