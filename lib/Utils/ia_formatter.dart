import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:jarvis_assistant/Utils/configs.dart';
import 'package:jarvis_assistant/Commons/gemini_controller.dart';


class IAFormatter {

  static dynamic formatter(String message, String prompt) async {
    GeminiController? controller = GeminiController(_getModel())..startChat();

    await controller.onSendMessage(prompt);
    String json = await controller.onSendMessage(message);
    controller = null;

    return _getJson(json);
  }

  static dynamic _getJson(String message) {
    // Regex para capturar o JSON
    print("Mensagem extraida: $message");
    final regex = RegExp('{(?:[^{}]*|{.*?})*}');

    // Encontrar o JSON no texto
    final match = regex.firstMatch(message);

    if (match != null) {
      final jsonStr = match.group(0); // Captura o JSON
      print("JSON Extraído: $jsonStr");

      // Opcional: Converter o JSON para um objeto Dart
      final jsonObject = jsonDecode(jsonStr!);
      print("Objeto JSON: $jsonObject");
      return jsonObject;
    } else {
      print("Nenhum JSON encontrado na mensagem.");
      return null;
    }
  }

  static GenerativeModel _getModel() {
    return GenerativeModel(model: 'gemini-1.5-flash', apiKey: API_KEY);
  }
}