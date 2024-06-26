// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Dialog.dart';

Future<void> deleteObject(String ObjectId, String path, BuildContext context ,Function DEL , Function ?  onSuccess) async {
  try {
    String url = '${dotenv.env['PATH']}/${dotenv.env['PATH']}/remove/$ObjectId';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      DialogService.showMessageDialog(context,"הצלחה" , "הנתונים הוסרו בהצלחה", Colors.green );
      DEL();
       if (onSuccess != null) {
        onSuccess();
      }
    } else {
      DialogService.showMessageDialog(context,"אופס!" , " אירעה שגיאה במחיקת הנתונים ", Colors.red);
    }
  } catch (error) {
    print('שגיאה במחיקת האובייקט: $error');
  }
}

class DelWidget extends StatelessWidget {
  final String ObjectId;
  final String path;
  Function DEL;
  Function ? onSuccess ;

   DelWidget({
    super.key,
    required this.ObjectId,
    required this.path,
    required this.DEL,
    this.onSuccess,


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
                Navigator.of(context).pop(); 
                deleteObject(ObjectId, path, context , DEL , onSuccess);
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
