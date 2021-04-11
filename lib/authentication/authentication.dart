import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationService {
  final FirebaseAuth _authenticator;

  AuthenticationService(this._authenticator);

  Stream<User> get authStateChanges => _authenticator.authStateChanges();

  // Future signInAnonymous() async {
  //   try {
  //    UserCredential result = await _authenticator.signInAnonymously();
  //    User user = result.user;
  //    return user;
  //   }
  //   catch(e) {
  //     return e.message;
  //   }
  // }

  Future<void> createUserWithEmail(
      BuildContext context, String email, String password) async {
    await _authenticator.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<bool> signInWithEmail(
      BuildContext context, String email, String password) async {
    var isSignedIn = false;
    await _authenticator.signInWithEmailAndPassword(
        email: email, password: password);

    if (_authenticator.currentUser != null) {
      isSignedIn = true;
    }
    return isSignedIn;
  }

  Future<void> signOut() async {
    await _authenticator.signOut();
  }
}
