import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/usecase/forgot_password_usecase.dart';
import '../../domain/usecase/google_sign_in_usecase.dart';
import '../../domain/usecase/guest_sign_in_usecase.dart';
import '../../domain/usecase/register_guest_user.dart';
import '../../domain/usecase/sign_up_usecase.dart';
import '../../domain/usecase/update_user_details_usecase.dart';
import '../../../../core/usecase/usecase.dart';

part 'user_auth_event.dart';
part 'user_auth_state.dart';



class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState>{
  final SignUpUseCase signUpUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final UpdateUserDetailsUseCase updateUserDetailsUseCase;
  final GuestSignInUseCase guestSignInUseCase;
  final RegisterGuestUserUseCase registerGuestUserUseCase;
  final GoogleSignIn googleSignIn;
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserAuthBloc({
    required this.googleSignIn,
    required this.signUpUseCase,
    required this.forgotPasswordUseCase,
    required this.googleSignInUseCase,
    required this.updateUserDetailsUseCase,
    required this.guestSignInUseCase,
    required this.registerGuestUserUseCase,
  }) : super(AuthInitial()){
    on<AppStarted>((event, emit) async {
      final user = _auth.currentUser;
      if (user != null) {
        if (user.providerData.any((p) => p.providerId == 'google.com')) {
          emit(GoogleAuthenticated(user: user));
        } else if (user.isAnonymous) {
          emit(GuestAuthenticated(user: user));
        } else if (user.emailVerified) {
          emit(EmailAuthenticated(user: user, isEmailVerified: true));
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

    on<GoogleSignInRequested>((event, emit) async {
      emit(AuthLoading(loading: 'google-signIn'));

      try {
        // No signOut() here anymore — trust the logout flow did disconnect()
        final result = await googleSignInUseCase(NoParams());

        if (result.isLeft()) {
          final failure = result.swap().getOrElse(() => throw Exception('No failure'));
          emit(EmailAuthError(failure.message));
          return;
        }

        final userCredential = result.getOrElse(() => throw Exception('No credential'));
        final user = userCredential.user;

        if (user == null) {
          emit(EmailAuthError("Google sign-in failed – no user"));
          return;
        }

        // Your update logic looks fine
        final updateResult = await updateUserDetailsUseCase(
          UpdateUserDetailsParams(
            userId: user.uid,
            userName: user.displayName ?? "User",
            userEmailId: user.email ?? "",
            userMobileNumber: user.phoneNumber ?? "",
            authProvider: 2,
            profilePath: user.photoURL ?? "",
            createdAt: DateTime.now(),
          ),
        );

        if (updateResult.isLeft()) {
          final failure = updateResult.swap().getOrElse(() => throw Exception('No failure'));
          emit(EmailAuthError(failure.message));
          return;
        }

        emit(GoogleAuthenticated(user: user));
      } catch (e, stack) {
        debugPrint("Google sign-in error: $e\n$stack");
        emit(EmailAuthError("Sign-in failed: ${e.toString()}"));
      }
    });
    on<SignOutRequested>((event, emit) async {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          final isGoogle = user.providerData.any((info) => info.providerId == 'google.com');

          if (isGoogle) {
            try {
              // This is the key line most people miss or put in the wrong place
              await googleSignIn.disconnect();   // Revokes app access → forces picker next time
            } catch (e) {
              debugPrint("Google disconnect failed (often harmless): $e");
            }
            await googleSignIn.signOut();       // Clears current session
          }

          await _auth.signOut();
        }
        emit(EmailUnauthenticated());
      } catch (e) {
        debugPrint("Sign out error: $e");
      }
    });

    on<GuestSignInRequested>((event, emit) async {
      emit(AuthLoading(loading: 'guest-signIn'));
      final result = await guestSignInUseCase(NoParams());
      await result.fold(
        (failure) async => emit(EmailAuthError(failure.message)),
        (userCredential) async {
          final user = userCredential.user;
          if (user != null) {
            final updateResult = await registerGuestUserUseCase(RegisterGuestUserParams(
              userId: user.uid,
              userName: event.userName,
            ));

            await updateResult.fold(
              (failure) async => emit(EmailAuthError(failure.message)),
              (_) async => emit(GuestAuthenticated(user: user)),
            );
          }
        },
      );
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
