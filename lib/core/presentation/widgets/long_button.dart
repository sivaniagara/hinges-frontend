import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LongButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final bool outlined;
  IconData? prefixIcon;
  LongButton({super.key, required this.title, required this.onPressed, required this.outlined, this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        gradient: !outlined ? LinearGradient(
          colors: [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ) : null,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: outlined ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1) : null
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            if(prefixIcon != null)
              FaIcon(prefixIcon),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: outlined ? Colors.black : Theme.of(context).colorScheme.secondary, ),
            ),
          ],
        ),
      ),
    );
  }
}
