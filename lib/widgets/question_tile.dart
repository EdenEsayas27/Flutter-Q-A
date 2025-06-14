import 'package:flutter/material.dart';
import '../models/question.dart';

class QuestionTile extends StatelessWidget {
  final Question question;
  final VoidCallback onTap;

  const QuestionTile({required this.question, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        title: Text(
          question.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Asked by: ${question.author}'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
