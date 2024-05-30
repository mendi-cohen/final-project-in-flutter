import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import './Sum.dart';
import './deleted.dart';
import './pickcher.dart';

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
  final bool del;
  final bool? subject;
   final Map<String, dynamic> userData;

  const DataSearchWidget({
    super.key,
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
    required this.del,
    this.subject,
    required this.userData,
  });

  @override
  _DataSearchWidgetState createState() => _DataSearchWidgetState();
}

class _DataSearchWidgetState extends State<DataSearchWidget> {
  List<dynamic> dataList = [];
  Map<String, List<dynamic>> groupedData = {};
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
        _groupDataByMonth(dataList);
      });
    }
  }

  void _groupDataByMonth(List<dynamic> dataList) {
    groupedData.clear();
    for (var item in dataList) {
      String monthYear =
          DateFormat('MM/yyyy').format(DateTime.parse(item['createdAt']));
      if (!groupedData.containsKey(monthYear)) {
        groupedData[monthYear] = [];
      }
      groupedData[monthYear]!.add(item);
    }
    _filterData();
  }

  void _filterData() {
    String query = searchController.text.toLowerCase();
    Map<String, List<dynamic>> filteredGroupedData = {};
    groupedData.forEach((monthYear, items) {
      var filteredItems = items.where((item) {
        String source = item[widget.resion].toLowerCase();
        String value = item[widget.sum].toString().toLowerCase();
        String date =
            DateFormat('dd/MM/yyyy').format(DateTime.parse(item['createdAt']));
        bool isDateQuery = RegExp(r'\d{2}/\d{2}/\d{4}').hasMatch(query);
        if (isDateQuery) {
          return date.contains(query);
        } else {
          return source.contains(query) || value.contains(query);
        }
      }).toList();
      if (filteredItems.isNotEmpty) {
        filteredGroupedData[monthYear] = filteredItems;
      }
    });
    setState(() {
      groupedData = filteredGroupedData;
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
        List<dynamic> filteredDataList = dataList.where((item) {
          String date = DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(item['createdAt']));
          return date == DateFormat('dd/MM/yyyy').format(pickedDate);
        }).toList();
        _groupDataByMonth(filteredDataList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> sortedKeys = groupedData.keys.toList()
      ..sort((a, b) => DateFormat('MM/yyyy')
          .parse(b)
          .compareTo(DateFormat('MM/yyyy').parse(a)));

    return Scaffold(
      appBar: AppBar(
        title: CircularImageSelectionWidget(text: widget.userData['user']['name'] ,)
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
  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
  child: Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Text(
      '${widget.wigetTitle}  ${DateFormat.y().format(DateTime.now())}',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: widget.color,
      ),
      textAlign: TextAlign.center,
    ),
  ),
),

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
                  dataList, widget.text, widget.sum, widget.color),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: groupedData.isEmpty
                    ? const Center(
                        child: Text(
                          'לא נמצאו תוצאות',
                          style: TextStyle(
                              fontSize: 45, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: sortedKeys.length,
                        itemBuilder: (context, index) {
                          String monthYear = sortedKeys[index];
                          List<dynamic> items = groupedData[monthYear]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: widget.color,
                                width: double.infinity,
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child:  Text(
                                  monthYear,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )),
                              ),
                              ...items.reversed.map((item) {
                                
                                String formattedSum = NumberFormat('#,###')
                                    .format(int.parse(item[widget.sum]));
                                String formattedDate = DateFormat('dd/MM/yyyy')
                                    .format(DateTime.parse(item['createdAt']));
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: 
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'מקור: ${item[widget.resion]}',
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          ' ${widget.title}: $formattedDate',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        const SizedBox(height: 8),

                                        if (widget.subject == true && item['type'] != 'חודשי קבוע' )
                                          Text(
                                            ' מועד אחרון לתרומה זו :  ${item['type']}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        if (widget.subject == true && item['type'] == 'חודשי קבוע' )
                                          const Text(
                                            'תרומה קבועה ללא הגבלה',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.red
                                            ),
                                          ),
                                      ],
                                    ),
                                    trailing: widget.del
                                        ? DelWidget(
                                            ObjectId: item['id'].toString(),
                                            path: widget.DelPath,
                                            DEL: _fetchData,
                                      
                                          )
                                        : null,
                                  ),
                                );
                              }).toList(),
                            ],
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
