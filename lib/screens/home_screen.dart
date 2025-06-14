import 'package:flutter/material.dart';
import '../models/database.dart';
import '../models/question.dart';
import '../services/database_file_routines.dart';
import '../widgets/question_tile.dart';
import 'question_detail_screen.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseFileRoutines dbRoutines = DatabaseFileRoutines();
  late Database _database;
  bool _isLoading = true;
  final TextEditingController _questionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    String jsonString = await dbRoutines.readQnAs();
    setState(() {
      _database = Database.fromJson(json.decode(jsonString));
      _isLoading = false;
    });
  }

  Future<void> _addQuestion() async {
    if (_questionController.text.trim().isEmpty) return;

    final newQuestion = Question(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _questionController.text.trim(),
      content: '',
      author: 'User',
      answers: [],
    );

    setState(() {
      _database.questions.add(newQuestion);
      _questionController.clear();
    });

    await dbRoutines.writeQnAs(json.encode(_database.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Q&A Forum'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _questionController,
                          decoration: InputDecoration(
                            hintText: "Ask a question...",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addQuestion,
                        child: Icon(Icons.send),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(14),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _database.questions.isEmpty
                      ? Center(
                          child: Text(
                            "No questions yet. Ask something!",
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _database.questions.length,
                          itemBuilder: (context, index) {
                            final question = _database.questions[index];
                            return QuestionTile(
                              question: question,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        QuestionDetailScreen(question: question),
                                  ),
                                );
                                // Reload data after returning
                                await _loadData();
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
