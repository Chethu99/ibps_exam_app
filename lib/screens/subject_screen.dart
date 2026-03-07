import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class SubjectScreen extends StatelessWidget {

  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Subject"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          subjectTile(context, "Reasoning", "reasoning"),

          subjectTile(context, "English", "english"),

          subjectTile(
            context,
            "Quantitative Aptitude",
            "quantitative_aptitude",
          ),

          subjectTile(
            context,
            "Computer Awareness",
            "computer_awareness",
          ),

          subjectTile(
            context,
            "General Awareness",
            "general_awareness",
          ),

          subjectTile(
            context,
            "Current Affairs",
            "current_affairs",
          ),

        ],
      ),
    );
  }

  Widget subjectTile(BuildContext context, String title, String subject) {

    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),

        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuizScreen(subject: subject),
            ),
          );

        },
      ),
    );
  }
}