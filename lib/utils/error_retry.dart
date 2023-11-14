import 'package:flutter/material.dart';

class ErrorRetry extends StatelessWidget {
  final String errorMsg;
  final VoidCallback onRetry;

  ErrorRetry({required this.errorMsg, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          children: [
            Text(
              errorMsg,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: onRetry,
              child: Text("Reintentar"),
            )
          ],
        ),
      ),
    );
  }
}
