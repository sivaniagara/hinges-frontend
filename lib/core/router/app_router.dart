import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';
import 'package:hinges_frontend/features/game/presentation/pages/game_screen.dart';
import 'package:hinges_frontend/features/mini_auction/presentation/pages/mini_auction_lite/mini_auction_lite_mode.dart';
import 'package:hinges_frontend/features/mini_auction/presentation/pages/mini_auction_screen.dart';
import 'package:hinges_frontend/features/mini_auction/presentation/pages/mini_auction_lite/mini_auction_mode.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/login/presentation/bloc/user_auth_bloc.dart';
import '../../features/login/presentation/pages/email_auth_screen.dart';
import '../../features/login/presentation/pages/sign_up_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/login/presentation/pages/loading_screen.dart';
import '../../features/login/presentation/pages/splash_screen.dart';
import '../di/dependency_injection.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

Widget pageSlider(context, animation, secondaryAnimation, child){
  const begin = Offset(2.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}

final router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const EmailAuthScreen(),
          transitionsBuilder: pageSlider,
        );
      },
      routes: [
        GoRoute(
          path: 'signUp',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const SignUpScreen(),
              transitionsBuilder: pageSlider,
            );
          },
        ),
      ]
    ),
    GoRoute(
      path: '/home',
      builder: (context, state){
        return HomeScreen();
      },
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: '/miniAuction',
      builder: (context, state) => MiniAuctionScreen(),
    ),
    // GoRoute(
    //   path: '/miniAuctionMode',
    //   builder: (context, state) => MiniAuctionMode(),
    // ),
    GoRoute(
      path: '/miniAuctionLiteMode',
      builder: (context, state){
        return const MiniAuctionLiteMode();
      },
    ),
    GoRoute(
      path: '/game',
      builder: (context, state){
        final homeData = context.read<HomeBloc>().state as HomeLoaded;
        print("homeData.userData.auctionCategoryItem.first.id => ${homeData.userData.auctionCategoryItem.first.id}");
        return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<GameBloc>()..add(
                    FetchGameData(
                        userId: homeData.userData.userId,
                        userName: homeData.userData.userName,
                        auctionCategoryId: homeData.userData.auctionCategoryItem.first.id
                    )
                ),
              )
            ],
            child: GameScreen()
        );
        },
    ),
  ],
);
