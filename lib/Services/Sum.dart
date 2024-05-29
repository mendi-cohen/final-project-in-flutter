import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class All {
  static Widget buildTotalIncome(List<dynamic> dataList , String totalText , String value , Color color) {
    double totalIncome = 0;

    for (var data in dataList) {
      totalIncome += double.parse(data['$value']);
    }

    String formattedSum = NumberFormat('#,###').format(totalIncome);

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50), 
      ),
      width: 380,
      height: 50,
      alignment: Alignment.center,
      child: Text(
        '$totalText: $formattedSum ש"ח',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }


static Widget buildTotalMaaser(List<dynamic> dataList, String totalText, String value, Color color) {
  double totalIncome = 0;

  for (var data in dataList) {
    totalIncome += double.parse(data[value]);
  }

  String displayText;
    String formattedSum = NumberFormat('#,###').format(totalIncome.abs());

  if (totalIncome == 0) {
    displayText = ' אין משרות נוספות הפרשת הכל כדין ($formattedSum)' ;
  } else if (totalIncome < 0){
    displayText = ' הפרשת מעשרות מעל ומעבר כל הכבוד! ($formattedSum) ';
  }
  else{
    displayText = '$totalText: $formattedSum ש"ח';
  }

  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(50),
    ),
    width: 380,
    height: 50,
    alignment: Alignment.center,
    child: Text(
      displayText,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    ),
  );
}










}
