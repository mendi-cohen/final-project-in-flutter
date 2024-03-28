import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailIncomeWidget extends StatelessWidget {
  final List<dynamic> dataList;

  const EmailIncomeWidget({Key? key, required this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final Email email = Email(
          body: _buildEmailBody(),
          subject: 'רשימת הכנסות חודשיות',
          recipients: ['mcrambam770@gmail.com'], 
        );

        await FlutterEmailSender.send(email);
      },
      child: Text('שלח רשימת הכנסות למייל'),
    );
  }

  String _buildEmailBody() {
    String emailBody = 'רשימת הכנסות:\n\n';
    for (var data in dataList) {
      emailBody += 'סכום ההכנסה: ${data['income_value']} ש"ח\n';
      emailBody += 'מקור ההכנסה: ${data['source']}\n';
      emailBody += 'תאריך ההכנסה: ${data['createdAt']}\n\n';
    }
    return emailBody;
  }
}
