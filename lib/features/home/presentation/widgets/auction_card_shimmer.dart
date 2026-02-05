import 'package:flutter/material.dart';
import 'package:hinges_frontend/core/presentation/widgets/shimmer_widget.dart';

import '../../../../core/utils/app_images.dart';

class AuctionCardShimmer extends StatelessWidget {
  const AuctionCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: size.width * 0.4,
              height: size.height * 0.6,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(AppImages.auctionCard),
                  fit: BoxFit.fitWidth,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: ShimmerWidget(
                  width: size.width * 0.25,
                  height: 40,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            /// Title shimmer
            Positioned(
              top: 10,
              child: ShimmerWidget(
                width: 160,
                height: 30,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
