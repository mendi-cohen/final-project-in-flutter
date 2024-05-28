import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import './Sum.dart';
import'./deleted.dart';

class DataSearchWidget extends StatefulWidget {
  final String apiUrl;
  final String type;
  final String sum;
  final String resion;
  final String title;
  final String img;
  final String wigetTitle;
  final Color color;
  final String text;
  final String DelPath;

  const DataSearchWidget(
      {super.key,
      required this.apiUrl,
      required this.type,
      required this.sum,
      required this.resion,
      required this.title,
      required this.img,
      required this.wigetTitle,
      required this.color,
      required this.text,
      required this.DelPath,
      });

  @override
  _DataSearchWidgetState createState() => _DataSearchWidgetState();
}

class _DataSearchWidgetState extends State<DataSearchWidget> {
  List<dynamic> dataList = [];
  List<dynamic> filteredDataList = [];
  TextEditingController searchController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchData();
    searchController.addListener(_filterData);
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse(widget.apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        dataList = jsonDecode(response.body)[widget.type];
        filteredDataList = dataList;
      });
    }
  }

  void _filterData() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredDataList = dataList.where((item) {
        String source = item['source'].toLowerCase();
        String value = item['income_value'].toString().toLowerCase();
        String date =
            DateFormat('dd/MM/yyyy').format(DateTime.parse(item['createdAt']));
        bool isDateQuery = RegExp(r'\d{2}/\d{2}/\d{4}').hasMatch(query);
        if (isDateQuery) {
          return date.contains(query);
        } else {
          return source.contains(query) || value.contains(query);
        }
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        filteredDataList = dataList.where((item) {
          String date = DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(item['createdAt']));
          return date == DateFormat('dd/MM/yyyy').format(pickedDate);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.wigetTitle}  ${DateFormat.y().format(DateTime.now())}',
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.img),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _showDatePicker(context),
                          ),
                          hintText: 'חפש...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              All.buildTotalIncome(
                  filteredDataList, widget.text, widget.sum, widget.color),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: filteredDataList.isEmpty
                    ? const Center(
                        child: Text(
                          'לא נמצאו תוצאות',
                          style: TextStyle(
                              fontSize: 45, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredDataList.length,
                        itemBuilder: (context, index) {
                          int reversedIndex =
                              filteredDataList.length - 1 - index;
                          String formattedSum = NumberFormat('#,###').format(int.parse(filteredDataList[reversedIndex][widget.sum]));
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(
                                filteredDataList[reversedIndex]['createdAt']),
                          );
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(20),
                              title: Text(
                                'סכום: $formattedSum ש"ח',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'מקור: ${filteredDataList[reversedIndex][widget.resion]}',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ' ${widget.title}: $formattedDate',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                               trailing: DelWidget(
                                ObjectId: dataList[reversedIndex]['id'].toString(),
                                path: widget.DelPath,
                                DEL: _fetchData,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
