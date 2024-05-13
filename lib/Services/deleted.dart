import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> deleteCharidy(String ObjectId, String path, BuildContext context) async {
  try {
    String url = 'http://10.0.2.2:3007/$path/remove/$ObjectId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('האובייקט נמחק בהצלחה');
    } else {
      print('שגיאה במחיקת האובייקט: ${response.statusCode}');
    }
  } catch (error) {
    print('שגיאה במחיקת האובייקט: $error');
  }
}

class DelWidget extends StatelessWidget {
  final String ObjectId;
  final String path;

  const DelWidget({
    super.key,
    required this.ObjectId,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        _showDeleteConfirmationDialog(context);
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(' האם אתה בטוח שברצונך למחוק את הפעולה?'),
          actions: <Widget>[
            TextButton(
              child: const Text( style: TextStyle(fontSize: 20), 'כן'),
              onPressed: () {
                deleteCharidy(ObjectId, path, context);
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text( style: TextStyle(fontSize: 20), 'לא'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
          ],
        );
      },
    );
  }
}
