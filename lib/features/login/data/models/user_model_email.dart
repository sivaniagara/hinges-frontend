import 'package:firebase_auth/firebase_auth.dart';

class UserModelEmail {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool emailVerified;

  UserModelEmail({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.emailVerified,
  });

  factory UserModelEmail.fromFirebase(User user) {
    return UserModelEmail(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
    };
  }

  factory UserModelEmail.fromMap(Map<String, dynamic> map) {
    return UserModelEmail(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      emailVerified: map['emailVerified'],
    );
  }
}
