import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_images.dart';


class BackIcon extends StatelessWidget {
  const BackIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.pop();
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Image.asset(
          AppImages.backMenuIcon,
          width: 50,
        ),
      ),
    );
  }
}
