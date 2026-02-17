import 'package:firebase_auth/firebase_auth.dart';
import 'package:hinges_frontend/features/login/utils/login_urls.dart';

import '../../../../core/network/http_service.dart';

class FirebaseAuthDataSource{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuthDataSource();

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
}