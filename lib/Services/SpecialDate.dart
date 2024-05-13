
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HebrewDateWidget extends StatefulWidget {
  @override
  _HebrewDateWidgetState createState() => _HebrewDateWidgetState();
}

class _HebrewDateWidgetState extends State<HebrewDateWidget> {
  Future<Map<String, dynamic>> _fetchHebrewDate() async {
    final url = Uri.parse('https://www.hebcal.com/hebcal?cfg=json&v=1&maj=on&min=on&mod=on&nx=on&year=now&month=x&geo=geoname&geonameid=3448439');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to load Hebrew date');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchHebrewDate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final jsonResponse = snapshot.data;
          return ListView.builder(
            itemCount: jsonResponse?['items'].length,
            itemBuilder: (context, index) {
              final item = jsonResponse?['items'][index];
              return ListTile(
                title: Text(item['title']),
                subtitle: Text(item['date']),
              );
            },
          );
        }
      },
    );
  }
}