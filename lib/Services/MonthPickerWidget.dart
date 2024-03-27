import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthPickerWidget extends StatefulWidget {
  final Function(String) onMonthSelected;

  const MonthPickerWidget({super.key, required this.onMonthSelected});

  @override
  _MonthPickerWidgetState createState() => _MonthPickerWidgetState();
}

class _MonthPickerWidgetState extends State<MonthPickerWidget> {
  String _selectedMonth = '';
  
  final Map<String, String> monthTranslations = {
    'January': ' 01 ינואר',
    'February': ' 02 פברואר',
    'March': ' 03 מרץ',
    'April': ' 04 אפריל',
    'May': ' 05 מאי',
    'June': ' 06 יוני',
    'July': ' 07 יולי',
    'August': ' 08 אוגוסט',
    'September': ' 09 ספטמבר',
    'October': ' 10 אוקטובר',
    'November': ' 11 נובמבר',
    'December': ' 12 דצמבר',
  };

  @override
  Widget build(BuildContext context) {
    List<String> months = MonthProvider.getMonths();

    return DropdownButton<String>(
      hint: const Text(' בחר עד איזה חודש '),
      value: _selectedMonth.isEmpty ? null : _selectedMonth,
      onChanged: (String? newValue) {
        setState(() {
          _selectedMonth = newValue!;
          widget.onMonthSelected(newValue);
        });
      },
      items: months.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(monthTranslations[value] ?? value), 
        );
      }).toList(),
    );
  }
}

class MonthProvider {
  static List<String> getMonths() {
    DateTime now = DateTime.now();
    List<String> months = [];

    for (int i = now.month; i <= 12; i++) {
      String month = DateFormat.MMMM().format(DateTime(now.year, i));
      months.add(month);
    }

    return months;
  }
}
