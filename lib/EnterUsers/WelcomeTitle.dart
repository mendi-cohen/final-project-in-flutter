// ignore_for_file: use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';

class WelcomeTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent, // צבע רקע
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20.0)), // פינות מעוגלות
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // צבע הצל
            spreadRadius: 3, // התפשטות הצל
            blurRadius: 5, // איכות הצל
            offset:const Offset(0, 3), // היסט הצל
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ברוך הבא למועדון הגדולים',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white, // צבע טקסט
              fontSize: 30.0, // גודל טקסט
              fontWeight: FontWeight.bold, // עובי הטקסט
              letterSpacing: 1.5, // מרווח בין אותיות
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5), // צבע הצל
                  blurRadius: 2, // איכות הצל
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'כמה נשמח שתצטרף למשפחה',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white, // צבע טקסט
              fontSize: 24.0, // גודל טקסט
              fontStyle: FontStyle.italic, // סגנון טקסט
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5), // צבע הצל
                  blurRadius: 2, // איכות הצל
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
