part of 'user_auth_bloc.dart';

abstract class UserAuthState extends Equatable{}

class AuthInitial extends UserAuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EmailSignInState extends UserAuthState {
  final bool showPassword;
  final bool rememberMe;
  EmailSignInState({
    this.showPassword = false,
    this.rememberMe = false,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

enum SignUpStatus { initial, loading, success, error }
class SignUpState extends UserAuthState {
  bool showPassword;
  bool showConfirmPassword;
  bool agreeTermsAndCondition;
  SignUpStatus status;
  String message;
  SignUpState({
    this.showPassword = false,
    this.showConfirmPassword = false,
    this.agreeTermsAndCondition = false,
    this.status = SignUpStatus.initial,
    this.message = '',
  });

  @override
  // TODO: implement props
  List<Object?> get props => [showPassword, showConfirmPassword, agreeTermsAndCondition, status, message];

  SignUpState copyWith({
    bool? showPassword,
    bool? showConfirmPassword,
    bool? agreeTermsAndCondition,
    SignUpStatus? status,
    String? message,
  }) {
    return SignUpState(
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      agreeTermsAndCondition: agreeTermsAndCondition ?? this.agreeTermsAndCondition,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

}

class AuthLoading extends UserAuthState {
  final String loading;
  AuthLoading({required this.loading});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EmailAuthenticated extends UserAuthState {
  final User user;
  final bool isEmailVerified;
  EmailAuthenticated({required this.user, required this.isEmailVerified});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class EmailUnauthenticated extends UserAuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EmailAuthError extends UserAuthState {
  final String message;
  EmailAuthError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

