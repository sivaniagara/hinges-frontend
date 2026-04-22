import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/core/utils/dialog_box_and_bottom_sheet_utils.dart';
import '../bloc/user_auth_bloc.dart';
import '../../../../core/presentation/widgets/long_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserAuthBloc, UserAuthState>(
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

        child: Stack(
          children: [

            /// 🌌 DARK BASE
            Container(
              color: const Color(0xFF020617),
            ),

            /// 🔲 GRID BACKGROUND
            CustomPaint(
              painter: GridPainter(),
              size: Size.infinite,
            ),

            /// 💡 NEON GLOW SPOTS
            Positioned(
              top: -100,
              left: -100,
              child: _glowCircle(300, Colors.blueAccent),
            ),
            Positioned(
              bottom: -120,
              right: -120,
              child: _glowCircle(300, Colors.purpleAccent),
            ),

            SafeArea(
              child: Center(
                child: Container(
                  width: 900,
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(.6),
                    // border: Border.all(color: Colors.white12),
                  ),

                  child: Row(
                    children: [

                      /// LEFT PANEL
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Build Your Dream Team",
                                style: GoogleFonts.oxanium(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 20),

                              Text(
                                "Authenticate to continue into the bidding system.",
                                style: GoogleFonts.instrumentSans(
                                  color: Colors.white54,
                                ),
                              ),

                              const SizedBox(height: 40),

                              Image.asset(
                                AppImages.indianBiddingLeague,
                                height: 80,
                              )
                            ],
                          ),
                        ),
                      ),

                      /// DIVIDER
                      Container(
                        width: 1,
                        color: Colors.white10,
                      ),

                      /// RIGHT PANEL (LOGIN)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              _neonCard(
                                child: Column(
                                  children: [

                                    LongButton(
                                      title: 'Google Login',
                                      prefixIcon: FontAwesomeIcons.google,
                                      onPressed: () {
                                        context.read<UserAuthBloc>().add(
                                            GoogleSignInRequested());
                                      },
                                      outlined: true,
                                    ),
                                    const SizedBox(height: 15),
                                    LongButton(
                                      title: 'Facebook Login',
                                      prefixIcon: FontAwesomeIcons.facebook,
                                      onPressed: () {
                                        context.read<UserAuthBloc>().add(
                                            FacebookSignInRequested());
                                      },
                                      outlined: true,
                                    ),
                                    const SizedBox(height: 15),
                                    LongButton(
                                      title: 'Guest Login',
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
                              ),

                              const SizedBox(height: 20),

                              Text(
                                "By logging in, you agree to our Terms & Conditions",
                                style: GoogleFonts.instrumentSans(
                                  color: Colors.white38,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fade().scale(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔵 GLOW CIRCLE
  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  /// 🔷 NEON CARD
  Widget _neonCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.cyanAccent.withOpacity(.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(.2),
            blurRadius: 20,
          )
        ],
      ),
      child: child,
    );
  }
}

/// 🔲 GRID BACKGROUND
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
