import 'package:flutter/material.dart';
import 'EnterUsers/EnterPage.dart';
import 'Services/Notification.dart';
import 'Services/Notification.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, child) => Directionality(
            textDirection: TextDirection.rtl, child: Material(child: child!)),
        home: const EnterPage());
        
  }
}
