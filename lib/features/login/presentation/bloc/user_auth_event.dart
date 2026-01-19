part of 'user_auth_bloc.dart';

abstract class UserAuthEvent {}

class AppStarted extends UserAuthEvent {}

class EmailSignInPage extends UserAuthEvent {}

class SignUpPage extends UserAuthEvent {}

class UpdatePasswordVisibilityForEmailSignIn extends UserAuthEvent {}

class UpdateRememberMe extends UserAuthEvent {}

class UpdatePasswordVisibilityForEmailSignOut extends UserAuthEvent {}

class UpdateConfirmPasswordVisibilityForEmailSignOut extends UserAuthEvent {}

class UpdateAgreeTermsAndCondition extends UserAuthEvent {}

class SignInRequested extends UserAuthEvent {
  final String email, password;
  SignInRequested(this.email, this.password);
}

class SignUpRequested extends UserAuthEvent {
  final String emailId, password, phoneNumber, userName;
  final bool agreeTermsAndCondition;
  SignUpRequested({
    required this.userName,
    required this.emailId,
    required this.password,
    required this.phoneNumber,
    required this.agreeTermsAndCondition,
  });
}

class SignOutRequested extends UserAuthEvent {}

class ResendEmailVerification extends UserAuthEvent {}

class RefreshUser extends UserAuthEvent {
  RefreshUser();
}