import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../MainPage/charidy.dart';
import '../MainPage/CharidyTable.dart';
import '../MainPage/BottomNavigation.dart';

class HebrewDateWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  const HebrewDateWidget({Key? key, required this.userData}) : super(key: key);
  
  @override
  _HebrewDateWidgetState createState() => _HebrewDateWidgetState();
}

class _HebrewDateWidgetState extends State<HebrewDateWidget> {

  @override
  void initState() {
    super.initState();
   _fetchHebrewDate();
  }

  Future<List<Map<String, dynamic>>> _fetchHebrewDate() async {
    final url = Uri.parse(
        'https://www.hebcal.com/hebcal?cfg=json&v=1&maj=on&min=on&mod=on&nx=on&year=now&month=now&geo=city&city=IL-Jerusalem&lg=he&c=off');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> items =
          List<Map<String, dynamic>>.from(jsonResponse['items']);
      final currentMonth = DateTime.now().month;
      final currentYear = DateTime.now().year;
      final now = DateTime.now();
      items = items.where((item) {
        final itemDate = DateTime.parse(item['date']);
        final title = item['title'].toString().toLowerCase();
        return itemDate.month == currentMonth &&
            itemDate.year == currentYear &&
            !title.contains('הַדְלָקַת נֵרוֹת') &&
            !title.contains('הַבְדָּלָה') &&
            !title.contains('יוֹם הרצל') &&
            !title.contains('יוֹם הָעַצְמָאוּת');
      }).toList();

      return items;
    } else {
      throw Exception('Failed to load Hebrew date');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('תאריכים מיוחדים החודש '),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _fetchHebrewDate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            );
          } else {
            final items = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final translatedTitle = item['title'];
                final date = item['date'];
                final itemDate = DateTime.parse(item['date']);
                final now = DateTime.now();
                final isPastDate = itemDate.isBefore(now);

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: isPastDate ? Colors.red[100] : Colors.green[50],
                  child: ListTile(
                    leading: const Icon(Icons.event),
                    title: RichText(
                      text: TextSpan(
                        text: translatedTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isPastDate ? Colors.red : Colors.green,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: isPastDate ? ' - עבר זמנו בטל קורבנו' : '',
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(
                      date,
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: isPastDate
                        ? () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('עבר זמנו בטל קורבנו'),
                                  content: const Text(
                                      'התאריך הזה כבר עבר ולא ניתן לתרום בו כמובן אבל שתמיד אפשר ורצוי לקיים מצוות הצדקה בכל זמן ומקום !.'),
                                  actions: <Widget>[
                                 
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('אישור'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        : () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final selectedDate = item['title'];
                                return AlertDialog(
                                  title: Text('$selectedDate בחירה טובה ומעולה '),
                                  content: const Text(
                                      ' קדימה רוץ לקיים מצוות אלוקיך מתוך שמחה ותקבל כפליים ויותר בחזרה !! '),
                                  actions: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BottomNavigationDemo(
                                              userData: widget.userData,
                                              one: CharidyWidget(userData: widget.userData),
                                              two: HebrewDateWidget(userData: widget.userData),
                                              three: CharidyTableWidget(userData: widget.userData),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('אישור'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
