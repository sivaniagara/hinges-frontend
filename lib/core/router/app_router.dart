import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';
import 'package:hinges_frontend/features/game/presentation/pages/game_screen.dart';
import 'package:hinges_frontend/features/game/presentation/pages/my_squad_screen.dart';
import 'package:hinges_frontend/features/game/presentation/pages/players_screen.dart';
import 'package:hinges_frontend/features/game/presentation/pages/points_table_screen.dart';
import 'package:hinges_frontend/features/home/presentation/pages/profile_screen.dart';
import 'package:hinges_frontend/features/home/presentation/pages/rule_book_screen.dart';
import 'package:hinges_frontend/features/home/presentation/pages/setting_screen.dart';
import 'package:hinges_frontend/features/home/presentation/pages/shop_screen.dart';
import 'package:hinges_frontend/features/login/presentation/pages/forgot_password_screen.dart';
import 'package:hinges_frontend/features/login/presentation/pages/guest_name_screen.dart';
import 'package:hinges_frontend/features/login/presentation/pages/login_screen.dart';
import 'package:hinges_frontend/features/mini_auction/presentation/pages/create_room.dart';
import 'package:hinges_frontend/features/mini_auction/presentation/pages/mini_auction_screen.dart';
import 'package:hinges_frontend/features/mini_auction/presentation/pages/play_with_friends.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/home/presentation/pages/mini_auction_lite_rule_book_screen.dart';
import '../../features/login/presentation/pages/sign_up_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/login/presentation/pages/loading_screen.dart';
import '../../features/login/presentation/pages/splash_screen.dart';
import '../../features/mini_auction/presentation/pages/join_room.dart';
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
          child: const LoginScreen(),
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
        GoRoute(
          path: 'forgotPassword',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const ForgotPasswordScreen(),
              transitionsBuilder: pageSlider,
            );
          },
        ),
        GoRoute(
          path: 'guestName',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const GuestNameScreen(),
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
      path: '/profile',
      builder: (context, state){
        final homeData = context.read<HomeBloc>().state as HomeLoaded;
        return ProfileScreen(userData: homeData.userData);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state){
        final homeData = context.read<HomeBloc>().state as HomeLoaded;
        return SettingScreen(userData: homeData.userData);
      },
    ),
    GoRoute(
      path: '/shop',
      builder: (context, state){
        final homeData = context.read<HomeBloc>().state as HomeLoaded;
        return ShopScreen(userData: homeData.userData);
      },
    ),
    GoRoute(
      path: '/ruleBook',
      builder: (context, state){
        return RuleBookScreen();
      },
      routes: [
        GoRoute(
          path: 'miniAuctionLiteRuleBook',
          builder: (context, state){
            return const MiniAuctionLiteRuleBookScreen();
          },
        ),
      ]
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: '/miniAuctionLite',
      builder: (context, state) {
        final mode = state.extra as AuctionItem;
        return MiniAuctionScreen(auctionItem: mode,);
      },
    ),
    GoRoute(
      path: '/playWithFriends',
      builder: (context, state) {
        final mode = state.extra as MiniAuctionLiteMode;
        return PlayWithFriends(mode: mode,);
      },
    ),
    GoRoute(
      path: '/createRoom',
      builder: (context, state) {
        final mode = state.extra as MiniAuctionLiteMode;
        return BlocProvider(
          create: (context) => sl<GameBloc>()..add(GetRoomCode()),
          child: CreateRoom(mode: mode),
        );
      },
    ),
    GoRoute(
      path: '/joinRoom',
      builder: (context, state) {
        final mode = state.extra as MiniAuctionLiteMode;
        return JoinRoom(mode: mode,);
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        final homeData = context.read<HomeBloc>().state as HomeLoaded;

        // ✅ Only create GameBloc ONCE for all /game routes
        return BlocProvider(
          create: (_) {
            final bloc = sl<GameBloc>();

            // ✅ Only trigger FetchGameData when entering /game root
            if (state.uri.toString().startsWith('/game')) {
              final extra = state.extra as Map<String, dynamic>?;

              if (extra != null) {
                bloc.add(
                  FetchGameData(
                    userId: homeData.userData.userId,
                    userName: homeData.userData.userName,
                    auctionCategoryId: extra['id'],
                    matchType:
                    (extra['matchType'] as MatchTypeEnum).value,
                    roomCode: extra['roomCode'] ?? '',
                    hostId: extra['hostId'],
                  ),
                );
              }
            }

            return bloc;
          },
          child: child,
        );
      },
      routes: [
        /// =========================
        /// 🎮 GAME MAIN
        /// =========================
        GoRoute(
          path: '/game',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;

            return GameScreen(
              mode: extra["mode"] as MiniAuctionLiteMode, auctionCategoryId: extra["id"],
            );
          },
        ),

        /// =========================
        /// 👥 MY SQUAD
        /// =========================
        GoRoute(
          path: '/game/mySquad',
          builder: (context, state) {
            final userId = state.uri.queryParameters['userId'] ?? '';

            return MySquadScreen(userId: userId);
          },
        ),

        /// =========================
        /// 🧑‍🤝‍🧑 PLAYER LIST
        /// =========================
        GoRoute(
          path: '/game/playerList',
          builder: (context, state) {
            final userId = state.uri.queryParameters['userId'] ?? '';
            final playerRoleId =
                state.uri.queryParameters['playerRole'] ?? '';
            final playerRoleName =
                state.uri.queryParameters['playerRoleName'] ?? '';

            return PlayersScreen(
              userId: userId,
              playerRole: playerRoleId,
              playerRoleName: playerRoleName,
            );
          },
        ),

        /// =========================
        /// 📊 POINTS TABLE
        /// =========================
        GoRoute(
          path: '/game/pointsTable',
          builder: (context, state) => const PointsTableScreen(),
        ),
      ],
    )
  ],
);
