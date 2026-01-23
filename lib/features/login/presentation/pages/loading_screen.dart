import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_images.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Force landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Show dialog AFTER first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLoading();
    });
  }


  void _startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_progress < 1.0) {
        setState(() {
          _progress += 0.01;
        });
      } else {
        _timer?.cancel();

        if (mounted) {
          context.go('/home'); // Navigate next
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    // Restore all orientations
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.3),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: (MediaQuery.of(context).size.width / 2) - 150,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                AppImages.auctionerBox,
                width: 300,
                height: 300,
              ),
            ),
          ),
          Positioned(
            bottom: -70,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                AppImages.biddingPeople,
                width: MediaQuery.of(context).size.width,
                height: 300,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.indianBiddingLeague,
                  height: 180,
                ),
                const SizedBox(height: 20),

                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.5),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.orange,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  'LOADING...',
                  style: TextStyle(
                    color: Colors.yellow,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'POWERED BY HINGES GAMES',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
