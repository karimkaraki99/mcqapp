import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

const String _baseURL = 'scoutquizapp.000webhostapp.com';
class Question {
  int _id;
  String _question;
  Question(this._id,this._question);

  @override
  String toString() {
    return """ 
    Id: $_id
    Question: $_question
    """;
  }
}
List<Question> _questions =[];

void getAllQuestions() async{
  try{
    final url = Uri.https(_baseURL,'getAllQuestions.php');
    final response = await http.get(url)
        .timeout(const Duration(seconds: 5));
    _questions.clear();
    if(response.statusCode==200){
      final jsonResponse = convert.jsonDecode(response.body);
      for( var row in jsonResponse ){
        Question q = Question(
          int.parse(row['id']),
          row['questionText'],
        );
        _questions.add(q);
      }
    }
  }
  catch(e){
  }
}
class showQuestions extends StatefulWidget {
  const showQuestions({super.key});

  @override
  State<showQuestions> createState() => _showQuestionsState();
}

class _showQuestionsState extends State<showQuestions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Column(
        children: [
          Text('test'),
          getAllQuestion()
               ],
             ),
           );
         }          
       }

class getAllQuestion extends StatefulWidget {
  const getAllQuestion({super.key});

  @override
  State<getAllQuestion> createState() => _getAllQuestionState();
}

class _getAllQuestionState extends State<getAllQuestion> {
  @override
  Widget build(BuildContext context) {
    return   ListView.builder(
        itemCount: _questions.length,
        itemBuilder: (context, index) => Column(children: [
          const SizedBox(height: 10),
          Container(
              color: index % 2 == 0 ? Colors.amber: Colors.cyan,
              child: Row(children: [
                Flexible(child: Text(_questions[index].toString(), style: TextStyle(color: Colors.black,fontSize: 50)))
              ]))
        ])
    );
  }
}


















