import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseFileRoutines {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/qna.json');
  }

  Future<String> readQnAs() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        await writeQnAs('{"questions":[]}');
      }
      return await file.readAsString();
    } catch (e) {
      print("Error reading QnAs: $e");
      return '{"questions":[]}';
    }
  }

  Future<File> writeQnAs(String json) async {
    final file = await _localFile;
    return file.writeAsString(json);
  }
}
