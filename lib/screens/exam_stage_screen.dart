import 'package:flutter/material.dart';
import 'subject_screen.dart';

class ExamStageScreen extends StatelessWidget {
  final String exam;

  const ExamStageScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exam.toUpperCase()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          stageTile(
            context,
            title: "Prelims",
            stage: "prelims",
          ),
          stageTile(
            context,
            title: "Mains",
            stage: "mains",
          ),
        ],
      ),
    );
  }

  Widget stageTile(
    BuildContext context, {
    required String title,
    required String stage,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        title: Text(
          title,
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
              builder: (_) => SubjectScreen(
                exam: exam,
                stage: stage,
              ),
            ),
          );
        },
      ),
    );
  }
}
