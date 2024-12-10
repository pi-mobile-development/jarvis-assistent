import 'dart:async';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:jarvis_assistant/Chat/chat_controller.dart';
import 'package:jarvis_assistant/Chat/firestore_controler.dart';
import 'package:jarvis_assistant/Commons/prompts.dart';
import 'package:jarvis_assistant/Prompt/prompt_view.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jarvis_assistant/Commons/gemini_controller.dart';
import 'package:jarvis_assistant/Chat/chat_model.dart';
import 'package:jarvis_assistant/Utils/configs.dart';
import 'package:jarvis_assistant/Utils/utils.dart';
import 'package:jarvis_assistant/Themes/themes.dart';
import 'package:jarvis_assistant/About/about_view.dart';
import 'package:jarvis_assistant/Login/login_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _textInputController = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <MessageModel>[];
  bool _isRecording = false;
  bool _isLoading = false;
  bool _isImagePicked = false;
  late final GeminiController _controller;
  late final ChatController chatController;
  final FirestoreController _firestoreController = FirestoreController();
  final imagePicker = ImagePicker();
  File? imageFile;

  @override
  void initState() {
    _controller = GeminiController(
      GenerativeModel(
        model: 'gemini-1.5-flash', 
        apiKey: API_KEY),
        )..startChat();

    _initJarvis();
    chatController = ChatController();
    _loadMessages();
    super.initState();
  }

  void _initJarvis() async {
    await _controller.onSendMessage(DefaultPrompts.JARVIS);
  }

  void scrollDown() {
    Future.delayed(
      const Duration(milliseconds: 200), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), 
        curve: Curves.easeInOut
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildSideMenu(),
      body: SizedBox.expand(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: AppTheme.primaryColor,
          child: Column(
            children: [
              Expanded(
                child: _buildMessageView()
              ),
              if(_isLoading) // Exibe o ícone de carregamento quando _isLoading for true
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: LinearProgressIndicator(backgroundColor:Color(0xFF1A1A1A),color: Color(0xff9489F5),),
                  
              ),
              Divider(height: 1, color: AppTheme.secondaryColor),
              _buildInputBar(),
            ],
          )
        ),
      ),
    );
  }

  // Builders
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.appBarColor,
      centerTitle: true,
      title: Text(
        'Jarvis Assistant',
        style:
            TextStyle(color: AppTheme.textColor, fontWeight: FontWeight.bold),
      ),
      iconTheme: IconThemeData(
        color: AppTheme.secondaryColor
      ),
    );
  }

  ListView _buildMessageView() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (_, int index) {
        return GestureDetector(
            onLongPress: () {
              if(_messages[index].messageFrom == MessageFrom.IA) {
                _showOptionsMenu(context, _messages[index].message, index);
              }
            },
            child: Row(
            children: [
              if (_messages[index].messageFrom == MessageFrom.USER)
                const Spacer(),
              Container(
                margin: const EdgeInsets.all(12),
                width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: _messages[index].messageFrom == MessageFrom.USER
                        ? const Color(0xAA1a1f24).withOpacity(0.5)
                        : AppTheme.secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(_messages[index].imagePath != null) ...[
                      Image(image: FileImage(File(_messages[index].imagePath!)), width: 300, height: 300),
                      const SizedBox(height: 20),
                    ],
                    Text(
                      _messages[index].message,
                      style: TextStyle(color: AppTheme.textColor, fontSize: 20),
                    )
                  ],
                )
              ),
            ],
          )
        );
      }
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon( _isImagePicked ? Icons.check : Icons.add_photo_alternate),
            onPressed: _pickImage,
            color: AppTheme.secondaryColor,
          ),
          AvatarGlow(
            animate: _isRecording,
            glowColor: _isRecording? AppTheme.secondaryColor : AppTheme.primaryColor,
            child: IconButton(
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                onPressed: _recordAudio,
                color: AppTheme.secondaryColor
            )
          ),
          Expanded(
            child: TextField(
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.textColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2
              ),
              maxLines: 4,
              minLines: 1,
              controller: _textInputController,
              decoration: InputDecoration(
                hintText: 'Digite sua pergunta',
                hintStyle: TextStyle(color: AppTheme.textColor.withOpacity(0.5)),
                enabledBorder: AppTheme.outlineInputBorder,
                fillColor: AppTheme.appBarColor,
                focusedBorder: AppTheme.outlineInputBorder,
                filled: true,
                suffixIcon: IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(
                    Icons.send,
                    color: AppTheme.secondaryColor,
                  )
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the side menu (Drawer)
  Widget _buildSideMenu() {
    return Drawer(
      backgroundColor: AppTheme.primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor,
            ),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: loggedUser.photoUrl != null && loggedUser.photoUrl!.isNotEmpty
                      ? NetworkImage(loggedUser.photoUrl!)
                      : Icons.account_box as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                  "Sr. ${loggedUser.username}",
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.info, color: AppTheme.secondaryColor),
            title: const Text('Sobre o App'),
            textColor: AppTheme.textColor,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
            },
          ),
          ListTile(
            leading: Icon(Icons.terminal_sharp, color: AppTheme.secondaryColor),
            title: const Text('Prompts'),
            textColor: AppTheme.textColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PromptsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: AppTheme.secondaryColor),
            title: const Text('Logout'),
            textColor: AppTheme.textColor,
            onTap: () async {
              await signOut();
              Navigator.pop(context); // Close the drawer
              Navigator.pop(context); // Close chat
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  // Actions
  void _sendMessage() async {
    if (_textInputController.text.isNotEmpty) {
      final prompt = _textInputController.text;
      _isLoading = true;

      String? imagePath = _isImagePicked ? imageFile!.path : null;

      final userMessage = MessageModel(
        message: prompt, 
        messageFrom: MessageFrom.USER, 
        imagePath: imagePath);
      await _firestoreController.saveMessage(userMessage);
      setState(()  {
        _messages.add(
            userMessage
        );        
        _textInputController.clear();
        scrollDown();
      });
      
      String resp;

      if(imageFile != null){
        resp = await _controller.onSendImageMessage(prompt,imageFile!);
      }else{
        resp = await _controller.onSendMessage(prompt);
      }

      final iaMessage = MessageModel(
        message: resp, 
        messageFrom: MessageFrom.IA,);
      await _firestoreController.saveMessage(iaMessage);
      
      setState(() {
        imageFile = null;
        _isImagePicked = false;
        _messages.add(iaMessage);
        scrollDown();
      });
      _isLoading = false;
    }
  }

  Future<void> _recordAudio() async {
    setState(() {
      _isRecording = !_isRecording;
    });

    if(_isRecording) {
      setState(() {
        _textInputController.clear();
      });
      await chatController.startListening(_onSpeechResult);
    } else {
      await chatController.stopListening();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _textInputController.text = "${result.recognizedWords} ";
    });
  }

  Future<void> _pickImage() async {
    if (await Permission.camera.request().isGranted) {
      if(imageFile != null){
        setState(() {
          imageFile = null;
          _isImagePicked = false;
        });
      }else{
      final pickedFile =  await imagePicker.pickImage(source: ImageSource.gallery);
      if(pickedFile != null){
        setState(() {
          imageFile = File(pickedFile.path);
          _isImagePicked = true;
        });
      }
      }
    }
  }

  void _showOptionsMenu(BuildContext context, String message, int index) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 200, 100, 0),
      items: [
        PopupMenuItem(
          value: 'Compartilhar',
          onTap: () {
            chatController.shareContent(message);
          },
          child: ListTile(
            leading: Icon(Icons.share, color: AppTheme.secondaryColor),
            title: const Text('Compartilhar'),
          ),
        ),
        PopupMenuItem(
          value: 'Copiar',
          onTap: () {
            Clipboard.setData(ClipboardData(text: message));
          },
          child: ListTile(
            leading: Icon(Icons.copy_outlined, color: AppTheme.secondaryColor),
            title: Text('Copiar'),
          ),
        ),
        PopupMenuItem(
          value: 'Ler',
          onTap: () async {
            await chatController.speak(message);
          },
          child: ListTile(
            leading: Icon(Icons.volume_up, color: AppTheme.secondaryColor),
            title: Text('Ler'),
          ),
        ),

        if(chatController.isCalendarInformation(message))...[
          PopupMenuItem(
            value: 'Agenda',
            onTap: () async {
              bool success = await chatController.sendToCalendar(message);
              exibirAviso(context, success ? "Agenda criada" : "Erro ao criar agenda, tente novamente");
            },
            child: ListTile(
              leading: Icon(Icons.date_range, color: AppTheme.secondaryColor),
              title: Text('Enviar evento para agenda'),
            ),
          )
        ],

        if(chatController.isAlarmInformation(message))...[
          PopupMenuItem(
            value: 'Relogio',
            onTap: () async {
              bool success = await chatController.createAlarm(message);
              exibirAviso(context, success ? "Alarme criado" : "Erro ao criar alarme, tente novamente");
            },
            child: ListTile(
              leading: Icon(Icons.alarm_add, color: AppTheme.secondaryColor),
              title: Text('Criar alarme'),
            ),
          )
        ],

        if(chatController.isAddressInformation(message))...[
          PopupMenuItem(
            value: 'Mapa',
            onTap: () async {
              bool success = await chatController.openRouteWithMaps(message);
              exibirAviso(context, success ? "Redirecionando ao mapa" : "Erro ao redirecionar");
            },
            child: ListTile(
              leading: Icon(Icons.gps_fixed, color: AppTheme.secondaryColor),
              title: Text('Rotas'),
            ),
          )
        ]
      ],
    );
  }

  void exibirAviso(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(message))
    );
  }

  Future<void> _loadMessages() async {
    List<MessageModel> history = await _firestoreController.getMessages();
    setState(() {
      _messages.addAll(history);
    });
    scrollDown();
  }
}
