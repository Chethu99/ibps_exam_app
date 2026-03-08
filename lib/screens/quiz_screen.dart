import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizScreen extends StatefulWidget {
  final String exam;
  final String stage;
  final String subject;

  const QuizScreen({
    super.key,
    required this.exam,
    required this.stage,
    required this.subject,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  bool isLoading = true;
  bool answered = false;
  String? selectedOption;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    try {
      // Debug prints: Check your console to see if these match your Firestore exactly!
      print(
          "Fetching: Exam: ${widget.exam}, Stage: ${widget.stage}, Subject: ${widget.subject}");

      final snapshot = await FirebaseFirestore.instance
          .collection("Questions")
          .where("exam", isEqualTo: widget.exam)
          .where("stage", isEqualTo: widget.stage)
          .where("subject", isEqualTo: widget.subject)
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          questions = [];
          isLoading = false;
        });
        return;
      }

      setState(() {
        questions = snapshot.docs.map((doc) => doc.data()).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Firestore Error: $e");
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Color getOptionColor(String option) {
    if (!answered) return Colors.white;

    String correctAnswer = questions[currentQuestionIndex]["answer"];

    if (option == correctAnswer) {
      return Colors.green.shade200;
    }

    if (option == selectedOption && option != correctAnswer) {
      return Colors.red.shade200;
    }

    return Colors.white;
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        answered = false;
        selectedOption = null;
      });
    } else {
      showCompletionDialog();
    }
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Quiz Finished"),
        content:
            const Text("You have completed all questions in this section."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Loading State
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 2. Error State (like missing indexes)
    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Error: $errorMessage", textAlign: TextAlign.center),
          ),
        ),
      );
    }

    // 3. Empty State (No questions found)
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 60, color: Colors.grey),
              const SizedBox(height: 10),
              Text("No questions found for ${widget.subject}"),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Go Back"),
              )
            ],
          ),
        ),
      );
    }

    var question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.replaceAll("_", " ").toUpperCase()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${currentQuestionIndex + 1} / ${questions.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Text(
              question["question"] ?? "No Question Text",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            // Options List
            ...(question["options"] as List).map<Widget>((option) {
              return GestureDetector(
                onTap: () {
                  if (answered) return;
                  setState(() {
                    selectedOption = option;
                    answered = true;
                  });
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: getOptionColor(option),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            // Explanation Section
            if (answered) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Explanation:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(
                      question["explanation"] ?? "No explanation provided.",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  onPressed: nextQuestion,
                  child: Text(currentQuestionIndex < questions.length - 1
                      ? "Next Question"
                      : "Finish Quiz"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
