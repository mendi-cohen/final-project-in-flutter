import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showErrorFlushbar(BuildContext context, String message) {
  Flushbar(
    messageText: Text(
      message,
      style: const TextStyle(color: Colors.white, fontSize: 16),
    ),
    icon: const Icon(
      Icons.error,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: Colors.red,
    borderRadius: BorderRadius.circular(8),
    margin: const EdgeInsets.all(8),
  ).show(context);
}