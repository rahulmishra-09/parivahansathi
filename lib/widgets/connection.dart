import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:railway/toast%20message/toast_message.dart';

class Connection {
  Future<void> checkConnection(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    // Print the result for debugging
    print("Connectivity Result: $connectivityResult");

    if (connectivityResult == ConnectivityResult.none) {
      ToastMessage.showToast(context, 'No internet connection.');
    } else {
      if (context.mounted) return;
    }
  }
}
