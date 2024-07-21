import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Marks Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _numberCoursesController = TextEditingController();
  final TextEditingController _timeStudyController = TextEditingController();
  String _result = '';

  Future<void> _predictMarks() async {
    final url = Uri.parse('https://linear-regression-model-s9vy.onrender.com/predict');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'number_courses': int.parse(_numberCoursesController.text),
        'time_study': double.parse(_timeStudyController.text),
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      setState(() {
        _result = responseData['predicted marks'].toString();
      });
    } else {
      setState(() {
        _result = 'Error: Unable to predict marks';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Marks Predictor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _numberCoursesController,
              decoration: InputDecoration(labelText: 'Number of Courses'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _timeStudyController,
              decoration: InputDecoration(labelText: 'Time Studied (hours)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predictMarks,
              child: Text('Predict Marks'),
            ),
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
