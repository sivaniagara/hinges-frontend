import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn;

  FirebaseAuthDataSource({required this.googleSignIn});

  Future<UserCredential> registerEmailIdAndPasswordInFirebaseAuth({
    required String userName,
    required String phoneNumber,
    required String emailId,
    required String password,
  }) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: emailId,
      password: password,
    );
    if (userCredential.user != null) {
      await userCredential.user!.updateDisplayName(userName);
      await userCredential.user!.sendEmailVerification();
    }
    return userCredential;
  }

  Future<void> forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google Sign In cancelled by user');

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Clear any stale Facebook session before starting a fresh login flow.
    await FacebookAuth.instance.logOut();
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: const ['email', 'public_profile'],
    );

    if (result.status == LoginStatus.success) {
      final OAuthCredential credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );
      return await _auth.signInWithCredential(credential);
    } else if (result.status == LoginStatus.cancelled) {
      throw Exception('Facebook sign in was cancelled by user');
    } else {
      throw Exception(
        'Facebook sign in failed: ${result.message ?? result.status.name}',
      );
    }
  }

  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }
}
