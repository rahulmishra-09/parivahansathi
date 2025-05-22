import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  String message;
  LoadingPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      backgroundColor: Colors.black87,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(padding: EdgeInsets.all(16.0),

        child: Row(
          children: [
            const SizedBox(width: 5.0,),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
            const SizedBox(width: 8.0,),
            Text(message, style: TextStyle(color: Colors.white, fontSize: 16),)
          ],
        ),
        ),
      ),
    );
  }
}