import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'answers.dart';

class Question {
  int id;
  String questionText;
  List<Map<String, Object>> answers;

  Question(this.id, this.questionText, this.answers);

  @override
  String toString() {
    return """ 
    Id: $id
    Question: $questionText
    """;
  }
}

class ShowQuestions extends StatefulWidget {
  const ShowQuestions({Key? key}) : super(key: key);

  @override
  State<ShowQuestions> createState() => _ShowQuestionsState();
}

class _ShowQuestionsState extends State<ShowQuestions> {
  late List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  int _totalScore = 0;
  bool isCompleted = false;
  int _timerSeconds = 15;
  late Timer _timer = Timer(Duration.zero, () {});
  int get questionNb =>  _currentQuestionIndex +1;
  late double percentage = _totalScore / _questions.length;
  bool _revealAnswer=false;
  bool _isPressed = false;
  int _pressedButtonIndex = -1;


  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final response = await http.get(Uri.parse('https://scoutquizapp.000webhostapp.com/getAllQuestions.php'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse is List && jsonResponse.isNotEmpty) {
        setState(() {
          _questions = jsonResponse.cast<Map<String, dynamic>>();
        });

      } else {
        throw FormatException('Invalid JSON format');
      }
      _startTimer();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  void _handleAnswer(bool isCorrect) {
    setState(() {
      _revealAnswer = true;
      _isPressed = true;
    });
    _timer.cancel();
    if (isCorrect) {
      setState(() {
        _totalScore++;
        print(_totalScore);
      });
    }
  }

  void moveToNextQuestion(){
    _pressedButtonIndex = -1;
    _isPressed = false;
    _revealAnswer = false;
    _timer.cancel();
    _timerSeconds = 15;

    // Move to the next question
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _startTimer();
      } else {
        isCompleted = true;
      }
      
    });

  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _handleAnswer(false);
          _isPressed = true;
        }
      });
    });
  }

  String _rating() {
    String _ratingText = '';

    if (percentage >= 0.5 && percentage < 0.6) {
      _ratingText = 'Not Good';
    } else if (percentage >= 0.6 && percentage < 0.7) {
      _ratingText = 'You Can Do Better';
    } else if (percentage >= 0.7 && percentage < 0.8) {
      _ratingText = 'Not Bad';
    } else if (percentage >= 0.8 && percentage < 0.9) {
      _ratingText = 'Good';
    } else if (percentage >= 0.9) {
      _ratingText = 'Fantastic';
    }

    return _ratingText;
  }

  String _ratingIcon() {
    String _ratingImage = '';

    if (percentage >= 0 && percentage < 0.6) {
      _ratingImage = 'assets/not_good.png';
    } else if (percentage >= 0.6 && percentage < 0.7) {
      _ratingImage = 'assets/do_better.png';
    } else if (percentage >= 0.7 && percentage < 0.8) {
      _ratingImage = 'assets/Not_bad.png';
    } else if (percentage >= 0.8 && percentage < 0.9) {
      _ratingImage = 'assets/good.png';
    } else if (percentage >= 0.9) {
      _ratingImage = 'assets/fantastic.png';
    }

    return _ratingImage;
  }


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scout Quiz Questions'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: _questions.isNotEmpty
          ? Center(
        child: !isCompleted?Card(
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Question: $questionNb',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.purple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    'Time left: $_timerSeconds seconds',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    '${_questions[_currentQuestionIndex]['questionText']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.purple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: (_questions[_currentQuestionIndex]['answers'] as List<dynamic>)
                      .map(
                        (answer) => ElevatedButton(
                          onPressed: _isPressed?null:(){
                            _pressedButtonIndex = _questions[_currentQuestionIndex]['answers']
                                .indexOf(answer);
                            _handleAnswer(answer['isCorrect'] as bool);
                          },
                          style: ElevatedButton.styleFrom(
                            onSurface: (_revealAnswer && answer['isCorrect']
                                ? Colors.green
                                : (_revealAnswer && !answer['isCorrect'] ? Colors.red : Colors.purple)),
                            primary:  _revealAnswer&&answer['isCorrect']?Colors.green:_revealAnswer&&!answer['isCorrect']?Colors.red:Colors.purple,
                            side: BorderSide(
                              color: _pressedButtonIndex ==
                                  _questions[_currentQuestionIndex]['answers'].indexOf(answer)
                                  ? Colors.grey
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                            minimumSize: Size(double.infinity, 40),
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: Text(
                            answer['text'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                  )
                      .toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: !_isPressed?null:(){
                    moveToNextQuestion();
                  },
                    child: Text( 'Next',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  style: ElevatedButton.styleFrom(
                    onSurface: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                )
              ],
            ),
          ),
        ):Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz completed! Total Score: $_totalScore',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              _rating(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.purple),
            ),
            const SizedBox(height: 20),
            Image.asset(_ratingIcon()),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 5; i++)
                  Icon(
                    i < percentage*5
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.purple,
                    size: 50,
                  ),
              ],
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ShowQuestions()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Restart Quiz', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ShowAnswers()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Answers', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Main Page', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      )
          : Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Circular(),

        ),
      ),
    );
  }
}
class Circular extends StatelessWidget {
  const Circular({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
          strokeWidth: 6.0,
        ),
      ),
    );
  }
}
