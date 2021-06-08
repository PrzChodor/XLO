import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import 'package:xlo_auction_app/widgets/notification.dart';

class AuthenticationService {
  final FirebaseAuth _authenticator = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var uuid = Uuid();

  // singleton
  static final AuthenticationService _authenticationService =
      AuthenticationService._internal();
  factory AuthenticationService() => _authenticationService;

  AuthenticationService._internal();

  Stream<User> get authStateChanges => _authenticator.authStateChanges();
  bool get isEmailVerified => _authenticator.currentUser.emailVerified;

  Future<void> createUserWithEmail(BuildContext context, String email,
      String password, String username, File imageFile) async {
    await _authenticator.createUserWithEmailAndPassword(
        email: email, password: password);

    _authenticator.currentUser?.updateDisplayName(username);

    if (imageFile != null) {
      final loggedUser = getCurrentUserId();
      final taskSnapshot = await _storage
          .ref('$loggedUser/profile_photo')
          .putFile(imageFile)
          .catchError((error, stackTrace) {
        showNotification(context, 'Error', "Failed to upload image!\n$error");
      });
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      await _authenticator.currentUser?.updatePhotoURL(imageUrl);
    }

    Navigator.pop(context);
    if (!_authenticator.currentUser.emailVerified) {
      _authenticator.currentUser.sendEmailVerification();
      showNotification(
          context, 'Verify email', 'Verification link sent to email');
    }
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

  Future<bool> signInWithGoogle({@required BuildContext context}) async {
    var isSignedIn = false;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _authenticator.signInWithCredential(credential);
    }

    if (_authenticator.currentUser != null) {
      isSignedIn = true;
    }

    return isSignedIn;
  }

  Future<bool> signInWithFacebook({@required BuildContext context}) async {
    var isSignedIn = false;
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.accessToken != null) {
      final facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken.token);

      await _authenticator.signInWithCredential(facebookAuthCredential);
    }
    if (_authenticator.currentUser != null) {
      isSignedIn = true;
    }

    if (isSignedIn && !_authenticator.currentUser.emailVerified) {
      _authenticator.currentUser.sendEmailVerification();
    }

    return isSignedIn;
  }

  Future<void> signOut() async {
    await _authenticator.signOut();
  }

  String getCurrentUserId() {
    return _authenticator.currentUser.uid;
  }

  String getCurrentUsername() {
    return _authenticator.currentUser.displayName;
  }

  String getCurrentUserPhoto() {
    return _authenticator.currentUser.photoURL;
  }

  String getCurrentUserEmail() {
    return _authenticator.currentUser.email;
  }

  Future<String> getUserPhoto(String uid) async {
    try {
      return await _storage.ref('$uid/profile_photo').getDownloadURL();
    } catch (_) {
      return '';
    }
  }

  Future<AuthCredential> getCredentialForCurrentUser(String password) async {
    final user = _authenticator.currentUser;
    return EmailAuthProvider.credential(email: user.email, password: password);
  }

  Future<void> reauthenticateWithRefreshedCredentials(
      AuthCredential credential) async {
    final user = _authenticator.currentUser;
    await user.reauthenticateWithCredential(credential);
  }

  Future<void> signOutFacebookAndGoogle() async {
    if (_authenticator.currentUser.providerData[0].providerId == 'google.com' ||
        _authenticator.currentUser.providerData[0].providerId ==
            'facebook.com') {
      GoogleSignIn().signOut();
      FacebookAuth.instance.logOut();
    }
  }

  bool isCurrentProviderByEmail() {
    final user = _authenticator.currentUser;
    if (user.providerData[0].providerId == 'password') {
      return true;
    }
    return false;
  }

  Future<void> deleteUser() async {
    await _authenticator.currentUser.delete();
  }
}
