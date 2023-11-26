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
        title: const Text('MCQ Scout App',style: TextStyle(fontSize: 25, color: Colors.white), ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/scoutwidget.png',
              width: 250,
              height: 250,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to the Scout Quiz!',
              style: TextStyle(fontSize: 25, color: Colors.purple),
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
            backgroundColor: Colors.purple,
            fixedSize: Size(220, 80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
            child: const Text(
              'Start Game',
              style: TextStyle(fontSize: 26, color: Colors.white),
            ),
          ),
            const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            fixedSize: Size(220, 80),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),

          child: const Text(
            'Exit App',
            style: TextStyle(fontSize: 26, color: Colors.white),
          ),
        ),
          ],
        ),
      ),
    );
  }
}