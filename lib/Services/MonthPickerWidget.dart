import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MonthPickerWidget extends StatefulWidget {
  final Function(String) onMonthSelected;

  const MonthPickerWidget({super.key, required this.onMonthSelected});

  @override
  _MonthPickerWidgetState createState() => _MonthPickerWidgetState();
}

class _MonthPickerWidgetState extends State<MonthPickerWidget> {
  late String _selectedMonth;
  
  
  final Map<String, String> monthTranslations = {
    'January':' 1/${DateFormat.y().format(DateTime.now())} (ינואר)',
    'February':' 2/${DateFormat.y().format(DateTime.now())} (פברואר)',
    'March': ' 3/${DateFormat.y().format(DateTime.now())} (מרץ)',
    'April': ' 4/${DateFormat.y().format(DateTime.now())} (אפריל)',
    'May': ' 5/${DateFormat.y().format(DateTime.now())} (מאי)',
    'June': '6/${DateFormat.y().format(DateTime.now())} (יוני)',
    'July': ' 7/${DateFormat.y().format(DateTime.now())} (יולי)',
    'August': ' 8/${DateFormat.y().format(DateTime.now())} (אוגוסט)',
    'September': ' 9/${DateFormat.y().format(DateTime.now())} (ספטמבר)',
    'October': ' 10/${DateFormat.y().format(DateTime.now())} (אוקטובר)',
    'November': ' 11/${DateFormat.y().format(DateTime.now())} (נובמבר)',
    'December': ' 12/${DateFormat.y().format(DateTime.now())} (דצמבר)',
  };

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _selectedMonth = DateFormat.MMMM().format(now);
  }

  @override
  Widget build(BuildContext context) {
    List<String> months = MonthProvider.getMonths();

    return DropdownButton<String>(
      value: _selectedMonth,
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
