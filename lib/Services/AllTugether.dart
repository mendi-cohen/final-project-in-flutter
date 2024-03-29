import 'package:flutter/material.dart';

class AllTuether {
  static Widget buildTotalAccount(List<dynamic> incomeList ,List<dynamic> poolList) {
    double totalIncome = 0;
    double totalPool = 0;
    for (var data in incomeList) {
      totalIncome += double.parse(data['income_value']);
      
    }
    for (var data in poolList) {
      totalPool += double.parse(data['pool_value']);
    }
    double accountStatus = totalIncome - totalPool;
     double tenPercent = totalIncome * 0.1;
    return Container(
      decoration: BoxDecoration(
           color: Colors.white.withOpacity(0.0),
      ),
      width: 350,
      height: 100,
      alignment: Alignment.center,
      child: Center(
        child: Text(
          'מצב חשבונך הוא: ${accountStatus.toStringAsFixed(1)}ש"ח     ( סה"כ מעשרות : ${tenPercent.toStringAsFixed(1)} ש"ח  )',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color:  Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
