import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../bloc/user_auth_bloc.dart';
import 'email_sign_in_screen.dart';

class EmailAuthScreen extends StatefulWidget {
  const   EmailAuthScreen({super.key});
  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool _emailSignInSheetOpened = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<EmailAuthBloc>().add(EmailSignInPage());
    // });
  }

  void _emailSignInSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isDismissible: false,
      enableDrag: false,
      builder: (bottomSheetContext) {
        return EmailSignInScreen();
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    // return Scaffold(
    //   appBar: AppBar(title: const Text('Sign In')),
    //   body: BlocListener<EmailAuthBloc, EmailAuthState>(
    //     listener: (context, state) {
    //       if (state is AuthError) {
    //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
    //       }
    //     },
    //     child: Padding(
    //       padding: const EdgeInsets.all(16),
    //       child: Column(
    //         children: [
    //           TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
    //           TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
    //           const SizedBox(height: 16),
    //           FilledButton(
    //             onPressed: () {
    //               context.read<EmailAuthBloc>().add(SignInRequested(emailCtrl.text, passCtrl.text));
    //             },
    //             child: const Text('Sign In'),
    //           ),
    //           TextButton(
    //             onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen())),
    //             child: const Text('Create Account'),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return AdaptiveStatusBar(
        color: Theme.of(context).colorScheme.secondary,
        child: Scaffold(
          body: BlocListener<UserAuthBloc, UserAuthState>(
            listener: (context, state){
              print('state ::: $state');
              if (state is EmailSignInState && !_emailSignInSheetOpened) {
                _emailSignInSheetOpened = true;
                _emailSignInSheet(context);
              }
            },
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        )
    );
  }
}


