import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/core/utils/dialog_box_and_bottom_sheet_utils.dart';
import 'package:hinges_frontend/features/login/presentation/widgets/terms_text.dart';
import '../bloc/user_auth_bloc.dart';
import '../../../../core/presentation/widgets/long_button.dart';
import '../widgets/mandala_background.dart';
import '../widgets/shared_decorations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserAuthBloc, UserAuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          if (state.loading == 'google-signIn') {
            showLoadingDialog(context, message: "Connecting Google...");
          } else if (state.loading == 'facebook-signIn') {
            showLoadingDialog(context, message: "Connecting Facebook...");
          } else if (state.loading == 'guest-signIn') {
            showLoadingDialog(context, message: "Logging in as Guest...");
          }
        }
        else if (state is GoogleAuthenticated || state is FacebookAuthenticated || state is GuestAuthenticated) {
          context.pop();
          context.go('/loading');
        }
        else if (state is EmailAuthError) {
          context.pop();
          showMessageDialog(
            context: context,
            icon: const Icon(Icons.error_outline, color: Colors.red),
            title: 'Error',
            message: state.message,
          );
        }
      },
      child: Scaffold(
        body: MandalaBackground(
          animateContent: false,
          child: Stack(
            children: [
              const GoldenRingBackground(),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      AppImages.indianBiddingLeague,
                      height: 100,
                    ),
                    const GoldenTitle(
                      title: 'INDIAN BIDDING LEAGUE',
                      fontSize: 32,
                    ),
                    Column(
                      spacing: 8,
                      children: [
                        LongButton(
                          title: 'Login with Google',
                          prefixIcon: FontAwesomeIcons.google,
                          onPressed: () {
                            context.read<UserAuthBloc>().add(
                                GoogleSignInRequested());
                          },
                          outlined: true,
                        ),
                        LongButton(
                          title: 'Login with Facebook',
                          prefixIcon: FontAwesomeIcons.facebook,
                          onPressed: () {
                            context.read<UserAuthBloc>().add(
                                FacebookSignInRequested());
                          },
                          outlined: true,
                        ),
                        LongButton(
                          title: 'Login as Guest',
                          prefixIcon: Icons.person_outline,
                          onPressed: () {
                            showGuestNameBottomSheet(
                              context,
                              onContinue: (name) {
                                context.read<UserAuthBloc>().add(
                                    GuestSignInRequested(name));
                              },
                            );
                          },
                          outlined: true,
                        ),
                      ],
                    ),
                    TermsText()
                  ],
                ),
              ),
              const MandalaDecoration(alignment: Alignment.bottomLeft),
              const MandalaDecoration(
                alignment: Alignment.bottomRight,
                rotateY: math.pi,
              ),
              const MandalaDecoration(
                alignment: Alignment.topLeft,
                rotateX: math.pi,
              ),
              const MandalaDecoration(
                alignment: Alignment.topRight,
                rotateX: math.pi,
                rotateY: math.pi,
              ),
            ],
          ),
        ),
      ),
    );
  }
}