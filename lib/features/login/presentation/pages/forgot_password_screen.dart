import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/long_button.dart';
import '../../../../core/utils/dialog_box_and_bottom_sheet_utils.dart';
import '../../../../core/utils/text_field_requirements.dart';
import '../bloc/user_auth_bloc.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context
          .read<UserAuthBloc>()
          .add(ForgotPasswordRequested(_emailController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: BlocListener<UserAuthBloc, UserAuthState>(
        listener: (context, state) {
          if (state is AuthLoading && state.loading == 'forgotPassword') {
            showLoadingDialog(context);
          } else if (state is ForgotPasswordSuccess) {
            context.pop(); // Close loading dialog
            showMessageDialog(
              context: context,
              title: 'Success',
              message: 'Password reset link sent to your email.',
              actionButtons: [
                ElevatedButton(
                  onPressed: () {
                    context.pop(); // Close message dialog
                    context.pop(); // Go back to sign-in screen
                  },
                  child: const Text('OK'),
                ),
              ],
                icon: const Icon(Icons.error_outline, color: Colors.red)
            );
          } else if (state is EmailAuthError) {
            context.pop(); // Close loading dialog
            showMessageDialog(
              context: context,
              icon: const Icon(Icons.error_outline, color: Colors.red),
              title: 'Error',
              message: state.message,
              actionButtons: [
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _emailController,
                  title: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  validator: validateEmailId,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                LongButton(
                  title: 'Send Reset Link',
                  onPressed: _submitForm,
                  outlined: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
