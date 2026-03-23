import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthDataSource{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn;

  FirebaseAuthDataSource({required this.googleSignIn});

  Future<UserCredential> registerEmailIdAndPasswordInFirebaseAuth({
        required String userName,
        required String phoneNumber,
        required String emailId,
        required  String password,
      })async{
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: emailId,
      password: password,
    );
    if(userCredential.user != null){
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

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }
}
