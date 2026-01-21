import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> registerEmailIdAndPasswordInFirebaseAuth(String emailId, String password)async{
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: emailId,
      password: password,
    );
    print("cred.additionalUserInfo : ${userCredential.additionalUserInfo}");
    print("cred.credential : ${userCredential.credential}");
    print("cred.user : ${userCredential.user}");
    if(userCredential.user != null){
      await userCredential.user!.sendEmailVerification();
    }
    return userCredential;
  }
}