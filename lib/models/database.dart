import 'question.dart';

class Database {
  List<Question> questions;

  Database({required this.questions});

  factory Database.fromJson(Map<String, dynamic> json) => Database(
        questions:
            List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}
