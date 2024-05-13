import 'package:localstorage/localstorage.dart';
import 'package:flutter/material.dart';
import './Dialog.dart';

class TokenManager {
  static void scheduleTokenDeletion() {
    Future.delayed(const Duration(minutes: 5), () {
      localStorage.removeItem('Token');
    });
  }

  static void checkToken(context , Function() elseCallback) {
    var token = localStorage.getItem('Token');
    if (token != null) {
      elseCallback();
      
    }else {
        DialogService.sendToTakeNewToken(context, 'אופס',
          'לא ניתן לבצע את הפעולה עליך להתחבר מחדש!', Colors.red);
    }
  }
}
