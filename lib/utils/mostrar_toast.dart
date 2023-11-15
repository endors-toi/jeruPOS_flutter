import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

void mostrarToast(String message) {
  var cancel = BotToast.showText(
    clickClose: true,
    text: message,
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  );
  Future.delayed(Duration(seconds: 2), () {
    cancel();
  });
}
