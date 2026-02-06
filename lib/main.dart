import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/di/dependency_injection.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/login/presentation/bloc/user_auth_bloc.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  // Ensure Flutter binding is initialized before using platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

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
        )
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // home: BlocProvider(
      //   create: (_) => di.sl<LoginBloc>(),
      //   child: const LoginPage(),
      // ),
    );
  }
}
