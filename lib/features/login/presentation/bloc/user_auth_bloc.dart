import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecase/forgot_password_usecase.dart';
import '../../domain/usecase/sign_up_usecase.dart';
part 'user_auth_event.dart';
part 'user_auth_state.dart';



class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState>{
  final SignUpUseCase signUpUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserAuthBloc({
    required this.signUpUseCase,
    required this.forgotPasswordUseCase,
  }) : super(AuthInitial()){
    on<AppStarted>((event, emit) async {
      final user = _auth.currentUser;
      if (user != null) {
        if(user.emailVerified){
          emit(EmailAuthenticated(user: user, isEmailVerified: user.emailVerified));
        } else {
          emit(EmailSignInState());
        }
      } else {
        emit(EmailSignInState());
      }
    });

    on<EmailSignInPage>((event, emit){
      emit(EmailSignInState());
    });

    on<SignUpPage>((event, emit){
      emit(SignUpState());
    });

    on<UpdatePasswordVisibilityForEmailSignIn>((event, emit){
      final currentState = state as EmailSignInState;
      emit(EmailSignInState(showPassword: !currentState.showPassword, rememberMe: currentState.rememberMe));
    });

    on<UpdateRememberMe>((event, emit) async {
      final currentState = state as EmailSignInState;
      emit(EmailSignInState(rememberMe: !currentState.rememberMe, showPassword: currentState.showPassword));
    });

    on<UpdatePasswordVisibilityForEmailSignOut>((event, emit){
      final currentState = state as SignUpState;
      emit(
          SignUpState(showPassword: !currentState.showPassword)
      );
    });

    on<UpdateConfirmPasswordVisibilityForEmailSignOut>((event, emit){
      final currentState = state as SignUpState;
      emit(
          SignUpState(showConfirmPassword: !currentState.showConfirmPassword)
      );
    });

    on<UpdateAgreeTermsAndCondition>((event, emit){
      final currentState = state as SignUpState;
      emit(
          SignUpState(agreeTermsAndCondition: !currentState.agreeTermsAndCondition)
      );
    });

    on<SignInRequested>((event, emit) async {
      emit(AuthLoading(loading: 'signIn'));
      try {
        final cred = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        await cred.user!.reload();
        final user = _auth.currentUser!;

        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }

        emit(EmailAuthenticated(
          user: user,
          isEmailVerified: user.emailVerified,
        ));
      } catch (e) {
        emit(EmailAuthError(e.toString()));
      }
    });
    
    on<ForgotPasswordRequested>((event, emit) async {
      emit(AuthLoading(loading: 'forgotPassword'));
      final result = await forgotPasswordUseCase(event.email);
      result.fold(
        (failure) => emit(EmailAuthError(failure.message)),
        (_) => emit(ForgotPasswordSuccess()),
      );
    });


    on<SignUpRequested>((event, emit) async {
      final currentState = state;
      if (currentState is! SignUpState) return;

      emit(currentState.copyWith(status: SignUpStatus.loading));

      try {
        final signUpParams = SignUpParams(
          userName: event.userName,
          phoneNumber: event.phoneNumber,
          emailId: event.emailId,
          password: event.password,
          agreeTermsAndCondition: event.agreeTermsAndCondition,
        );

        final result = await signUpUseCase(signUpParams);

        await result.fold(
              (failure) async {
            emit(currentState.copyWith(
              status: SignUpStatus.error,
              message: failure.message.contains('email-already-in-use')
                  ? "This email is already registered."
                  : failure.message,
            ));
          },
              (userCredential) async {
            final user = userCredential.user;
            if (user != null) {
              try {
                emit(currentState.copyWith(
                  status: SignUpStatus.success,
                  message: "Account Created Successfully! Verification email sent.",
                ));
              } on FirebaseAuthException catch (e) {
                if (e.code == 'too-many-requests') {
                  emit(currentState.copyWith(
                    status: SignUpStatus.error,
                    message:
                    "Too many verification requests. Please wait a few minutes before trying again.",
                  ));
                } else {
                  emit(currentState.copyWith(
                    status: SignUpStatus.error,
                    message: e.message ?? "Error sending verification email.",
                  ));
                }
              }
            }
          },
        );
      } catch (e) {
        emit(currentState.copyWith(
          status: SignUpStatus.error,
          message: "Unexpected error occurred during sign up.",
        ));
      }
    });

    on<SignOutRequested>((_, emit) async {
      await _auth.signOut();
      emit(EmailUnauthenticated());
      emit(EmailSignInState());
    });

    on<ResendEmailVerification>((_, emit) async {
      await _auth.currentUser?.sendEmailVerification();
      emit(EmailAuthenticated(user: _auth.currentUser!, isEmailVerified: _auth.currentUser!.emailVerified));
    });

    on<RefreshUser>((_, emit) async {
      emit(AuthLoading(loading: 'verification'));
      await _auth.currentUser?.reload();
      emit(EmailAuthenticated(user: _auth.currentUser!, isEmailVerified: _auth.currentUser!.emailVerified));
    });
  }
}