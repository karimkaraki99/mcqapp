
import 'package:flutter/material.dart';
import 'home.dart';
import 'quiz.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MCQ APP',
      home: Home() // calls the main page to display the application interface
    );
  }
}
