import 'package:flutter/material.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';

class CancelHeader extends StatelessWidget {
  const CancelHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 10,),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.asset(
                width: 25,
                AppImages.cancelIcon
            ),
          ),
        ],
      ),
    );
  }
}
