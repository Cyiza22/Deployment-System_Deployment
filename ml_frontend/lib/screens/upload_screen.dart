import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
    
    if (result != null) {
      Fluttertoast.showToast(msg: "File selected: ${result.files.single.name}");
      //  Upload the file to backend API
    } else {
      Fluttertoast.showToast(msg: "No file selected.");
    }
  }

  void _retrainModel() {
    // Call API to trigger retraining
    Fluttertoast.showToast(msg: "Retraining model...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Data")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text("Select CSV File"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _retrainModel,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Retrain Model', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
