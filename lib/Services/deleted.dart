// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Dialog.dart';

DateTime now =  DateTime.now();
Future<void> deleteObject(String ObjectId, String path, BuildContext context ,Function DEL ,
 Function ?  onSuccess , String ? type ) async {
  try {
    String url = '${dotenv.env['PATH']}/$path/remove/$ObjectId';
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
  String ? type;
  String ? time; 
 

   DelWidget({
    super.key,
    required this.ObjectId,
    required this.path,
    required this.DEL,
    this.onSuccess,
    this.type,
    this.time,
    


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
                if (time != null) {
                  DateTime createdAt = DateTime.parse(time!);
                if (createdAt.month == now.month && createdAt.year == now.year) {
                    deleteObject(ObjectId, path, context, DEL, onSuccess, type);
                }}
                else{
                 _updateTypeAndDelete(context);
                }
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
void _updateTypeAndDelete(BuildContext context) async {
  try {
 
    String url = '${dotenv.env['PATH']}/$path/updateType/$ObjectId';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
       body: jsonEncode({"newType": path == 'charidy' ? "חד פעמי" : "חד פעמית" }),
    );

    if (response.statusCode == 200) {
      print("success: עודכן בהצלחה");
      await DEL();

    } else {
      DialogService.showMessageDialog(context, "אופס!", "אירעה שגיאה בעדכון הנתונים", Colors.red);
    }
  } catch (error) {
    print('שגיאה בעדכון הטייפ לחד פעמי: $error');
    DialogService.showMessageDialog(context, "שגיאה", "אירעה שגיאה בלתי צפויה", Colors.red);
  }
}

}



 