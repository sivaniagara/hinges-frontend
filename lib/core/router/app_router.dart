import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/login/presentation/bloc/user_auth_bloc.dart';
import '../../features/login/presentation/pages/email_auth_screen.dart';
import '../../features/login/presentation/pages/sign_up_screen.dart';

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
  initialLocation: '/login/signUp',
  routes: [
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const EmailAuthScreen(),
          transitionsBuilder: pageSlider,
        );
      },
      // builder: (context, state) => EmailAuthScreen(),
      routes: [
        GoRoute(
          path: 'signUp',
          pageBuilder: (context, state) {
            context.read<UserAuthBloc>().add(SignUpPage());
            return CustomTransitionPage(
              key: state.pageKey,
              child: const SignUpScreen(),
              transitionsBuilder: pageSlider,
            );
          },
        ),

      ]
    ),

  ],

  // Example redirect (auth check)
  redirect: (context, state) {
    // final isLoggedIn = context.read<AuthBloc>().state is Authenticated;
    // final loggingIn = state.matchedLocation == '/login';
    //
    // if (!isLoggedIn && !loggingIn) return '/login';

    return null;
  },
);
