import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShortButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final bool outlined;
  const ShortButton({super.key, required this.title, required this.onPressed, required this.outlined,});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: outlined ? Theme.of(context).colorScheme.primaryContainer : Colors.white, ),
          ),
        ),
      ),
    );
  }
}
