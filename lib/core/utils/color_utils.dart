import 'package:flutter/material.dart';

bool isLightColor(Color color) => color.computeLuminance() > 0.5;
