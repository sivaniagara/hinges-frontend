part of 'user_auth_bloc.dart';

abstract class UserAuthState extends Equatable{}

class AuthInitial extends UserAuthState {
  @override
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
  List<Object?> get props => [showPassword, rememberMe];
}

enum SignUpStatus { initial, loading, success, error }
class SignUpState extends UserAuthState {
  final bool showPassword;
  final bool showConfirmPassword;
  final bool agreeTermsAndCondition;
  final SignUpStatus status;
  final String message;
  SignUpState({
    this.showPassword = false,
    this.showConfirmPassword = false,
    this.agreeTermsAndCondition = false,
    this.status = SignUpStatus.initial,
    this.message = '',
  });

  @override
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
  List<Object?> get props => [loading];
}

class ForgotPasswordSuccess extends UserAuthState {
  @override
  List<Object?> get props => [];
}

abstract class AuthenticatedState extends UserAuthState {
  final User user;
  AuthenticatedState({required this.user});
  
  @override
  List<Object?> get props => [user];
}

class EmailAuthenticated extends AuthenticatedState {
  final bool isEmailVerified;
  EmailAuthenticated({required super.user, required this.isEmailVerified});

  @override
  List<Object?> get props => [user, isEmailVerified];
}

class GoogleAuthenticated extends AuthenticatedState {
  GoogleAuthenticated({required super.user});
}

class GuestAuthenticated extends AuthenticatedState {
  GuestAuthenticated({required super.user});
}

class EmailUnauthenticated extends UserAuthState {
  @override
  List<Object?> get props => [];
}

class EmailAuthError extends UserAuthState {
  final String message;
  EmailAuthError(this.message);

  @override
  List<Object?> get props => [message];
}
