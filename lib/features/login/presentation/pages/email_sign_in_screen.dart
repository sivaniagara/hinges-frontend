import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/long_button.dart';
import '../../../../core/utils/dialog_box_and_bottom_sheet_utils.dart';
import '../../../../core/utils/text_field_requirements.dart';
import '../bloc/user_auth_bloc.dart';
import '../widgets/custom_text_field.dart';
import 'email_verification_screen.dart';
class EmailSignInScreen extends StatefulWidget {
  const EmailSignInScreen({super.key});

  @override
  State<EmailSignInScreen> createState() => _EmailSignInScreenState();
}

class _EmailSignInScreenState extends State<EmailSignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = 'sivamuthuraj1999@gmail.com';
    _passwordController.text = 'Siva@123';
  }


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Proceed with valid email
      print('Valid email: ${_emailController.text}');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Email submitted successfully')),
      // );
      context.read<UserAuthBloc>().add(SignInRequested(_emailController.text, _passwordController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05,),
              Column(
                children: [
                  Text('Sign In', style: Theme.of(context).textTheme.headlineSmall,),
                  Text('Sign in to my account', style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
              SizedBox(height: screenHeight * 0.05,),
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: CustomTextFormField(
                        textInputAction: TextInputAction.done,
                        controller: _passwordController,
                        title: 'Password',
                        hintText: 'My Password',
                        prefixIcon: Icons.pages_outlined,
                        suffix: BlocBuilder<UserAuthBloc, UserAuthState>(
                          builder: (context, state) {
                            if (state is! EmailSignInState) return const SizedBox.shrink();
                            final currentState = state;
                            return IconButton(
                              padding: EdgeInsets.all(0),
                              constraints: BoxConstraints(maxHeight: 30),
                              iconSize: 20,
                              onPressed: () {
                                context.read<UserAuthBloc>().add(UpdatePasswordVisibilityForEmailSignIn());
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              BlocBuilder<UserAuthBloc, UserAuthState>(
                                builder: (context, state) {
                                  if (state is! EmailSignInState) return const SizedBox.shrink();
                                  return Checkbox(
                                    value: state.rememberMe,
                                    onChanged: (_) {
                                      context.read<UserAuthBloc>().add(UpdateRememberMe());
                                    },
                                  );
                                },
                              ),
                              Text('Remember Me', style: Theme.of(context).textTheme.labelLarge,)
                            ],
                          ),
                          TextButton(
                              onPressed: (){

                              },
                              child: Text('Forget Password')
                          ),
                        ],
                      ),
                    ),
                    BlocListener<UserAuthBloc, UserAuthState>(
                        listener: (context, state){
                          if(state is AuthLoading && state.loading == 'signIn'){
                            showLoadingDialog(context);
                          }else if(state is EmailAuthenticated && !state.isEmailVerified){
                            context.pop();
                            emailVerificationBottomSheet(context, EmailVerificationScreen(email: _emailController.text));
                          }else if(state is EmailAuthenticated && state.isEmailVerified && state is! SignUpState){
                            context.pop();
                            context.go('/leaveSummary');
                          }
                        },
                      child: LongButton(
                          title: 'Sign In',
                          onPressed: _submitForm,
                          outlined: false
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.05,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(child: Divider()),
                    Text('  OR  ', style: Theme.of(context).textTheme.bodyMedium,),
                    Expanded(child: Divider())
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.05,),
              LongButton(
                  title: 'Sign in With Google',
                  prefixIcon: FontAwesomeIcons.google,
                  onPressed: (){

                  },
                  outlined: true
              ),
              SizedBox(height: screenHeight * 0.05,),
              LongButton(
                  title: 'Sign in With Phone',
                  prefixIcon: FontAwesomeIcons.phone,
                  onPressed: (){

                  },
                  outlined: true
              ),
              SizedBox(height: screenHeight * 0.05,),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don’t have an account?', style: Theme.of(context).textTheme.labelMedium,),
                    TextButton(
                        onPressed: (){
                          context.read<UserAuthBloc>().add(SignUpPage()) ;
                          context.go('/login/signUp');
                        },
                        child: Text('Sign Up Here')
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    return BlocBuilder<UserAuthBloc, UserAuthState>(builder: (context, state){
      if((state is EmailSignInState) == false){
        return Container();
      }

    });
  }
}
