import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hinges_frontend/core/utils/app_images.dart';

import 'cancel_header.dart';

class DialogDetails extends StatelessWidget {
  final List<String> points;
  const DialogDetails({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      alignment: AlignmentGeometry.center,
      child: Container(
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width * 0.5,
        // height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: const Color(0xFF800000), // Maroon Background
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 20,
          children: [
            CancelHeader(), // Main Content
            Column(
              spacing: 10,
              children: [
                ...List.generate(points.length, (index){
                  return Row(
                    children: [
                      Image.asset(
                          width: 25,
                          height: 25,
                        AppImages.startIcon
                      ),
                      Expanded(child: Text(points[index], maxLines: 2,style: GoogleFonts.oxanium(textStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),))
                    ],
                  );
                })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
