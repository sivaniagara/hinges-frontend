import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hinges_frontend/core/utils/so_loud.dart';
import 'core/di/dependency_injection.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/warm_up_sound.dart';
import 'features/ads/bloc/ad_bloc.dart';
import 'features/ads/bloc/ad_event.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/login/presentation/bloc/user_auth_bloc.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  // Ensure Flutter binding is initialized before using platform channels
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: ['FD2D1E2F6FFAD5A78E8D71F61E2D9689'],
      ),
    );
  }

  await MobileAds.instance.initialize();
  // Initialize dependency injection
  await di.init();
  // warmUpSound();
  await initSoLoud();


  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<UserAuthBloc>()..add(AppStarted())),
        BlocProvider.value(
          value: di.sl<HomeBloc>(),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => di.sl<AdBloc>()..add(LoadRewardedAd()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.theme,
      // home: BlocProvider(
      //   create: (_) => di.sl<LoginBloc>(),
      //   child: const LoginPage(),
      // ),
    );
  }
}