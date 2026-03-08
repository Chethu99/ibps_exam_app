import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class SubjectScreen extends StatelessWidget {
  final String exam;
  final String stage;

  const SubjectScreen({
    super.key,
    required this.exam,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    // UPDATED: IDs now match the Firestore field values exactly
    final List<Map<String, dynamic>> subjects =
        (stage.toLowerCase() == "prelims")
            ? [
                {
                  "name": "English Language",
                  "id": "english",
                  "icon": Icons.menu_book,
                  "color": Colors.blue
                },
                {
                  "name": "Quantitative Aptitude",
                  "id": "quantitative_aptitude", // Changed from 'quant'
                  "icon": Icons.calculate,
                  "color": Colors.orange
                },
                {
                  "name": "Reasoning Ability",
                  "id": "reasoning",
                  "icon": Icons.psychology,
                  "color": Colors.purple
                },
              ]
            : [
                {
                  "name": "Reasoning Ability",
                  "id": "reasoning",
                  "icon": Icons.psychology,
                  "color": Colors.purple
                },
                {
                  "name": "Quantitative Aptitude",
                  "id": "quantitative_aptitude", // Changed from 'quant'
                  "icon": Icons.calculate,
                  "color": Colors.orange
                },
                {
                  "name": "English Language",
                  "id": "english",
                  "icon": Icons.menu_book,
                  "color": Colors.blue
                },
                {
                  "name": "General Awareness",
                  "id": "general_awareness", // Standardized naming
                  "icon": Icons.public,
                  "color": Colors.red
                },
                {
                  "name": "Computer Awareness",
                  "id": "computer_awareness", // Standardized naming
                  "icon": Icons.computer,
                  "color": Colors.teal
                },
              ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text(
          "${stage.toUpperCase()} MODULES",
          style: const TextStyle(
              fontWeight: FontWeight.w900, letterSpacing: 1.2, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF2F4F8F),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF2F4F8F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Text(
              exam.replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                final Color accentColor = subject["color"] as Color;

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(
                              exam: exam,
                              stage: stage,
                              subject: subject["id"] as String,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(subject["icon"] as IconData,
                                  color: accentColor, size: 28),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subject["name"] as String,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Tap to start practice",
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: 14, color: Colors.grey.shade400),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
