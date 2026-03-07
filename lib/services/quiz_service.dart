import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class QuizService {

  Future<List<Question>> fetchQuestions(String subject) async {

   final url = Uri.parse(
  "https://raw.githubusercontent.com/Chethu99/ibps_exam_app/main/question_bank/questions/$subject.json"
);

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to load questions");
    }

    final data = jsonDecode(response.body);

    List<Question> questions = (data["questions"] as List)
        .map((q) => Question.fromJson(q))
        .toList();

    return questions;
  }
}