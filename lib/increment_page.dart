// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'database_helper.dart';

class IncrementPage extends StatefulWidget {
  final String username;

  IncrementPage({required this.username});

  @override
  _IncrementPageState createState() => _IncrementPageState();
}

class _IncrementPageState extends State<IncrementPage> {
  int _value = 0;

  @override
  void initState() {
    super.initState();
    _loadUserValue();
  }

  Future<void> _loadUserValue() async {
    final value = await DatabaseHelper.instance.getUserValue(widget.username);
    setState(() {
      _value = value ?? 0;
    });
  }

  void _increment() async {
    setState(() {
      _value++;
    });
    await DatabaseHelper.instance.insertOrUpdateUser(widget.username, _value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${widget.username}'),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Value',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                child: Text(
                  '$_value',
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.teal.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _increment,
                child: Icon(Icons.add, size: 36),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade400,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(24),
                  elevation: 8,
                  shadowColor: Colors.teal.shade200,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
