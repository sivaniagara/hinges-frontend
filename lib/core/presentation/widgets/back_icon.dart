import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../di/dependency_injection.dart';
import '../../utils/app_images.dart';
import '../../utils/app_sounds.dart';
import '../../utils/audio_manager.dart';
import '../../utils/so_loud.dart';


class BackIcon extends StatelessWidget {
  void Function()? onTap;
  BackIcon({super.key, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? (){
        playVibrateOnly();
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
