import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static const List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: scopes);
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception("Google Sign-In dibatalkan oleh pengguna.");
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        throw Exception("Google Authentication gagal: Token tidak ditemukan.");
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) throw Exception("User Google null");
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          id: firebaseUser.uid,
          firstName: firebaseUser.displayName?.split(' ').first,
          lastName: firebaseUser.displayName?.split(' ').skip(1).join(' '),
          imageUrl: "https://i.pravatar.cc/300?u=${firebaseUser.email}",
          metadata: {
            'email': firebaseUser.email,
          },
        ),
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException: ${e.message}");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("FirebaseAuthException: ${e.message}")),
      );
      return null;
    } on PlatformException catch (e) {
      debugPrint("PlatformException: ${e.message}");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PlatformException: ${e.message}")),
      );
      return null;
    } catch (e) {
      debugPrint("Error during Google Sign-In: $e");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during Google Sign-In: $e")),
      );
      return null;
    }
  }

  Future<void> register(
      String email, String password, String firstName, String lastName) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    debugPrint(
        "Registering with email: $email firtsname $firstName  lastname $lastName");

    // await FirebaseChatCore.instance.createUserInFirestore(
    //   types.User(
    //     firstName: firstName,
    //     id: credential.user!.uid,
    //     imageUrl: 'https://i.pravatar.cc/300?u=$email',
    //     lastName: lastName,
    //   ),
    // );
    await FirebaseChatCore.instance.createUserInFirestore(
      types.User(
        id: credential.user!.uid,
        firstName: firstName,
        lastName: lastName,
        imageUrl: "https://i.pravatar.cc/300?u=$email",
        metadata: {
          'email': email,
        },
      ),
    );
  }

  User? get currentUser => _auth.currentUser;

  Future<void> logout() async => await _auth.signOut();
}
