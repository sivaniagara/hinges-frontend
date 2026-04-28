import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import 'package:hinges_frontend/core/utils/dialog_box_and_bottom_sheet_utils.dart';
import '../bloc/user_auth_bloc.dart';
import '../../../../core/presentation/widgets/long_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _bgController;
  late AnimationController _particlesController;

  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<double> _bgAnimation;

  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    _initializeParticles();

    /// Main Animation
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fade = CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeIn,
    );

    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOutBack),
    );

    /// Background Glow Animation
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _bgAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeInOut),
    );

    /// Particle Animation
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _mainController.forward();
  }

  void _initializeParticles() {
    final random = math.Random();
    for (int i = 0; i < 500; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 3 + 1.5,
          speedX: (random.nextDouble() - 0.5) * 0.002,
          speedY: (random.nextDouble() - 0.5) * 0.002,
          opacity: random.nextDouble() * 0.6 + 0.3,
        ),
      );
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _bgController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

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
        body: AnimatedBuilder(
          animation: Listenable.merge([_bgAnimation, _particlesController]),
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF023FA8),
                    const Color(0xFF010218),
                  ],
                  radius: 0.8,
                  focal: Alignment.center,
                  focalRadius: 0.2,
                ),
              ),
              child: Stack(
                children: [
                  /// Center Glow
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.15),
                            blurRadius: 100,
                            spreadRadius: 50,
                          ),
                          BoxShadow(
                            color: const Color(0xFF60A5FA).withOpacity(0.08),
                            blurRadius: 150,
                            spreadRadius: 80,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Golden Particles
                  ..._buildParticleLayer(),

                  /// Main UI
                  Center(
                    child: FadeTransition(
                      opacity: _fade,
                      child: ScaleTransition(
                        scale: _scale,
                        child: Stack(
                          children: [
                            /// Background Ring
                            Center(
                              child: Opacity(
                                opacity: 0.5,
                                child: Image.asset(
                                  AppImages.goldenRingStump,
                                  height: MediaQuery.of(context).size.height,
                                ),
                              ),
                            ),

                            /// Content Column
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// Logo
                                Image.asset(
                                  AppImages.indianBiddingLeague,
                                  height: 100,
                                ),
                                /// Login Buttons Card
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 30),
                                  padding: const EdgeInsets.all(25),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFFFFD700).withOpacity(0.3),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFFD700).withOpacity(0.1),
                                        blurRadius: 30,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
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

                              ],
                            ),

                            /// Mandala Decorations
                            buildMandala(alignment: Alignment.bottomLeft),
                            buildMandala(
                              alignment: Alignment.bottomRight,
                              rotateY: math.pi,
                            ),
                            buildMandala(
                              alignment: Alignment.topLeft,
                              rotateX: math.pi,
                            ),
                            buildMandala(
                              alignment: Alignment.topRight,
                              rotateX: math.pi,
                              rotateY: math.pi,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildParticleLayer() {
    return List.generate(_particles.length, (index) {
      final particle = _particles[index];

      particle.x += particle.speedX;
      particle.y += particle.speedY;

      if (particle.x < 0) particle.x = 1;
      if (particle.x > 1) particle.x = 0;
      if (particle.y < 0) particle.y = 1;
      if (particle.y > 1) particle.y = 0;

      final dx = particle.x - 0.5;
      final dy = particle.y - 0.5;
      final distanceFromCenter = math.sqrt(dx * dx + dy * dy);

      if (distanceFromCenter < 0.35) return const SizedBox.shrink();

      final fadeFactor = (distanceFromCenter - 0.35) / 0.45;
      final clampedFade = fadeFactor.clamp(0.0, 1.0);

      return Positioned(
        left: particle.x * MediaQuery.of(context).size.width,
        top: particle.y * MediaQuery.of(context).size.height,
        child: AnimatedBuilder(
          animation: _particlesController,
          builder: (context, child) {
            final twinkle = (math.sin(_particlesController.value * math.pi * 2 * particle.size * 2) + 1) / 2;
            return Container(
              width: particle.size,
              height: particle.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD700).withOpacity(
                    particle.opacity * clampedFade * (0.6 + twinkle * 0.4)
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget buildMandala({
    required Alignment alignment,
    double rotateX = 0,
    double rotateY = 0,
  }) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationX(rotateX)..rotateY(rotateY),
          child: Opacity(
            opacity: 0.5,
            child: Image.asset(
              AppImages.mandalaPattern,
              width: MediaQuery.of(context).size.height * 0.35,
            ),
          ),
        ),
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });
}