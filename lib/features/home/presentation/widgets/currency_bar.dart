import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';


class CurrencyBar extends StatelessWidget {
  final String icon;
  final int value;
  final VoidCallback? onAddTap;

  const CurrencyBar({
    super.key,
    required this.icon,
    required this.value,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.navyBlue,
        border: Border.all(color: AppTheme.borderGold),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon, width: 25),

          const SizedBox(width: 8),

          /// VALUE
          Text(
            value.toString(),
            style: GoogleFonts.cinzel(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 8),

          /// ADD BUTTON
          GestureDetector(
            onTap: onAddTap,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.borderGold,
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.add,
                size: 16,
                color: AppTheme.borderGold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}