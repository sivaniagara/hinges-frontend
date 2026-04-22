import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/user_auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _bgController;

  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<double> _bgAnimation;

  bool _timerDone = false;
  bool _authChecked = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    /// 🔹 Main Animation
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fade = CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeIn,
    );

    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOutBack),
    );

    /// 🔹 Background Animation
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _bgAnimation = Tween<double>(begin: 0, end: 1).animate(_bgController);

    _mainController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      _timerDone = true;
      _navigateIfReady();
    });
  }

  void _navigateIfReady() {
    if (!_timerDone || !_authChecked || !mounted) return;

    final state = context.read<UserAuthBloc>().state;

    if (state is AuthenticatedState) {
      context.go('/loading');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserAuthBloc, UserAuthState>(
      listener: (context, state) {
        _authChecked = true;
        _navigateIfReady();
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _bgAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.lerp(
                        const Color(0xFF0F172A),
                        const Color(0xFF1E293B),
                        _bgAnimation.value)!,
                    Color.lerp(
                        const Color(0xFF020617),
                        const Color(0xFF020617),
                        _bgAnimation.value)!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: child,
            );
          },
          child: Stack(
            children: [
              /// 🔹 Center Content
              Center(
                child: FadeTransition(
                  opacity: _fade,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const SizedBox(height: 20),

                        ShimmerTitle(),

                        const SizedBox(height: 10),

                        /// 🔸 Subtitle
                        Text(
                          'Play • Bid • Win',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 14,
                            letterSpacing: 1.2,
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerTitle extends StatefulWidget {
  const ShimmerTitle({super.key});

  @override
  State<ShimmerTitle> createState() => _ShimmerTitleState();
}

class _ShimmerTitleState extends State<ShimmerTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1, 0),
              end: Alignment(1, 0),
              colors: [
                Colors.amber,
                Colors.white,
                Colors.amber,
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: Text(
            'INDIAN BIDDING LEAGUE',
            textAlign: TextAlign.center,
            style: GoogleFonts.goldman(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}