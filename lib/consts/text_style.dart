import 'package:flutter/material.dart';
import 'package:music_player/consts/colors.dart';

ourStyle({weight = FontWeight.normal, double? size = 14, color = whiteColor}) {
  return TextStyle(
    fontSize: size,
    color: color,
    fontWeight: weight,
  );
}