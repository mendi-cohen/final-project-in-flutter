import 'package:flutter/material.dart';
import 'package:finalproject/Services/Notification.dart';
import 'package:intl/intl.dart';

class AllTuether {
  static String addCommasToNumber(double number) {
    return NumberFormat('#,###').format(number);
  }

  static Widget buildTotalAccount(List<dynamic> incomeList ,List<dynamic> poolList , List<dynamic> charidyList) {
    double totalIncome = 0;
    double totalPool = 0;
    double totalCharidy = 0;
    bool isFirstAppLaunch = true;

    for (var data in incomeList) {
      totalIncome += double.parse(data['income_value']);
    }
    
    for (var data in poolList) {
      totalPool += double.parse(data['pool_value']);
    }
    for (var data in charidyList) {
      totalCharidy += double.parse(data['charidy_value']);
    }

    double accountStatus = totalIncome - totalPool - totalCharidy;
    double tenPercent = totalIncome * 0.1;

    if (accountStatus < 0 && isFirstAppLaunch) {
      NotificationService().showNotification(
        title: 'אופס יש לנו בעיה',
        body: 'מצב החשבון: ${accountStatus.toStringAsFixed(1)}'
      );
      isFirstAppLaunch = false;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.0),
      ),
      width: 350,
      height: 100,
      alignment: Alignment.center,
      child: Center(
        child: Text(
          'מצב חשבונך הוא: ${addCommasToNumber(accountStatus)} ש"ח                                       ( סה"כ מעשרות : ${addCommasToNumber(tenPercent)} ש"ח  )',
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
