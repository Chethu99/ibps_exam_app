import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ------------------------------------------------------------------
// 1. MAIN EXAM LIST (Unique Exams Only)
// ------------------------------------------------------------------
class ExamScreen extends StatelessWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Exams"),
        backgroundColor: const Color(0xff1e3c72),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Questions').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          // Collapse 100+ documents into unique exam names
          final allDocs = snapshot.data!.docs;
          final uniqueExams =
              allDocs.map((doc) => doc['exam'].toString()).toSet().toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: uniqueExams.length,
            itemBuilder: (context, index) {
              final examId = uniqueExams[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.account_balance,
                      color: Color(0xff1e3c72)),
                  title: Text(examId.replaceAll('_', ' ').toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StageScreen(examId: examId)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ------------------------------------------------------------------
// 2. STAGE SELECTION (Prelims / Mains)
// ------------------------------------------------------------------
class StageScreen extends StatelessWidget {
  final String examId;
  const StageScreen({super.key, required this.examId});

  @override
  Widget build(BuildContext context) {
    final stages = ['prelims', 'mains'];
    return Scaffold(
      appBar: AppBar(title: Text(examId.replaceAll('_', ' ').toUpperCase())),
      body: ListView.builder(
        itemCount: stages.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(stages[index].toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("View all sections for ${stages[index]}"),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SectionScreen(examId: examId, stage: stages[index])),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// 3. SECTION SELECTION (Eng, Reasoning, Quant)
// ------------------------------------------------------------------
class SectionScreen extends StatelessWidget {
  final String examId;
  final String stage;
  const SectionScreen({super.key, required this.examId, required this.stage});

  @override
  Widget build(BuildContext context) {
    final sections = [
      {'label': 'English Language', 'dbValue': 'english'},
      {'label': 'Reasoning Ability', 'dbValue': 'reasoning'},
      {'label': 'Quantitative Aptitude', 'dbValue': 'quantitative_aptitude'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text("${stage.toUpperCase()} Sections")),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(sections[index]['label']!),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuestionListScreen(
                      examId: examId,
                      stage: stage,
                      subject: sections[index]['dbValue']!)),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// 4. THE INTERACTIVE QUIZ SCREEN (Selections & Explanations)
// ------------------------------------------------------------------
class QuestionListScreen extends StatefulWidget {
  final String examId;
  final String stage;
  final String subject;

  const QuestionListScreen(
      {super.key,
      required this.examId,
      required this.stage,
      required this.subject});

  @override
  State<QuestionListScreen> createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  // Map to store user choice for each question index
  Map<int, int?> selectedAnswers = {};
  // Map to track if explanation should be shown
  Map<int, bool> showExplanations = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.replaceAll('_', ' ').toUpperCase()),
        backgroundColor: const Color(0xff1e3c72),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Questions')
            .where('exam', isEqualTo: widget.examId)
            .where('stage', isEqualTo: widget.stage)
            .where('subject', isEqualTo: widget.subject)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final questions = snapshot.data!.docs;
          if (questions.isEmpty)
            return const Center(
                child: Text("No questions found. Check Firestore data."));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: questions.length,
            itemBuilder: (context, qIndex) {
              final data = questions[qIndex].data() as Map<String, dynamic>;
              final options = List<String>.from(data['options'] ?? []);
              final String correctAnswer = data['answer']?.toString() ?? "";
              final String explanation =
                  data['explanation'] ?? "No explanation provided.";

              return Card(
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Question ${qIndex + 1}",
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(data['question'] ?? "",
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 15),

                      // Options
                      ...List.generate(options.length, (oIndex) {
                        bool isCorrect = options[oIndex] == correctAnswer;
                        bool isUserChoice = selectedAnswers[qIndex] == oIndex;

                        // Color logic after selection
                        Color? bgColor;
                        if (selectedAnswers[qIndex] != null) {
                          if (isCorrect)
                            bgColor = Colors.green.withOpacity(0.15);
                          else if (isUserChoice)
                            bgColor = Colors.red.withOpacity(0.15);
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: isUserChoice
                                    ? Colors.blue
                                    : Colors.grey.shade300),
                          ),
                          child: RadioListTile<int>(
                            title: Text(options[oIndex]),
                            value: oIndex,
                            groupValue: selectedAnswers[qIndex],
                            onChanged: (val) {
                              setState(() {
                                selectedAnswers[qIndex] = val;
                                showExplanations[qIndex] = true;
                              });
                            },
                          ),
                        );
                      }),

                      // Explanation (Appears after answering)
                      if (showExplanations[qIndex] == true)
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.yellow.shade100,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("EXPLANATION:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                              const SizedBox(height: 4),
                              Text(explanation),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
