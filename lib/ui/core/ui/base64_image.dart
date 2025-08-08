import 'dart:convert';

import 'package:flutter/material.dart';

class Base64Image extends StatelessWidget {
  const Base64Image({
    super.key,
    required this.image,
    required this.height,
    required this.width,
  });

  // base64字符串
  final String image;

  final double height;

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      base64.decode(image),
      fit: BoxFit.cover,
      height: height,
      width: width,
      gaplessPlayback: true,
    );
  }
}
