import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/long_button.dart';
import '../../../../core/utils/dialog_box_and_bottom_sheet_utils.dart';
import '../bloc/user_auth_bloc.dart';

class EmailVerificationScreen extends StatelessWidget {
  final String email;
  const EmailVerificationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40), // space for the overlapping icon
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, -6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                    'Email Verification Sent!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.primary)
                ),
                const SizedBox(height: 8),
                Text(
                  'A verification email has been sent to $email',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style:  Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white70),
                    children: [
                      const TextSpan(text: "Haven't received the verification mail? "),
                      TextSpan(
                        text: "Resend it.",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.read<UserAuthBloc>().add(ResendEmailVerification());
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Verification email resent!')),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BlocListener<UserAuthBloc, UserAuthState>(
                  listener: (context, state) {
                    if(state is AuthLoading && state.loading == 'verification'){
                      showLoadingDialog(context);
                    }else if(state is EmailAuthenticated && state.isEmailVerified) {
                      context.pop();
                    }else if(state is EmailAuthenticated && !state.isEmailVerified){
                      context.pop();
                      showMessageDialog(
                          context: context,
                          icon: Icon(Icons.error_outline, color: Colors.red),
                          title: 'Error on Verification',
                          message: 'Please verify the mail that sent to your EmailId.'
                      );
                    }
                  },
                  child: LongButton(
                    title: 'Yes I Verified',
                    onPressed: () {
                      context.read<UserAuthBloc>().add(RefreshUser());
                    },
                    outlined: false,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              padding: EdgeInsets.all(15),
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(Icons.mail, color: Theme.of(context).colorScheme.onPrimary, size: 40,),
            ),
          ),
        ],
      ),
    );
  }
}
