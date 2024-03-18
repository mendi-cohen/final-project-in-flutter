import 'package:flutter/material.dart';
class TitleForActions extends StatefulWidget {
  final String pageTitle;

  const TitleForActions({Key? key, required this.pageTitle}) : super(key: key);

  @override
  _TitleForActionsState createState() => _TitleForActionsState();
}

class _TitleForActionsState extends State<TitleForActions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue, // רקע כחול
          borderRadius: BorderRadius.circular(10), // קטן את פינות הקונטיינר
        ),
        child: Text(
          widget.pageTitle,
          style: TextStyle(
            color: Colors.white, // צבע טקסט לבן
            fontSize: 10, // גודל טקסט
            fontWeight: FontWeight.bold, // טקסט מודגש
          ),
        ),
      ),
    );
  }
}
