import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proejctmcq/quiz_page.dart';

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

class ShowAnswers extends StatefulWidget {
  const ShowAnswers({Key? key}) : super(key: key);

  @override
  State<ShowAnswers> createState() => _ShowAnswers();
}

class _ShowAnswers extends State<ShowAnswers> {
  late List<Map<String, dynamic>> _questions = [];

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
    } else {
      throw Exception('Failed to load questions');
    }
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
          ? Container(
        child: ListView.builder(
          itemCount: _questions.length,
          itemBuilder: (context, index) {
            final question = _questions[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Question: ${question['questionText']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Answers:'),
                  ),
                  Column(
                    children: (question['answers'] as List<dynamic>)
                        .map(
                          (answer) => ListTile(
                        title: Text(answer['text']),
                        subtitle: Text(
                          answer['isCorrect']
                              ? 'Correct Answer'
                              : 'Incorrect Answer',
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ],
              ),
            );
          },
        ),
      )
          : Circular()
    );
  }
}