import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/quiz_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  List<Question> questions = [];
  int index = 0;
  int score = 0;
  int? selected;

  int seconds = 20;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() async {

    questions = await QuizService().fetchQuestions("reasoning");

    startTimer();

    setState(() {});
  }

  void startTimer() {

    Future.delayed(const Duration(seconds: 1), () {

      if (!mounted) return;

      if (seconds > 0) {

        setState(() {
          seconds--;
        });

        startTimer();

      } else {

        nextQuestion();
      }
    });
  }

  void selectAnswer(int optionIndex) {

    if (selected != null) return;

    setState(() {
      selected = optionIndex;
    });

    final correct = questions[index].answer;

    if (questions[index].options[optionIndex] == correct) {
      score++;
    }

    Future.delayed(const Duration(seconds: 1), () {
      nextQuestion();
    });
  }

  void nextQuestion() {

    if (index < questions.length - 1) {

      setState(() {
        index++;
        selected = null;
        seconds = 20;
      });

      startTimer();

    } else {

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Quiz Finished"),
          content: Text("Your score: $score / ${questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Back"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final q = questions[index];
    final correct = q.answer;

    double progress = (index + 1) / questions.length;

    return Scaffold(

      backgroundColor: const Color(0xfff5f7fb),

      appBar: AppBar(
        title: const Text("Mock Test"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Question ${index + 1}/${questions.length}"),
                Text("Time: $seconds"),
              ],
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  q.question,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: q.options.length,
                itemBuilder: (context, i) {

                  Color color = Colors.white;

                  if (selected != null) {

                    if (q.options[i] == correct) {
                      color = Colors.green.shade300;
                    } else if (i == selected) {
                      color = Colors.red.shade300;
                    }
                  }

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 12),

                    child: Material(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => selectAnswer(i),

                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            q.options[i],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Score: $score",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
    );
  }
}