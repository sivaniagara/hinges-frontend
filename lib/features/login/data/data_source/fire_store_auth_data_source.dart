import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreAuthDataSource{
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> registerUserDetailsInCloudFireStore({
    required String uidFromFirebaseAuth,
    required String userName,
    required String phoneNumber,
    required String emailId,
    required bool agreeTermsAndCondition
  })async{
    await FirebaseFirestore.instance.collection('users')
        .doc(uidFromFirebaseAuth)
        .set({
      'userName' : userName,
      'phoneNumber' : phoneNumber,
      'emailId' : emailId,
      'agreeTermsAndCondition' : agreeTermsAndCondition
    });

  }
}