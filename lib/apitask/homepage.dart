import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'model.dart';

class HomeTabPage extends StatefulWidget {
  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  late List<Datum> _dataList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse("https://reqres.in/api/users?page=1"));
    if (response.statusCode == 200) {
      final dataSample = DataSample.fromJson(json.decode(response.body));
      setState(() {
        _dataList = dataSample.data;
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _dataList.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreenAccent,
          title: Center(child: Text('Tabs', style: TextStyle(color: Colors.orange))),
          bottom: TabBar(
            indicatorColor: Colors.orange,
            indicatorWeight: 4,
            labelStyle: TextStyle(color: Colors.cyanAccent),
            tabs: _dataList.map((datum) => Tab(text: datum.firstName)).toList(),
          ),
        ),
        body: TabBarView(
          children: _dataList.map((datum) {
            return Container(
              color: Colors.lightGreenAccent,
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.network(
                      datum.avatar,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('ID: ${datum.id}'),
                  Text('Email: ${datum.email}'),
                  Text('First Name: ${datum.firstName}'),
                  Text('Last Name: ${datum.lastName}'),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
