// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<bool> signInWithGoogle() async {
//     bool result = false;
//     try {
//       final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
//       final GoogleSignInAuthentication gAuth = await gUser!.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: gAuth.accessToken,
//         idToken: gAuth.idToken,
//       );
//       UserCredential userCredential =
//           await _auth.signInWithCredential(credential);
//       User? user = userCredential.user;

//       if (user != null) {
//         if (userCredential.additionalUserInfo!.isNewUser) {
//           await _firestore.collection('users').doc(user.uid).set({
//             'username' : user.displayName,
//             'uid' : user.uid,
//             'profilePhoto' : user.photoURL,
//             'email' : user.email,
//           });
//         }
//         result = true;
//       }
//       return result;
//     } catch (e) {}
//     return result;
//   }
// }

