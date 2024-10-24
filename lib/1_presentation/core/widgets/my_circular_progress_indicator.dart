import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyCircularProgressIndicator extends StatelessWidget {
  final Color color;
  const MyCircularProgressIndicator({super.key, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return CircularProgressIndicator(color: color);
    if (Platform.isIOS) return CupertinoActivityIndicator(color: color);
    if (Platform.isAndroid) return CircularProgressIndicator(color: color);

    return const Center(child: Text('Laden...'));
  }
}
