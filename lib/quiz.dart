import 'package:flutter/material.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MCQ Quiz'),
        centerTitle: true,
      ),
      body: Center(
        child: const Text('This is the quiz page!'), // Replace with your quiz UI

      ),
    );
  }
}