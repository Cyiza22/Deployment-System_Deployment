import 'package:flutter/material.dart';
import 'package:ml_frontend/screens/prediction_screen.dart';
import 'package:ml_frontend/screens/visualization_screen.dart';
import 'package:ml_frontend/screens/upload_screen.dart';

void main() {
  runApp(const StudentPredictionApp());
}

class StudentPredictionApp extends StatelessWidget {
  const StudentPredictionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Prediction Model',
      theme: ThemeData(
        primaryColor: Colors.red,
        colorScheme: ColorScheme.light(
          primary: Colors.red,
          secondary: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/predict': (context) => PredictionScreen(),
        '/upload': (context) => UploadScreen(),
        '/visualization': (context) => VisualizationScreen(),
      },
    );
  }
}
