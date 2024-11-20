import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatController {
  SpeechToText _speechToText = SpeechToText();
  late String words;

  ChatController() {
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
  }

  Future<void> startListening(Function(SpeechRecognitionResult) callback) async {
    await _speechToText.listen(
        onResult: callback,
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.dictation,
          cancelOnError: false,
          partialResults: true,
        )
    );
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }
}