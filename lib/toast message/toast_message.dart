import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastMessage {
  static void showToast(BuildContext context, String msg) {
    toastification.show(
      context: context,
      title: Text(msg),
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 4),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}

class SnackBarMsg {
  static void showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Center(
        child: Text(msg,),
      ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      )
    );
  }
}