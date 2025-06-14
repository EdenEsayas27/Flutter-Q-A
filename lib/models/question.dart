import 'answer.dart';

class Question {
  String id;
  String title;
  String content;
  String author;
  List<Answer> answers;

  Question({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        author: json["author"],
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "author": author,
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
      };
}
