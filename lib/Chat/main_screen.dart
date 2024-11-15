import 'dart:io';
import 'package:jarvis_assistant/Prompt/prompt_view.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jarvis_assistant/Chat/gemini_controller.dart';
import 'package:jarvis_assistant/Chat/message_model.dart';
import 'package:jarvis_assistant/Utils/configs.dart';
import 'package:jarvis_assistant/Utils/utils.dart';
import 'package:jarvis_assistant/Themes/themes.dart';
import 'package:jarvis_assistant/About/about_screen.dart';
import 'package:jarvis_assistant/Login/login_view.dart';
import 'package:permission_handler/permission_handler.dart';


class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  final _textInputController = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <MessageModel>[];
  bool _isRecording = false;
  bool _isLoading = false;
  bool _isPicked = false;
  late final GeminiController _controller;
  final imagePicker = ImagePicker();
  File? imageFile;

  @override
  void initState() {
    _controller = GeminiController(
      GenerativeModel(
        model: 'gemini-1.5-flash', 
        apiKey: API_KEY),
        )..startChat();
    super.initState();
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
        return Row(
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
              child: Text(
                _messages[index].message,
                style: TextStyle(color: AppTheme.textColor, fontSize: 20),
              )
            ),
          ],
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
            icon: Icon( _isPicked ? Icons.check : Icons.add_photo_alternate),
            onPressed: _pickImage,
            color: AppTheme.secondaryColor,
          ),
          IconButton(
            icon: Icon(_isRecording ? Icons.stop : Icons.mic),
            onPressed: _recordAudio,
            color: AppTheme.secondaryColor
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
                hintStyle: TextStyle(color: AppTheme.textColor),
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
            title: const Text('About App'),
            textColor: AppTheme.textColor,
            onTap: () {
              Navigator.pop(context);
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
              Navigator.pop(context);
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
      setState(()  {
        _messages.add(MessageModel(message: prompt, messageFrom: MessageFrom.USER));
        _textInputController.clear();
        scrollDown();
      });
      
      String resp;

      if(imageFile != null){
        resp = await _controller.onSendImageMessage(prompt,imageFile!);
      }else{
        resp = await _controller.onSendMessage(prompt);
      }
      
      setState(() {
        imageFile = null;
        _isPicked = false;
        _messages.add(MessageModel(message: resp, messageFrom: MessageFrom.IA));
        scrollDown();
      });
      _isLoading = false;
    }
  }

  void _recordAudio() {
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  Future<void> _pickImage() async {
    if (await Permission.camera.request().isGranted) {
      if(imageFile != null){
        setState(() {
          imageFile = null;
          _isPicked = false;
        });
      }else{
      final pickedFile =  await imagePicker.pickImage(source: ImageSource.gallery);
      if(pickedFile != null){
        setState(() {
          imageFile = File(pickedFile.path);
          _isPicked = true;
        });
      }
      }
    }
  }
}
