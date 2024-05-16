import 'package:flutter/material.dart';

class All {
  static Widget buildTotalIncome(List<dynamic> dataList , String totalText , String value , Color color) {
    double totalIncome = 0;
    for (var data in dataList) {
      totalIncome += double.parse(data['$value']);
    }
    return Container(
   decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20), 
      ),
      width: 380,
      height: 50,
      alignment: Alignment.center,
      child: Text(
        '$totalText: ${totalIncome.toStringAsFixed(2)} ש"ח',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 17,
          
        ),
        
      ),
      
    );
  }


  
}
