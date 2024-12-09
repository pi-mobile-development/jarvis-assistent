import 'package:flutter/material.dart';
import 'package:jarvis_assistant/Themes/themes.dart';
import 'package:jarvis_assistant/Chat/chat_view.dart';
import 'package:jarvis_assistant/Login/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController loginController = LoginController();
  double radius = 12;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: _buildAppBar(),
        body: SizedBox.expand(
          child: Container(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 20, 24, 0),
            color: AppTheme.primaryColor,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 10),
                _logo(),
                const SizedBox(height: 40),
                _welcomeText(),
                const SizedBox(height: 50),
                _googleButton(),
                if (_isLoading) _loadingIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Image.asset('assets/jarvis_without_background.png');
  }

  Widget _welcomeText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
            Text(
              "Seja bem vindo ao assistente Jarvis",
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontSize: 19,
                color: AppTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 10),
          Text(
            "Faça login com sua conta Google para que eu possa lhe auxiliar em seus desejos.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      )
    );
  }

  Widget _googleButton() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
      child: TextButton(
        onPressed: () async {
          setState(() {
            _isLoading = true; // Inicia o carregamento
          });

          var success = await loginController.loginGoogle();
          if (success) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatView()),
            );
          } else {
            debugPrint("Falha no login");
          }

          setState(() {
            _isLoading = false; // Para o carregamento
          });
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(const Color(0xff9489F5)),
          foregroundColor: WidgetStateProperty.all<Color>(AppTheme.textColor),
          minimumSize: WidgetStateProperty.all<Size>(const Size(300, 60)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("G", style: TextStyle(fontSize: 22)),
            SizedBox(width: 12),
            Text("Entrar com o Google", style: TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.appBarColor,
      centerTitle: true,
      title: Text(
        'Jarvis Assistant',
        style: TextStyle(color: AppTheme.textColor, fontWeight: FontWeight.bold),
      ),
      iconTheme: IconThemeData(
        color: AppTheme.secondaryColor,
      ),
    );
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.textColor), // Cor do indicador
      ),
    );
  }
}
