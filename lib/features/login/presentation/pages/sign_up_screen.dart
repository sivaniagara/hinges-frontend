import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/adaptive_status_bar.dart';
import '../../../../core/presentation/widgets/long_button.dart';
import '../../../../core/utils/dialog_box_and_bottom_sheet_utils.dart';
import '../../../../core/utils/text_field_requirements.dart';
import '../bloc/user_auth_bloc.dart';
import '../widgets/custom_text_field.dart';
import 'email_auth_screen.dart';
import 'package:flutter/gestures.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();


  void _submitForm() {
    final state = context.read<UserAuthBloc>().state as SignUpState;
    if(!state.agreeTermsAndCondition){
      showMessageDialog(
          context: context,
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          title: 'Terms & Conditions',
          message: 'Please agree to the terms and conditions to proceed.'
      );
    }else{
      if (_formKey.currentState!.validate()) {
        // Proceed with valid email
        // print('Valid email: ${_emailController.text}');
        context.read<UserAuthBloc>()
            .add(
            SignUpRequested(
                userName: _userNameController.text,
                emailId: _emailController.text,
                password: _passwordController.text,
                phoneNumber: _phoneNumberController.text,
                agreeTermsAndCondition: state.agreeTermsAndCondition
            )
        );
      }
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = 'sivamuthuraj1999@gmail.com';
    _passwordController.text = 'Siva@123';
    _confirmPasswordController.text = 'Siva@123';
    _phoneNumberController.text = '8220676342';
    _userNameController.text = 'siva prakash';
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        print("Did pop: $didPop");
        print("Result: $result");
        if(didPop == true) return;
        if(result == true){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<UserAuthBloc>().add(EmailSignInPage());
          });
        }
        if (result == null) {
          context.pop(true);
        }

      },
      child: AdaptiveStatusBar(
          color: Theme.of(context).colorScheme.surface,
          child: Container(
            color: Colors.white,
            width: double.infinity,
            child: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.05,),
                      Container(
                        // padding: EdgeInsets.all(25),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/png/indian_bidding_league.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05,),
                      Text('Game Mate', style: Theme.of(context).textTheme.headlineSmall,),
                      Text('Register Using Your Credentials', style: Theme.of(context).textTheme.labelLarge,),
                      SizedBox(height: screenHeight * 0.05,),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: CustomTextFormField(
                                controller: _userNameController,
                                title: 'User Name',
                                hintText: 'Enter Your Name',
                                prefixIcon: Icons.person,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter your Name";
                                  }
                                  if(value.length < 9){
                                    return "Name should be at least 8 characters";
                                  }
                                  if(value.length > 16){
                                    return "Name should be less than 15 characters";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.05,),
                            // TODO: emailId field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: CustomTextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _emailController,
                                title: 'Email',
                                hintText: 'My Email',
                                prefixIcon: Icons.email_outlined,
                                validator: validateEmailId,
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.05,),
                            // TODO: password field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: CustomTextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _passwordController,
                                title: 'Password',
                                hintText: 'My Password',
                                prefixIcon: Icons.pages_outlined,
                                suffix: BlocBuilder<UserAuthBloc, UserAuthState>(
                                  builder: (context, state) {
                                    if (state is! SignUpState) return const SizedBox.shrink();
                                    final currentState = state;
                                    return IconButton(
                                      constraints: BoxConstraints(maxHeight: 30),
                                      iconSize: 20,
                                      onPressed: () {
                                        context.read<UserAuthBloc>().add(UpdatePasswordVisibilityForEmailSignOut());
                                      },
                                      icon: Icon(
                                        currentState.showPassword ? Icons.visibility : Icons.visibility_off,
                                        color: Theme.of(context).colorScheme.primaryContainer,
                                      ),
                                    );
                                  },
                                ),
                                validator: validatePassword,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.05,),
                            // TODO: confirm password field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: CustomTextFormField(
                                controller: _confirmPasswordController,
                                title: 'Confirm Password',
                                hintText: 'Confirm My Password',
                                prefixIcon: Icons.pages_outlined,
                                suffix: BlocBuilder<UserAuthBloc, UserAuthState>(
                                  builder: (context, state) {
                                    if (state is! SignUpState) return const SizedBox.shrink();
                                    final currentState = state;
                                    return IconButton(
                                      constraints: BoxConstraints(maxHeight: 30),
                                      iconSize: 20,
                                      onPressed: () {
                                        context.read<UserAuthBloc>().add(UpdateConfirmPasswordVisibilityForEmailSignOut());
                                      },
                                      icon: Icon(
                                        currentState.showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                        color: Theme.of(context).colorScheme.primaryContainer,
                                      ),
                                    );
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please confirm your password";
                                  }
                                  if (value != _passwordController.text) {
                                    return "Password and Confirm Password do not match";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.05,),
                            // TODO: phone number field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: CustomTextFormField(
                                keyboardType: TextInputType.phone,
                                controller: _phoneNumberController,
                                title: 'Phone Number',
                                hintText: 'My Phone Number',
                                prefixIcon: Icons.phone,
                                validator: validatePhoneNumber,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  BlocBuilder<UserAuthBloc, UserAuthState>(
                                    builder: (context, state) {
                                      if (state is! SignUpState) return const SizedBox.shrink();
                                        return Checkbox(
                                          value: state.agreeTermsAndCondition,
                                          onChanged: (_) {
                                            context.read<UserAuthBloc>().add(UpdateAgreeTermsAndCondition());
                                          },
                                        );
                                    },
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style:  Theme.of(context).textTheme.labelLarge,
                                        children: [
                                          const TextSpan(text: "I agree with "),
                                          TextSpan(
                                            text: "Terms & Conditions",
                                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primaryContainer),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
      
                                              },
                                          ),
                                          const TextSpan(text: " and "),
                                          TextSpan(
                                            text: "Privacy Policy",
                                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primaryContainer),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
      
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
      
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.1,),
                            //TODO: sign up button
                            BlocListener<UserAuthBloc, UserAuthState>(
                                listener: (context, state){
                                  if((state as SignUpState).status == SignUpStatus.loading){
                                    showLoadingDialog(context);
                                  }else if(state.status == SignUpStatus.success){
                                    context.pop();
                                    showMessageDialog(
                                        context: context,
                                        icon: Icon(Icons.verified, color: Colors.green),
                                        title: 'Success',
                                        message: state.message,
                                        actionButtons: [
                                          TextButton(
                                              onPressed: (){
                                                context.pop();
                                              },
                                              child: Text('Cancel')
                                          ),
                                          ElevatedButton(
                                              onPressed: (){
                                                context.pop();
                                                context.go('/login');
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  context.read<UserAuthBloc>().add(EmailSignInPage());
                                                });
                                              },
                                              child: Text('Go to Sign In')
                                          ),
                                        ]
                                    );
                                  }else if(state.status == SignUpStatus.error){
                                    context.pop();
                                    showMessageDialog(
                                        context: context,
                                        icon: Icon(Icons.error_outline, color: Colors.red),
                                        title: 'Error on Sign Up',
                                        message: state.message,
                                      actionButtons: [
                                        ElevatedButton(
                                            onPressed: (){
                                              context.pop();
                                            },
                                            child: Text('Ok')
                                        ),
                                      ]
                                    );
                                  }
                                },
                              child: LongButton(
                                  title: 'Sign Up',
                                  onPressed: _submitForm,
                                  outlined: false
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.08,),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?', style: Theme.of(context).textTheme.labelMedium,),
                            TextButton(
                                onPressed: (){
                                  context.go('/login');
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    context.read<UserAuthBloc>().add(EmailSignInPage());
                                  });
                                },
                                child: Text('Sign In Here')
                            )
                          ],
                        ),
                      )
      
                    ],
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}
