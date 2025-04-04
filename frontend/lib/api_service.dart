import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';  // Added for Colors
import 'package:flutter/foundation.dart'; // Added for debugPrint

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:5000';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Single prediction
  Future<String?> predict(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/predict'),
        body: json.encode(data),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['prediction'];
      } else {
        _showError('Prediction failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _showError('Prediction error: ${e.toString()}');
      return null;
    }
  }

  // Batch prediction
  Future<bool> uploadCSV() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null || result.files.single.path == null) {
        _showError('No file selected');
        return false;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/predict_batch'),
      );
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        result.files.single.path!,
      ));

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        _showSuccess('Batch prediction complete!');
        return true;
      } else {
        _showError('Batch prediction failed: ${json.decode(responseBody)['error']}');
        return false;
      }
    } catch (e) {
      _showError('Upload error: ${e.toString()}');
      return false;
    }
  }

  // Model retraining
  Future<bool> retrainModel() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null || result.files.single.path == null) {
        _showError('No file selected');
        return false;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/retrain'),
      );
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        result.files.single.path!,
      ));

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        _showSuccess('Model retrained successfully!');
        return true;
      } else {
        _showError('Retraining failed: ${json.decode(responseBody)['error']}');
        return false;
      }
    } catch (e) {
      _showError('Retraining error: ${e.toString()}');
      return false;
    }
  }

  // Helper methods
  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
    );
    debugPrint(message);
  }

  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.green,
    );
  }
}