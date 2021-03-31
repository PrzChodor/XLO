import 'package:firebase_auth/firebase_auth.dart';


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

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      await _authenticator.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    }
    catch(e) {
      print(e.message);
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _authenticator.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    }
    catch(e) {
      print(e.message);
    }
  }

  Future<void> signOut() async {
    await _authenticator.signOut();
  }
}