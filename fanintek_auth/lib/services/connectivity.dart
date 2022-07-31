import 'dart:io';

Future<bool> isInternet() async {
  bool isConnect = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isConnect = true;
    }
  } on SocketException catch (e) {
    isConnect = false;
  }

  return isConnect;
}
