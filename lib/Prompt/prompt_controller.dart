import 'package:jarvis_assistant/Prompt/prompt_db.dart';
import 'prompt_model.dart';

class PromptController {

  Future<void> addPrompt(String title, String text) async {
    Prompt prompt = Prompt(
        userID: "",
        title: title,
        prompt: text,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String()
    );

    await SQLiteCore.createPrompt(prompt);
  }

  Future<void> updatePrompt(Prompt prompt, String newTitle, String newText) async {
    prompt.title = newTitle;
    prompt.prompt = newText;
    await SQLiteCore.updatePrompt(prompt);
  }

  Future<List<Prompt>> getAllPrompts() async {
    return SQLiteCore.getPrompts();
  }

  Future<void> deletePrompt(int id) async {
    await SQLiteCore.deletePrompt(id);
  }
}