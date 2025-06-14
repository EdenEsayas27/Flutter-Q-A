import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/answer.dart';
import '../services/database_file_routines.dart';
import '../models/database.dart';
import '../widgets/answer_tile.dart';
import 'dart:convert';

class QuestionDetailScreen extends StatefulWidget {
  final Question question;

  QuestionDetailScreen({required this.question});

  @override
  _QuestionDetailScreenState createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  final TextEditingController _answerController = TextEditingController();
  final DatabaseFileRoutines dbRoutines = DatabaseFileRoutines();
  late Database _database;
  late Question _currentQuestion;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    try {
      String jsonString = await dbRoutines.readQnAs();
      _database = Database.fromJson(json.decode(jsonString));

      _currentQuestion = _database.questions.firstWhere(
        (q) => q.id == widget.question.id,
        orElse: () => widget.question,
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading database: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addAnswer() async {
    final answerText = _answerController.text.trim();
    if (answerText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Answer cannot be empty')),
      );
      return;
    }

    try {
      final newAnswer = Answer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: answerText,
        author: 'User',
        timestamp: DateTime.now().toLocal().toString().substring(0, 19),
      );

      final questionIndex =
          _database.questions.indexWhere((q) => q.id == _currentQuestion.id);
      if (questionIndex == -1) {
        print("Question not found in database");
        return;
      }

      setState(() {
        _database.questions[questionIndex].answers.add(newAnswer);
        _answerController.clear();
      });

      await dbRoutines.writeQnAs(json.encode(_database.toJson()));

      // Reload to refresh UI
      await _loadDatabase();

      // Optional: Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Answer added successfully')),
      );
    } catch (e) {
      print("Error adding answer: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add answer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Question Details')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Question Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentQuestion.title,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    if (_currentQuestion.content.isNotEmpty) ...[
                      SizedBox(height: 8),
                      Text(_currentQuestion.content),
                    ],
                    SizedBox(height: 8),
                    Text(
                      'Asked by: ${_currentQuestion.author}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _currentQuestion.answers.isEmpty
                  ? Center(
                      child: Text(
                        "No answers yet. Be the first to answer!",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _currentQuestion.answers.length,
                      itemBuilder: (context, index) {
                        final answer = _currentQuestion.answers[index];
                        return AnswerTile(answer: answer);
                      },
                    ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _answerController,
                    decoration: InputDecoration(
                      hintText: "Write your answer...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    minLines: 1,
                    maxLines: 3,
                    onSubmitted: (_) => _addAnswer(), // also submit on keyboard enter
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addAnswer,
                  child: Icon(Icons.send),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
