import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HebrewDateWidget extends StatefulWidget {
  @override
  _HebrewDateWidgetState createState() => _HebrewDateWidgetState();
}

class _HebrewDateWidgetState extends State<HebrewDateWidget> {
  Future<List<Map<String, dynamic>>> _fetchHebrewDate() async {
    final url = Uri.parse(
        'https://www.hebcal.com/hebcal?cfg=json&v=1&maj=on&min=on&mod=on&nx=on&year=now&month=now&geo=city&city=IL-Jerusalem&lg=he&c=off');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<Map<String, dynamic>> items =
          List<Map<String, dynamic>>.from(jsonResponse['items']);

      // Filter items to include only those in the current month and exclude Shabbat and candle lighting entries
      final currentMonth = DateTime.now().month;
      final currentYear = DateTime.now().year;
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
        title: Text('תאריכים מיוחדים החודש '),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _fetchHebrewDate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            );
          } else {
            final items = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final translatedTitle = item['title'];
                final date = item['date'];

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(Icons.event),
                    title: Text(
                      translatedTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      date,
                      style:  const TextStyle(fontSize: 14),
                    ),
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
