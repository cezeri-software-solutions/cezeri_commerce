import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyCircularProgressIndicator extends StatelessWidget {
  final Color color;
  const MyCircularProgressIndicator({Key? key, this.color = Colors.blue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return CircularProgressIndicator(color: color);
    if (Platform.isIOS) return CupertinoActivityIndicator(color: color);
    if (Platform.isAndroid) return CircularProgressIndicator(color: color);

    return const Center(child: Text('Laden...'));
  }
}
