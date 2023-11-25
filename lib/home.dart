
import 'package:flutter/material.dart';
import 'quiz.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: const Text('MCQ App'),
          centerTitle: true,
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Add some text or widgets if needed
            const Text(
              'Welcome to MCQ App!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20), // Add some spacing

            // Add the button to navigate to the quiz page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}

