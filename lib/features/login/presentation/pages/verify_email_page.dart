import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_auth_bloc.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserAuthBloc>().state is EmailAuthenticated
        ? (context.read<UserAuthBloc>().state as EmailAuthenticated).user
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('A verification email has been sent to ${user?.email ?? ''}'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.read<UserAuthBloc>().add(ResendEmailVerification()),
              child: const Text('Resend Email'),
            ),
            TextButton(
              onPressed: () => context.read<UserAuthBloc>().add(RefreshUser()),
              child: const Text('I verified, refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
