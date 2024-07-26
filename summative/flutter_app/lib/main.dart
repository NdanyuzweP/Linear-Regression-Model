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
        primarySwatch: Colors.grey,
        brightness: Brightness.dark, // Use dark theme
        scaffoldBackgroundColor: Colors.black, // Set background color to black
        textTheme: TextTheme(
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.grey), // Set input label color to grey
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
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
    final url = Uri.parse('http://127.0.0.1:8000/predict');
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
        _result = responseData['predicted_marks'].toString();
      });
      _showResultDialog(_result);
    } else {
      setState(() {
        _result = 'Error: Unable to predict marks';
      });
      _showResultDialog(_result);
    }
  }

  void _showResultDialog(String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900], // Set dialog background color
          title: Text('Prediction Result', style: TextStyle(color: Colors.white)),
          content: Text(result, style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Marks Predictor'),
        backgroundColor: Colors.grey[850], // Set app bar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center-align the contents
          children: <Widget>[
            TextField(
              controller: _numberCoursesController,
              decoration: InputDecoration(labelText: 'Number of Courses'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _timeStudyController,
              decoration: InputDecoration(labelText: 'Time Studied (hours)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predictMarks,
              style: ElevatedButton.styleFrom(
              ),
              child: Text('Predict Marks'),
            ),
            SizedBox(height: 20),
            if (_result.isNotEmpty)
              Text(
                _result,
                style: TextStyle(fontSize: 24, color: Colors.grey),
                textAlign: TextAlign.center, // Center-align the text
              ),
          ],
        ),
      ),
    );
  }
}
