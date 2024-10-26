import 'package:flutter/material.dart';
import 'package:jarvis_assistent/Chat/message_model.dart';
import 'package:jarvis_assistent/Utils/configs.dart';
import 'package:jarvis_assistent/Utils/utils.dart';
import 'package:jarvis_assistent/Themes/themes.dart';
import 'package:jarvis_assistent/About/about_screen.dart';
import 'package:jarvis_assistent/Login/login_view.dart';
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
            icon: const Icon(Icons.camera_alt),
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
            leading: Icon(Icons.logout, color: AppTheme.secondaryColor),
            title: const Text('Logout'),
            textColor: AppTheme.textColor,
            onTap: () async {
              await signOut();
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
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
      setState(() {
        _messages
            .add(MessageModel(message: prompt, messageFrom: MessageFrom.USER));
        _textInputController.clear();
        scrollDown();
      });

      setState(() {
        _messages.add(MessageModel(
            message: 'Resposta padrao', messageFrom: MessageFrom.IA));
        scrollDown();
      });
    }
  }

  void _recordAudio() {
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  Future<void> _pickImage() async {
    if (await Permission.camera.request().isGranted) {
      //camera
    }
  }
}
