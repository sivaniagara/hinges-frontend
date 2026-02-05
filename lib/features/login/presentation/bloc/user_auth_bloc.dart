import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecase/sign_up_usecase.dart';
part 'user_auth_event.dart';
part 'user_auth_state.dart';



class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState>{
  final SignUpUseCase signUpUseCase;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserAuthBloc({required this.signUpUseCase}) : super(AuthInitial()){
    on<AppStarted>((event, emit){
      print('app started function called..............');
      final user = _auth.currentUser;
      print("user => ${user}");
      if (user != null) {
        print("user uuid ==> ${user.uid}");
        if(user.emailVerified){
          print("email is verified...");
          emit(EmailAuthenticated(user: user, isEmailVerified: user.emailVerified));
        }else {
          print("email is not verified verified...");
          emit(EmailSignInState());
        }
      } else {
        print('emit to EmailSignInState');
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
      emit(EmailSignInState(showPassword: !currentState.showPassword));
    });

    on<UpdateRememberMe>((event, emit){
      final currentState = state as EmailSignInState;
      emit(EmailSignInState(rememberMe: !currentState.rememberMe));
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

        // Reload to get latest emailVerified status
        await cred.user!.reload();
        final user = _auth.currentUser!;

        // Send verification email if not verified
        if (!user.emailVerified) {
          print('send verification mail when sign in page...');
          await user.sendEmailVerification();
        }

        emit(EmailAuthenticated(
          user: user,
          isEmailVerified: user.emailVerified,
        ));
      } catch (e) {
        print(e.toString());
        emit(EmailAuthError(e.toString()));
        // emit(EmailUnauthenticated());
      }
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
                // Transition to authenticated state
                // emit(EmailAuthenticated(
                //   user: user,
                //   isEmailVerified: user.emailVerified,
                // ));
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