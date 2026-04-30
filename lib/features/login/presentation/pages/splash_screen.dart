import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';
import '../bloc/user_auth_bloc.dart';
import '../widgets/mandala_background.dart';
import '../widgets/shared_decorations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _timerDone = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    Future.delayed(const Duration(seconds: 5), () {
      _timerDone = true;
      _navigateIfReady();
    });
  }

  void _navigateIfReady() {
    if (!_timerDone || !mounted) return;

    final state = context.read<UserAuthBloc>().state;
    if (state is AuthenticatedState) {
      context.go('/loading');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserAuthBloc, UserAuthState>(
      listener: (context, state) {
        _navigateIfReady();
      },
      child: Scaffold(
        body: MandalaBackground(
          animateContent: true,
          child: Stack(
            children: [
              const GoldenRingBackground(),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.indianBiddingLeague,
                    height: 170,
                  ),

                  const GoldenTitle(
                    title: 'INDIAN BIDDING LEAGUE',
                    fontSize: 32,
                  ),

                  const StarLine(),

                  Image.asset(
                    AppImages.goldenCrownLine,
                    width: 200,
                    height: 50,
                  ),

                  const GoldenSubtitle(
                    title: 'POWERED BY HINGES GAMES',
                    fontSize: 13,
                  ),
                ],
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