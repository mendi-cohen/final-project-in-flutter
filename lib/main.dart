import 'package:flutter/material.dart';
import 'EnterUsers/EnterPage.dart';
import 'Services/Notification.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



 void  main () async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await dotenv.load(); 


  
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
