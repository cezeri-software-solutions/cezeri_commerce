import 'dart:math';

import 'package:flutter/material.dart';

Color getRandomColor(int index, {double? opacity = 1.0}) {
  final random = Random(index);
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    opacity!,
  );
}
