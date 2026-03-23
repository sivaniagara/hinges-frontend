import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/presentation/widgets/gradient_text.dart';
import '../../../../core/presentation/widgets/long_button.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/dialog_box_and_bottom_sheet_utils.dart';
import '../bloc/user_auth_bloc.dart';
import '../widgets/custom_text_field.dart';

class GuestNameScreen extends StatefulWidget {
  final bool isBottomSheet;
  const GuestNameScreen({super.key, this.isBottomSheet = false});

  @override
  State<GuestNameScreen> createState() => _GuestNameScreenState();
}

class _GuestNameScreenState extends State<GuestNameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<Color> textColorForYellowTag = [const Color(0xff330000), const Color(0xffFF1D2B)];

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<UserAuthBloc>().add(GuestSignInRequested(_nameController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = BlocListener<UserAuthBloc, UserAuthState>(
      listener: (context, state) {
        if (state is AuthLoading && state.loading == 'guest-signIn') {
          showLoadingDialog(context, message: "Logging in...");
        } else if (state is GuestAuthenticated) {
          if (widget.isBottomSheet) {
            Navigator.pop(context); // Close bottom sheet
          }
          context.pop(); // Close loading dialog
          context.go('/loading');
        } else if (state is EmailAuthError) {
          context.pop(); // Close loading dialog
          showMessageDialog(
            context: context,
            icon: const Icon(Icons.error_outline, color: Colors.red),
            title: 'Login Error',
            message: state.message,
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            colors: [
              Color(0xFF800000), // Center deep red
              Color(0xFFA7100E), // Outer darker red
            ],
            radius: 1.2,
          ),
          borderRadius: widget.isBottomSheet 
              ? const BorderRadius.vertical(top: Radius.circular(30)) 
              : BorderRadius.zero,
          border: widget.isBottomSheet 
              ? const Border(top: BorderSide(color: Colors.black, width: 2))
              : null,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Themed Header
              Container(
                width: 220,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.yellowTag),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: GradientText(
                    title: 'WELCOME GUEST',
                    colors: textColorForYellowTag,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Enter your name to join the auction room',
                textAlign: TextAlign.center,
                style: GoogleFonts.oxanium(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              // Themed Input Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1),
                ),
                child: TextFormField(
                  controller: _nameController,
                  style: GoogleFonts.oxanium(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'YOUR NAME',
                    hintStyle: GoogleFonts.oxanium(color: Colors.white38),
                    prefixIcon: const Icon(Icons.person_outline, color: Colors.black),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

                    // Explicitly override borders
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF800000), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                )
              ),
              const SizedBox(height: 40),
              // Custom Button
              LongButton(
                title: 'CONTINUE',
                onPressed: _submit,
                outlined: false,
              ),
              if (widget.isBottomSheet) SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );

    if (widget.isBottomSheet) {
      return content;
    }

    return Scaffold(
      body: Center(child: content),
    );
  }
}
