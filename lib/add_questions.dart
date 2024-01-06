import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proejctmcq/show_answers.dart';

class AddQuestions extends StatefulWidget {
  const AddQuestions({Key? key}) : super(key: key);

  @override
  State<AddQuestions> createState() => _AddQuestionsState();
}

class _AddQuestionsState extends State<AddQuestions> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool locked = true;

  TextEditingController questionTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  List<TextEditingController> answerControllers = List.generate(4, (index) => TextEditingController());

  int correctAnswerIndex = -1;

  Future<void> _insertQuestionAndAnswers() async {
    final Uri apiUrl = Uri.parse('https://karim.hexacodes.org/addQuestions.php');

    final List<Map<String, dynamic>> answers = List.generate(
      4,
          (index) => {
        'answerText': answerControllers[index].text,
        'isCorrect': index == correctAnswerIndex,
      },
    );

    final Map<String, dynamic> requestData = {
      'questionText': questionTextController.text,
      'answers': answers,
    };

    try {
      final response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Insertion successful
        _showDialog('Success', 'Question and answers inserted successfully.');
      } else {
        // Failed to insert
        _showDialog('Error', 'Failed to insert: ${response.body}');
      }
    } catch (e) {
      //error HTTP request
      _showDialog('Error', 'An error occurred: $e');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.purple[10],
          title: Text(title, style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToShowAnswers();
              },
              child: Text('Check Questions', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _navigateToShowAnswers() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShowAnswers()),
    );
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.purple[10],
          title: const Text(
            'Confirmation',
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to submit this question?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
                if (_formKey.currentState?.validate() ?? false) {
                  _insertQuestionAndAnswers();
                }
              },
            ),
          ],
        );
      },
    );
  }
  void _checkPassword(){
    if(passwordTextController.text == '779006'){
      setState(() {
        locked = false;
        print('locked is : $locked');
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Question',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: locked?Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 200,),
          Center(
              child:
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: passwordTextController,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
          ),
          const SizedBox(height: 50,),
          ElevatedButton(onPressed: (){
            _checkPassword();
          },
              child: Text('Confirm'))
        ],
      ):SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: questionTextController,
                  decoration: InputDecoration(labelText: 'Enter Question'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a question';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),
                for (int i = 0; i < 4; i++)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: answerControllers[i],
                          decoration: InputDecoration(labelText: 'Enter Answer ${i + 1}'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter answer ${i + 1}';
                            }
                            return null;
                          },
                        ),
                      ),
                      Radio<int>(
                        value: i,
                        groupValue: correctAnswerIndex,
                        onChanged: (int? value) {
                          setState(() {
                            correctAnswerIndex = value ?? -1;
                          });
                        },
                      ),
                      Text('Correct Answer'),
                    ],
                  ),
                const SizedBox(height: 50.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    _showConfirmationDialog();
                  },
                  child: Text('Submit Question'),
                ),


              ],
            ),
          ),
        ),
      )
    );
  }
}
