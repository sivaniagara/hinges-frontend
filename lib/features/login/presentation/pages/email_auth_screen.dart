import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    return AdaptiveStatusBar(
        color: Theme.of(context).colorScheme.secondary,
        child: Scaffold(
          body: BlocListener<UserAuthBloc, UserAuthState>(
            listener: (context, state){
              print('auth screen ::: $state');
              if(state is EmailAuthenticated && state.isEmailVerified && !_emailSignInSheetOpened){
                context.go('/loading');
              }else if ((state is EmailSignInState && !_emailSignInSheetOpened) || state is SignOutRequested) {
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