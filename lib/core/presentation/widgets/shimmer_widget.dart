import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF4A0000),
      highlightColor: const Color(0xFF800000),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.red.shade900,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
