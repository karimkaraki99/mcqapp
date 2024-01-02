
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proejctmcq/quiz_page.dart';
import 'add_questions.dart';
import 'show_answers.dart';
import 'draft.dart';


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
        title: Center(
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddQuestions()),
              );
            },
            child: const Text(
              'MCQ Scout App',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
        backgroundColor: Colors.purple,
      ),


      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
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
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed :() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowQuestions()),
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
                onPressed :() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowAnswers()),
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
                  'Answers',
                  style: TextStyle(fontSize: 26, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Exit App'),
                        content: Text('Are you sure you want to exit the app?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              SystemNavigator.pop(); // Exit the app
                            },
                            child: Text('Exit',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                          ),
                        ],
                      );
                    },
                  );
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
                  style: TextStyle(fontSize: 26, color: Colors.white,fontWeight: FontWeight.bold),
                ),
              ),

            ],
          ),
        ),
      )
    );
  }
}
