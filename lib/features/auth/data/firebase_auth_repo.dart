import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peer_circle/features/auth/domain/entities/app_user.dart';
import 'package:peer_circle/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      // signin
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // fetching the user dco
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // create user.

      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: '',
        collage: '',
        campus: userDoc['name'],
      );

      //return user

      return user;
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(String name, String email,
      String collage, String campus, String password) async {
    try {
      // signin
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create user.

      AppUser user = AppUser(
          uid: userCredential.user!.uid,
          email: email,
          name: name,
          collage: collage,
          campus: campus);

// store user data  on fire store.
      await firebaseFirestore.collection("users").doc(user.uid)
        .set(user.toJson());
      //return user

      return user;
    } catch (e) {
      throw Exception('Account creating Failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurretnUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    // if null user
    if (firebaseUser == null) {
      return null;
    }

    // if user doc have
    DocumentSnapshot userDoc = await firebaseFirestore
        .collection("users")
        .doc(firebaseUser.uid)
        .get();

    if (!userDoc.exists) {
      return null;
    }
    return AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        name: userDoc['name'],
        collage: userDoc['collage'],
        campus: userDoc['campus']);
  }
}



// class FirebaseAuthRepo implements AuthRepo {
//   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

//   @override
//   Future<AppUser?> loginWithEmailPassword(String email, String password) async {
//     try {
//       // Sign in the user
//       UserCredential userCredential = await firebaseAuth
//           .signInWithEmailAndPassword(email: email, password: password);

//       // Fetch the user's Firestore document
//       DocumentSnapshot userDoc = await firebaseFirestore
//           .collection('users')
//           .doc(userCredential.user!.uid)
//           .get();

//       // Create an `AppUser` object from the retrieved document
//       AppUser user = AppUser(
//         uid: userCredential.user!.uid,
//         email: email,
//         name: userDoc['name'],
//         collage: userDoc['collage'],
//         campus: userDoc['campus'],
//       );

//       return user;
//     } catch (e) {
//       throw Exception('Login Failed: $e');
//     }
//   }

//   @override
//   Future<AppUser?> registerWithEmailPassword(
//       String name, String email, String collage, String campus, String password) async {
//     try {
//       // Create a new user
//       UserCredential userCredential =
//           await firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Create an `AppUser` object
//       AppUser user = AppUser(
//         uid: userCredential.user!.uid,
//         email: email,
//         name: name,
//         collage: collage,
//         campus: campus,
//       );

//       // Store user data in Firestore
//       await firebaseFirestore
//           .collection("users")
//           .doc(user.uid)
//           .set(user.toJson());

//       return user;
//     } catch (e) {
//       throw Exception('Account Creation Failed: $e');
//     }
//   }

//   @override
//   Future<void> logout() async {
//     try {
//       await firebaseAuth.signOut();
//     } catch (e) {
//       throw Exception('Logout Failed: $e');
//     }
//   }

//   @override
//   Future<AppUser?> getCurretnUser() async {
//     try {
//       final firebaseUser = firebaseAuth.currentUser;

//       // Check if the user is logged in
//       if (firebaseUser == null) {
//         return null;
//       }

//       // Retrieve user data from Firestore
//       DocumentSnapshot userDoc = await firebaseFirestore
//           .collection("users")
//           .doc(firebaseUser.uid)
//           .get();

//       if (!userDoc.exists) {
//         return null;
//       }

//       // Return an `AppUser` object
//       return AppUser(
//         uid: firebaseUser.uid,
//         email: firebaseUser.email!,
//         name: userDoc['name'],
//         collage: userDoc['collage'],
//         campus: userDoc['campus'],
//       );
//     } catch (e) {
//       throw Exception('Error Fetching Current User: $e');
//     }
//   }
// }
