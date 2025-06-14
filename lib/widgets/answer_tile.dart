import 'package:flutter/material.dart';
import '../models/answer.dart';

class AnswerTile extends StatelessWidget {
  final Answer answer;

  const AnswerTile({required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        title: Text(answer.content),
        subtitle: Text('By ${answer.author} • ${answer.timestamp}'),
        leading: Icon(Icons.question_answer, color: Colors.indigo),
      ),
    );
  }
}
