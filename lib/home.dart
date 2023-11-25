import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quiz.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

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
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to MCQ App!',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
            const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white, // Set the background color to white
            ),
            child: const Text(
              'Start Game',
              style: TextStyle(fontSize: 20, color: Colors.blueGrey),
            ),
          ),
            const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Close the app
            SystemNavigator.pop();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // Set the background color to white
          ),
          child: const Text(
            'Exit App',
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
        ),
          ],
        ),
      ),
    );
  }
}