import 'dart:async';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, Object>> _questions = [
    {
      'questionText': 'What is the Scout Motto?',
      'answers': [
        {'text': 'Be Prepared', 'isCorrect': true},
        {'text': 'Do a Good Turn Daily', 'isCorrect': false},
        {'text': 'On My Honor', 'isCorrect': false},
        {'text': 'Courteous, Kind, Obedient', 'isCorrect': false},
      ],
    },
    {
      'questionText': 'Who founded the Boy Scouts of America?',
      'answers': [
        {'text': 'Baden-Powell', 'isCorrect': false},
        {'text': 'Daniel Carter Beard', 'isCorrect': false},
        {'text': 'Lord Robert Baden-Powell', 'isCorrect': true},
        {'text': 'William D. Boyce', 'isCorrect': false},
      ],
    },
    {
      'questionText': 'What is the highest rank in Boy Scouts of America?',
      'answers': [
        {'text': 'First Class', 'isCorrect': false},
        {'text': 'Life Scout', 'isCorrect': false},
        {'text': 'Eagle Scout', 'isCorrect': true},
        {'text': 'Star Scout', 'isCorrect': false},
      ],
    },
    {
      'questionText': 'What is the traditional method of starting a campfire in scouting?',
      'answers': [
        {'text': 'Lighter fluid', 'isCorrect': false},
        {'text': 'Matches', 'isCorrect': false},
        {'text': 'Fire starter cubes', 'isCorrect': false},
        {'text': 'Wood and friction (fire bow or fire plough)', 'isCorrect': true},
      ],
    },
    {
      'questionText': 'What is the name of the award given for completing a high-adventure base trek in Boy Scouts of America?',
      'answers': [
        {'text': 'Scouting Adventure Award', 'isCorrect': false},
        {'text': 'Eagle Scout Award', 'isCorrect': false},
        {'text': 'Summit Award', 'isCorrect': false},
        {'text': '50-Miler Award', 'isCorrect': true},
      ],
    },

  ];

  int _questionIndex = 0;
  int _totalScore = 0;
  int _timerSeconds = 15;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _shuffleAndSetQuestions();
  }

  void _shuffleAndSetQuestions() {
    _questions.shuffle();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _answerQuestion(false);
        }
      });
    });
  }

  void _answerQuestion(bool isCorrect) {
    if (isCorrect) {
      _totalScore++;
    }

    _timer.cancel();
    _timerSeconds = 15;

    setState(() {
      _questionIndex++;

      if (_questionIndex < _questions.length) {
        _shuffleAndSetQuestions();
      } else {
        print('Quiz completed! Total Score: $_totalScore');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MCQ Quiz'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.white,
      body: _questionIndex < _questions.length
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Time left: $_timerSeconds seconds',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              _questions[_questionIndex]['questionText'] as String,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ...(_questions[_questionIndex]['answers'] as List<Map<String, Object>>).map((answer) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  _answerQuestion(answer['isCorrect'] as bool);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(answer['text'] as String, style: TextStyle(fontSize: 16)),
              ),
            );
          }).toList(),
        ],
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz completed! Total Score: $_totalScore',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: Size(double.infinity, 50),
              ),
              child: const Text('Restart Quiz', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: Size(double.infinity, 50),
              ),
              child: const Text('Main Page', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
