import 'package:flutter/material.dart';

class DialogService {
  static Future<void> showMessageDialog(BuildContext context, String title, String message  , Color color) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          backgroundColor: color,
          title: Center(child: Text(style: const TextStyle(fontWeight: FontWeight.bold), '$title !')),
          content: Text(style: const TextStyle(fontSize: 20),message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(style: TextStyle(fontSize: 18), 'אישור'),
            ),
          ],
        );
      },
    );
  }
}
