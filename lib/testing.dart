import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

String _baseURL = 'https://scoutquizapp.000webhostapp.com';

class Question {
  int id;
  String questionText;
  int questionId;
  String answerText;
  bool isCorrect;

  Question({
    required this.id,
    required this.questionText,
    required this.questionId,
    required this.answerText,
    required this.isCorrect,
  });

  @override
  String toString() {
    return """ 
    Id: $id
    Question: $questionText
    answer: $answerText
    Correct: $isCorrect
    """;
  }
}

List<Question> questions = [];

void getQuestions(Function(bool success) update) async {
  try {
    final url = Uri.parse('$_baseURL/getQuestions.php');
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    questions.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        Question q = Question(
          id: int.parse(row['id']),
          questionText: row['questionText'],
          questionId: int.parse(row['questionId']),
          answerText: row['answerText'],
          isCorrect: row['isCorrect'] == '1', // Convert string to boolean
        );
        questions.add(q);
      }
      update(true);
    }
  } catch (e) {
    update(false);
  }
}

class ShowQuestions extends StatelessWidget {
  const ShowQuestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                color: index % 2 == 0 ? Colors.blue[50] : Colors.blue[100],
                padding: EdgeInsets.all(5),
                width: width * 0.9,
                child: Row(
                  children: [
                    SizedBox(width: width * 0.15),
                    Text(
                      questions[index].toString(),
                      style: TextStyle(fontSize: width * 0.45),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}

