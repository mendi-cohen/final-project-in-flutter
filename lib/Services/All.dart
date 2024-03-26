import 'package:flutter/material.dart';

class All {
  static Widget buildTotalIncome(List<dynamic> dataList , String totalText , String value ) {
    double totalIncome = 0;
    for (var data in dataList) {
      totalIncome += double.parse(data['$value']);
    }
    return Container(
      color: const Color.fromARGB(255, 195, 215, 232),
      width: 300,
      height: 50,
      alignment: Alignment.center,
      child: Text(
        '$totalText: ${totalIncome.toStringAsFixed(2)}',
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
