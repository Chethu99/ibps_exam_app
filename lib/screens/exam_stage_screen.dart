import 'package:flutter/material.dart';
import 'subject_screen.dart';

class ExamStageScreen extends StatelessWidget {

  final String examName;

  const ExamStageScreen({super.key, required this.examName});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(examName),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          stageTile(context, "Prelims"),

          stageTile(context, "Mains"),

        ],
      ),
    );
  }

  Widget stageTile(BuildContext context, String stage) {

    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      child: ListTile(
        title: Text(
          stage,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        trailing: const Icon(Icons.arrow_forward_ios),

        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SubjectScreen(),
            ),
          );

        },
      ),
    );
  }
}