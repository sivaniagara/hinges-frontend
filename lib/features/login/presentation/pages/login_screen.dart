import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/presentation/widgets/gradient_text.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/core/utils/dialog_box_and_bottom_sheet_utils.dart';
import '../bloc/user_auth_bloc.dart';
import '../../../../core/presentation/widgets/long_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Color> textColorForYellowTag = [
      const Color(0xff330000),
      const Color(0xffFF1D2B)
    ];

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
            debugPrint("state.message => ${state.message}");
            context.pop();
            showMessageDialog(
              context: context,
              icon: const Icon(Icons.error_outline, color: Colors.red),
              title: 'Error',
              message: state.message,
            );
          }

        },

        child: Container(
          width: double.infinity,
          height: double.infinity,

          decoration: const BoxDecoration(
            gradient: RadialGradient(
              radius: 1.2,
              colors: [
                Color(0xFF5A0000),
                Color(0xFF1A0000),
                Color(0xFF000000),
              ],
            ),
          ),

          child: SafeArea(
            child: Row(
              children: [

                /// LEFT SIDE BRANDING
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        /// LOGO
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(.4),
                                blurRadius: 40,
                                spreadRadius: 10,
                              )
                            ],
                          ),
                          child: Image.asset(
                            AppImages.indianBiddingLeague,
                            height: 180,
                          ),
                        )
                            .animate()
                            .fade(duration: 700.ms)
                            .scale(begin: const Offset(.8,.8))
                            .shimmer(delay: 700.ms, duration: 1500.ms),

                        const SizedBox(height: 20),

                        Text(
                          'THE ULTIMATE AUCTION EXPERIENCE',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.oxanium(
                            color: Colors.amber.shade300,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),
                        )
                            .animate()
                            .fade(delay: 500.ms)
                            .slideY(begin: .3),

                      ],
                    ),
                  ),
                ),

                /// DIVIDER
                Container(
                  width: 2,
                  margin: const EdgeInsets.symmetric(vertical: 60),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.amber.withOpacity(.7),
                        Colors.transparent
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fade(duration: 700.ms),

                /// RIGHT SIDE LOGIN
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Container(

                      padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 40
                      ),

                      width: 420,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.black.withOpacity(.45),

                        border: Border.all(
                          color: Colors.amber.withOpacity(.4),
                          width: 1.5,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.8),
                            blurRadius: 30,
                          )
                        ],
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          /// LOGIN TAG
                          Container(
                            width: 220,
                            padding: const EdgeInsets.symmetric(vertical: 10),

                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(AppImages.yellowTag),
                                fit: BoxFit.fill,
                              ),
                            ),

                            child: Center(
                              child: GradientText(
                                title: 'CHOOSE LOGIN',
                                colors: textColorForYellowTag,
                                fontSize: 20,
                              ),
                            ),
                          )
                              .animate()
                              .fade()
                              .slideY(begin: -.4),

                          const SizedBox(height: 30),

                          /// GOOGLE
                          LongButton(
                            title: 'Sign in With Google',
                            prefixIcon: FontAwesomeIcons.google,
                            onPressed: () {
                              context.read<UserAuthBloc>().add(
                                  GoogleSignInRequested());
                            },
                            outlined: true,
                          )
                              .animate(delay: 200.ms)
                              .fade()
                              .slideX(begin: .3),

                          const SizedBox(height: 15),

                          /// FACEBOOK
                          LongButton(
                            title: 'Sign in With Facebook',
                            prefixIcon: FontAwesomeIcons.facebook,
                            onPressed: () {
                              context.read<UserAuthBloc>().add(
                                  FacebookSignInRequested());
                            },
                            outlined: true,
                          )
                              .animate(delay: 350.ms)
                              .fade()
                              .slideX(begin: .3),

                          const SizedBox(height: 15),

                          /// GUEST
                          LongButton(
                            title: 'Sign in as Guest',
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
                          )
                              .animate(delay: 500.ms)
                              .fade()
                              .slideX(begin: .3),

                          const SizedBox(height: 20),

                          Text(
                            'By logging in, you agree to our Terms & Conditions',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.instrumentSans(
                              color: Colors.white38,
                              fontSize: 10,
                            ),
                          )
                              .animate(delay: 700.ms)
                              .fade(),

                        ],
                      ),
                    )
                        .animate()
                        .fade(duration: 600.ms)
                        .slideX(begin: .4),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
