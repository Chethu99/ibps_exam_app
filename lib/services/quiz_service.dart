import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class QuizService {

  Future<List<Question>> fetchQuestions() async {

    final url = Uri.parse(
      "https://raw.githubusercontent.com/YOUR_GITHUB/questions.json"
    );

    final response = await http.get(url);

    final data = jsonDecode(response.body);

    List<Question> questions = (data["questions"] as List)
        .map((q) => Question.fromJson(q))
        .toList();

    return questions;
  }
}