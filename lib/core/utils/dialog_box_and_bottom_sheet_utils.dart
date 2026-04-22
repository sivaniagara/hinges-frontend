import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:math' as Math;
import 'package:flutter/material.dart';

import 'app_images.dart';

void showLoadingDialog(BuildContext context, {String message = "Loading..."}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.7), // 🔥 dark overlay
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: _GamingLoader(message),
        ),
      );
    },
  );
}

/// 🔥 MAIN LOADER WIDGET
class _GamingLoader extends StatefulWidget {
  final String? message;
  const _GamingLoader(this.message);

  @override
  State<_GamingLoader> createState() => _GamingLoaderState();
}

class _GamingLoaderState extends State<_GamingLoader>
    with TickerProviderStateMixin {

  late AnimationController _rotation;
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();

    _rotation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotation.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 35),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.6),

          border: Border.all(
            color: Colors.amber.withOpacity(0.6),
            width: 1.5,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              blurRadius: 40,
            )
          ],
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// 🔄 ROTATING RING + LOGO
            SizedBox(
              height: 90,
              width: 90,
              child: Stack(
                alignment: Alignment.center,
                children: [

                  /// ROTATING RING
                  AnimatedBuilder(
                    animation: _rotation,
                    builder: (_, __) {
                      return Transform.rotate(
                        angle: _rotation.value * 2 * Math.pi,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.amber,
                              width: 3,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  /// INNER PULSE GLOW
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, __) {
                      double scale = 0.9 + (_pulse.value * 0.2);

                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.4),
                                blurRadius: 25,
                                spreadRadius: 5,
                              )
                            ],
                          ),
                          child: Image.asset(
                            AppImages.indianBiddingLeague,
                            height: 50,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ⚡ LOADING TEXT (PULSE)
            AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) {
                return Opacity(
                  opacity: 0.6 + (_pulse.value * 0.4),
                  child: Text(
                    "PLEASE WAIT",
                    style: TextStyle(
                      color: Colors.amber.shade300,
                      fontSize: 13,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            /// MESSAGE
            if(widget.message != null)
              Text(
                widget.message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),

          ],
        ),
      ),
    );
  }
}

void showMessageDialog({
  required BuildContext context,
  required Icon icon,
  required String title,
  required String message,
  List<Widget>? actionButtons
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: _GamingMessageDialog(
          icon: icon,
          title: title,
          message: message,
          actionButtons: actionButtons,
        ),
      );
    },
  );
}

/// 🔥 GAMING DIALOG UI
class _GamingMessageDialog extends StatefulWidget {
  final Icon icon;
  final String title;
  final String message;
  final List<Widget>? actionButtons;

  const _GamingMessageDialog({
    required this.icon,
    required this.title,
    required this.message,
    this.actionButtons,
  });

  @override
  State<_GamingMessageDialog> createState() => _GamingMessageDialogState();
}

class _GamingMessageDialogState extends State<_GamingMessageDialog>
    with SingleTickerProviderStateMixin {

  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.65),

          border: Border.all(
            color: Colors.amber.withOpacity(0.6),
            width: 1.5,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.9),
              blurRadius: 40,
            )
          ],
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// 🔥 ICON WITH GLOW
            AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) {
                double scale = 1 + (_pulse.value * 0.1);

                return Transform.scale(
                  scale: scale,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (widget.icon.color ?? Colors.amber)
                              .withOpacity(0.4),
                          blurRadius: 25,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: Icon(
                      widget.icon.icon,
                      size: 32,
                      color: widget.icon.color ?? Colors.amber,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            /// TITLE
            Text(
              widget.title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.amber.shade300,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 12),

            /// MESSAGE
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 25),

            /// ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.actionButtons ??
                  [
                    _buildPrimaryButton(context),
                  ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔘 DEFAULT BUTTON
  Widget _buildPrimaryButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Colors.amber.shade600,
              Colors.amber.shade300,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.4),
              blurRadius: 15,
            )
          ],
        ),
        child: const Text(
          "OK",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}


void emailVerificationBottomSheet(BuildContext context, Widget widget){
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    enableDrag: false,
    builder: (context) {
      return widget;
    },
  );
}

void showGuestNameBottomSheet(BuildContext context, {required Function(String) onContinue}) {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFF4D2),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Welcome, Guest!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please enter your name to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: nameController,
                  style: GoogleFonts.oxanium(
                    color: Colors.black, // <-- text color inside the field
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'YOUR NAME',
                    hintStyle: GoogleFonts.oxanium(color: Colors.white38),
                    prefixIcon: const Icon(Icons.person_outline, color: Colors.black),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

                    // Border styles
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF800000), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        onContinue(nameController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF800000),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}



void showGameInfoDialog(BuildContext context, {required String message}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Game Info",
    barrierColor: Colors.black.withOpacity(0.6),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: _GameInfoDialog(message: message),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.scale(
        scale: Curves.easeOutBack.transform(animation.value),
        child: child,
      );
    },
  );
}

class _GameInfoDialog extends StatelessWidget {
  final String message;

  const _GameInfoDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xffB71C1C), Color(0xff7F0000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔴 Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "INFORMATION",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // 🟡 Message Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffF5E6C8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.orange.shade700, width: 2),
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🎯 OK Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF1D2B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "OK",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
