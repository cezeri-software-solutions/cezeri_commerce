import 'dart:io';

Future<bool> checkInternetConnection() async {
  bool isConnected = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connection successful');
      isConnected = true;
    }
  } on SocketException catch (_) {
    print('not connected with the internet!');
    isConnected = false;
  }
  return isConnected;
}
