import 'package:flutter_tts/flutter_tts.dart';
import 'package:jarvis_assistant/Commons/prompts.dart';
import 'package:jarvis_assistant/Utils/ia_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:android_intent_plus/android_intent.dart';
import 'package:share_plus/share_plus.dart';
import 'package:location/location.dart' as loc;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ChatController {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  late String words;

  ChatController() {
    _initSpeech();
    _flutterTts.setLanguage("pt-BR"); // Define o idioma para Português
    _flutterTts.setPitch(1); // Ajusta a tonalidade da voz
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

  Future<void> speak(String message) async {
    await _flutterTts.speak(message);
  }

  // Função para pausar a leitura
  void stopSpeaking() async {
    await _flutterTts.stop();
  }

  bool isCalendarInformation(String message) {
    final calendarKeywords = ['agenda', 'evento', 'reunião', 'calendário', 'aniversário', 'festa', 'show', 'encontro', 'comemor'];
    return calendarKeywords.any((keyword) => message.toLowerCase().contains(keyword.toLowerCase()));
  }

  bool isAlarmInformation(String message) {
    final alarmKeywords = ['horas', 'minutos', 'dormir', 'sono', 'descans', 'lembrete', 'aviso', 'alarme', 'despert', "soneca", "relaxar",  "ciclo do sono", "noturno","travesseiro",
                          "cama", "colchão", "adormecer", "relógio", "boa noite"];
    return alarmKeywords.any((keyword) => message.toLowerCase().contains(keyword.toLowerCase()));
  }

  bool isAddressInformation(String message) {
    final alarmKeywords = ["mapa", "localização", "rota", "direção", "itinerário", "coordenadas", "GPS", "orientação",
                          "bairro", "cidade", "estado", "país", "CEP", "endereço", "rua", "local", "ponto", "área", "região",
                          "zona", "território", "ponto-de-referência", "destino", "origem", "vizinhança", "localização"];
    return alarmKeywords.any((keyword) => message.toLowerCase().contains(keyword.toLowerCase()));
  }

  Future<bool> sendToCalendar(message) async {
    dynamic json = await IAFormatter.formatter(message, DefaultPrompts.CALENDAR);

    final DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();

    // Solicitar permissões
    var permissionsGranted = await deviceCalendarPlugin.requestPermissions();
    if (permissionsGranted.isSuccess && permissionsGranted.data!) {
      // Buscar os calendários disponíveis
      var calendarsResult = await deviceCalendarPlugin.retrieveCalendars();

      if (calendarsResult.isSuccess && calendarsResult.data != null) {
        // Usar o primeiro calendário disponível
        var calendar = calendarsResult.data!.first;
        var data = TZDateTime(tz.local, json["ano"], json["mes"], json["dia"],
                              json["hora"], json["minuto"]).millisecondsSinceEpoch;

        // Criar o evento
        dynamic evento = {
          "calendarId": calendar.id,
          "eventTitle": json["nomeEvento"],
          "eventStartDate": data,
          "eventEndDate": data,
          "eventLocation": "Sala 11",
          "eventAllDay": true,
        };
        var event = Event.fromJson(evento);

        var createResult = await deviceCalendarPlugin.createOrUpdateEvent(event);

        if (createResult != null && createResult.isSuccess) {
          print("Evento criado com sucesso!");
          return true;
        } else {
          print("Falha ao criar o evento.");
          return false;
        }
      }
      print("Sem calendarios");
      return false;
    } else {
      print("Permissão para acessar o calendário negada.");
      return false;
    }
  }

  Future<bool> createAlarm(String message) async {
    dynamic json = await IAFormatter.formatter(message, DefaultPrompts.ALARM);

    final AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.SET_ALARM',
      arguments: <String, dynamic>{
        'android.intent.extra.alarm.MESSAGE': json["descricao"],
        'android.intent.extra.alarm.HOUR': json["hora"],
        'android.intent.extra.alarm.MINUTES': json["minuto"],
        'android.intent.extra.alarm.SKIP_UI': true, // Define se a UI do app de relógio será exibida
      },
    );

    try {
      await intent.launch();
      return true;
    } catch (e) {
      print('Error launching alarm intent: $e');
      return false;
    }
  }

  void shareContent(String message) async {
    await Share.share('Confira essa mensagem que recebi do Jarvis:\n\n $message');
  }

  Future<bool> openRouteWithMaps(String message) async {
    dynamic json = await IAFormatter.formatter(message, DefaultPrompts.MAPS);

    if(await Permission.location.request().isGranted){
      loc.Location location = loc.Location();

      loc.LocationData currentLocation = await location.getLocation();

      // Construir a URL de direção do Google Maps
      String googleMapsUrl =
          'https://www.google.com/maps/dir/?api=1&origin=${currentLocation.latitude},${currentLocation.longitude}&destination=${json["latitude"]},${json["longitude"]}&travelmode=driving';

      // Tenta abrir o Google Maps com a URL gerada
      await launchUrlString(googleMapsUrl);
      return true;
    } else {
      return false;
    }
  }
}