import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(BloodRedApp());

class BloodRedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  String _prediction = '';

  // Controllers for all features
  final _ageController = TextEditingController();
  final _gradeController = TextEditingController();
  // Add controllers for other features...

  Future<void> _predict() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/predict'),
        body: json.encode({
          'Age at enrollment': _ageController.text,
          'Previous qualification (grade)': _gradeController.text,
          // Add all other features...
        }),
        headers: {'Content-Type': 'application/json'},
      );
      setState(() {
        _prediction = json.decode(response.body)['prediction'];
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Prediction failed: $e");
    }
  }

  Future<void> _uploadCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('http://10.0.2.2:5000/predict_batch')
      );
      request.files.add(await http.MultipartFile.fromPath(
        'file', 
        result.files.single.path!
      ));
      var response = await request.send();
      Fluttertoast.showToast(
        msg: "Batch prediction complete!",
        toastLength: Toast.LENGTH_LONG
      );
    }
  }

  Future<void> _retrainModel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('http://10.0.2.2:5000/retrain')
      );
      request.files.add(await http.MultipartFile.fromPath(
        'file', 
        result.files.single.path!
      ));
      var response = await request.send();
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Model retrained successfully!");
      } else {
        Fluttertoast.showToast(msg: "Retraining failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Dropout Predictor')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Prediction Form
            Card(
              color: Colors.red[50],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(labelText: 'Age at Enrollment'),
                    ),
                    TextFormField(
                      controller: _gradeController,
                      decoration: InputDecoration(labelText: 'Previous Grade'),
                    ),
                    // Add other feature fields...
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _predict,
                      child: Text('PREDICT', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[900],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Prediction Result
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('Prediction: $_prediction', 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),

            // Batch Prediction Button
            ElevatedButton(
              onPressed: _uploadCSV,
              child: Text('UPLOAD CSV FOR BATCH PREDICTION', 
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[800],
              ),
            ),

            // Retrain Button
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _retrainModel,
              child: Text('RETRAIN MODEL WITH NEW DATA', 
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}