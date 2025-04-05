import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final TextEditingController studentIdController = TextEditingController();
  String predictionResult = "";

  Future<void> predict() async {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/predict/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"student_id": int.parse(studentIdController.text)}),
    );

    if (response.statusCode == 200) {
      setState(() {
        predictionResult = jsonDecode(response.body)["prediction"];
      });
    } else {
      setState(() {
        predictionResult = "Error retrieving prediction.";
      });
    }
  }

  Future<void> uploadCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions: ['csv']);
    if (result != null) {
      File file = File(result.files.single.path!);
      var request = http.MultipartRequest("POST", Uri.parse("http://127.0.0.1:8000/retrain/"));
      request.files.add(await http.MultipartFile.fromPath("file", file.path));
      var res = await request.send();
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Model retrained successfully!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Retraining failed!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Prediction Model"), backgroundColor: Colors.red),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: studentIdController,
              decoration: InputDecoration(labelText: "Enter Student ID"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: predict,
              child: Text("Predict"),
            ),
            SizedBox(height: 20),
            Text("Prediction: $predictionResult", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: uploadCSV,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Retrain Model', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
