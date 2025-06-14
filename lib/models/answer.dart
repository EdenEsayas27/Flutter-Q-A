class Answer {
  String id;
  String content;
  String author;
  String timestamp;

  Answer({
    required this.id,
    required this.content,
    required this.author,
    required this.timestamp,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json["id"],
        content: json["content"],
        author: json["author"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "author": author,
        "timestamp": timestamp,
      };
}
