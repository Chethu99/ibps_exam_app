import 'package:cloud_firestore/cloud_firestore.dart';

class QuizService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchQuestions({
    required String exam,
    required String stage,
    required String subject,
  }) async {

    try {

      final querySnapshot = await _firestore
          .collection("Questions")
          .where("exam", isEqualTo: exam)
          .where("stage", isEqualTo: stage)
          .where("subject", isEqualTo: subject)
          .get();

      final questions = querySnapshot.docs.map((doc) {

        final data = doc.data();

        return {
          "question": data["question"],
          "options": List<String>.from(data["options"]),
          "answer": data["answer"],
          "explanation": data["explanation"]
        };

      }).toList();

      return questions;

    } catch (e) {

      print("Error fetching questions: $e");
      return [];

    }

  }

}