import 'package:flutter/material.dart';
import 'subject_screen.dart';

class ExamScreen extends StatelessWidget {

  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Exam"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          examTile(context, "RBI Assistant 2026 🔥"),

          examTile(context, "IBPS PO"),

          examTile(context, "IBPS Clerk (CSA)"),

          examTile(context, "IBPS SO"),

          examTile(context, "IBPS RRB"),

        ],
      ),
    );
  }

  Widget examTile(BuildContext context, String examName) {

    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      child: ListTile(
        title: Text(
          examName,
          style: const TextStyle(fontWeight: FontWeight.bold),
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