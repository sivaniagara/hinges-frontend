import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }



  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<UserAuthBloc>().state;
      bool rememberMe = false;
      if (state is EmailSignInState) {
        rememberMe = state.rememberMe;
      }
      context.read<UserAuthBloc>().add(SignInRequested(
        _emailController.text,
        _passwordController.text,
        rememberMe: rememberMe,
      ));
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
                            bool showPassword = false;
                            if (state is EmailSignInState) {
                              showPassword = state.showPassword;
                            }
                            return IconButton(
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(maxHeight: 30),
                              iconSize: 20,
                              onPressed: () {
                                context.read<UserAuthBloc>().add(UpdatePasswordVisibilityForEmailSignIn());
                              },
                              icon: Icon(
                                showPassword ? Icons.visibility : Icons.visibility_off,
                                color: Theme.of(context).colorScheme.primaryContainer,
                              ),
                            );
                          },
                        ),
                        // obscureText: context.select((UserAuthBloc bloc) {
                        //   final state = bloc.state;
                        //   if (state is EmailSignInState) return !state.showPassword;
                        //   return true;
                        // }),
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
                                  bool rememberMe = false;
                                  if (state is EmailSignInState) {
                                    rememberMe = state.rememberMe;
                                  }
                                  return Checkbox(
                                    value: rememberMe,
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
                                context.push('/login/forgotPassword');
                              },
                              child: const Text('Forget Password')
                          ),
                        ],
                      ),
                    ),
                    BlocListener<UserAuthBloc, UserAuthState>(
                        listener: (context, state){
                          if(state is AuthLoading && state.loading == 'signIn'){
                            showLoadingDialog(context);
                          }else if(state is EmailAuthenticated && state.isEmailVerified){
                            context.pop();
                            context.go('/loading');
                          }else if(state is EmailAuthenticated && !state.isEmailVerified){
                            context.pop();
                            emailVerificationBottomSheet(context, EmailVerificationScreen(email: _emailController.text));
                          }else if(state is EmailAuthError){
                            context.pop();
                            showMessageDialog(
                                context: context,
                                icon: const Icon(Icons.error_outline, color: Colors.red),
                                title: 'Error on Sign In',
                                message: state.message,
                                actionButtons: [
                                  ElevatedButton(
                                      onPressed: (){
                                        context.pop();
                                      },
                                      child: const Text('Ok')
                                  ),
                                ]
                            );
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
                    const Expanded(child: Divider()),
                    Text('  OR  ', style: Theme.of(context).textTheme.bodyMedium,),
                    const Expanded(child: Divider())
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
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.go('/login/signUp');
                          });
                          context.read<UserAuthBloc>().add(SignUpPage()) ;
                        },
                        child: const Text('Sign Up Here')
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
