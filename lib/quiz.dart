import 'package:flutter/material.dart';
import 'dart:async';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, Object>> _questions = [
    {
      'questionText': 'What is the capital of France?',
      'answers': [
        {'text': 'Berlin', 'isCorrect': false},
        {'text': 'Paris', 'isCorrect': true},
        {'text': 'Madrid', 'isCorrect': false},
        {'text': 'Rome', 'isCorrect': false},
      ],
    },
    {
      'questionText': 'Which programming language is Flutter based on?',
      'answers': [
        {'text': 'Java', 'isCorrect': false},
        {'text': 'Dart', 'isCorrect': true},
        {'text': 'Swift', 'isCorrect': false},
        {'text': 'Kotlin', 'isCorrect': false},
      ],
    },
    {
      'questionText': 'What is the largest planet in our solar system?',
      'answers': [
        {'text': 'Earth', 'isCorrect': false},
        {'text': 'Jupiter', 'isCorrect': true},
        {'text': 'Mars', 'isCorrect': false},
        {'text': 'Saturn', 'isCorrect': false},
      ],
    },
    {
      'questionText': 'In which year did the Titanic sink?',
      'answers': [
        {'text': '1905', 'isCorrect': false},
        {'text': '1912', 'isCorrect': true},
        {'text': '1920', 'isCorrect': false},
        {'text': '1935', 'isCorrect': false},
      ],
    },
    {
      'questionText': 'Who wrote "Romeo and Juliet"?',
      'answers': [
        {'text': 'Charles Dickens', 'isCorrect': false},
        {'text': 'William Shakespeare', 'isCorrect': true},
        {'text': 'Jane Austen', 'isCorrect': false},
        {'text': 'Mark Twain', 'isCorrect': false},
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
      ),
      body: _questionIndex < _questions.length
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Time left: $_timerSeconds seconds'),
          const SizedBox(height: 20),

          Center(
            child: Text(
              _questions[_questionIndex]['questionText'] as String,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),

          ...(_questions[_questionIndex]['answers'] as List<Map<String, Object>>).map((answer) {
            return ElevatedButton(
              onPressed: () {
                _answerQuestion(answer['isCorrect'] as bool);
              },
              child: Text(answer['text'] as String),
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
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              child: const Text('Restart Quiz'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Main Page'),
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
