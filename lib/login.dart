import 'package:flutter/material.dart';
import 'package:jarvis_assistent/Themes/themes.dart';
import 'package:jarvis_assistent/main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TODO: Modelo de banco de dados para página de login
  // late LoginPageModel _model;

  double radius = 12;
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
                _fullNameInput(),
                _emailInput(),
                _senhaInput(),
                _loginButtons(),
                _googleButton(),
                _createAccountButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fullNameInput() {
    return Padding( // Input de Email
      padding: const EdgeInsetsDirectional.fromSTEB(100, 20, 100, 0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: 18,
          color: AppTheme.textColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2
        ),
        decoration: InputDecoration(
          labelText: "Nome completo",
          labelStyle: TextStyle(color: AppTheme.textColor),
          hintText: "Digite seu nome",
          hintStyle: TextStyle(color: AppTheme.textColor),
          enabledBorder: AppTheme.outlineInputBorder,
          fillColor: AppTheme.appBarColor,
          focusedBorder: AppTheme.outlineInputBorder,
          filled: true,
        ),
      )
    );
  }

  Widget _emailInput() {
    return Padding( // Input de Email
      padding: const EdgeInsetsDirectional.fromSTEB(100, 20, 100, 0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: 18,
          color: AppTheme.textColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2
        ),
        decoration: InputDecoration(
          labelText: "Email",
          labelStyle: TextStyle(color: AppTheme.textColor),
          hintText: "Digite seu E-mail",
          hintStyle: TextStyle(color: AppTheme.textColor),
          enabledBorder: AppTheme.outlineInputBorder,
          fillColor: AppTheme.appBarColor,
          focusedBorder: AppTheme.outlineInputBorder,
          filled: true,
        ),
      )
    );
  }

  Widget _senhaInput(){
    return Padding( // Input de Senha
      padding: const EdgeInsetsDirectional.fromSTEB(100, 20, 100, 0),
      child: TextField(
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        style: TextStyle(
          fontSize: 18,
          color: AppTheme.textColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2
        ),
        decoration: InputDecoration(
          labelText: "Senha",
          labelStyle: TextStyle(color: AppTheme.textColor),
          hintText: "Digite sua senha",
          hintStyle: TextStyle(color: AppTheme.textColor),
          enabledBorder: AppTheme.outlineInputBorder,
          fillColor: AppTheme.appBarColor,
          focusedBorder: AppTheme.outlineInputBorder,
          filled: true,
        ),
      )
    );
  }

  Widget _googleButton(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => Mainscreen())
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(const Color(0xff9489F5)),
              foregroundColor: WidgetStateProperty.all<Color>(AppTheme.textColor),
              minimumSize: WidgetStateProperty.all<Size>(const Size(300, 60)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "G",
                  style: TextStyle(fontSize: 22)
                ),
                SizedBox(width: 12), // Espaço entre o ícone e o texto
                Text(
                  "Entrar com o Google",
                  style: TextStyle(fontSize: 22),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _loginButtons(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24),
          child: TextButton(
            onPressed: () { /* ! Funcionalidade de criar conta aqui */ },
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Colors.pink),
              minimumSize: WidgetStateProperty.all<Size>(const Size(120, 50)),
            ),
            child: Text(
              "Esqueceu a senha?",
              style: TextStyle(
                fontSize: 22,
                color: AppTheme.textColor, 
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => Mainscreen())
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(const Color(0xff9489F5)),
              foregroundColor: WidgetStateProperty.all<Color>(AppTheme.textColor),
              minimumSize: WidgetStateProperty.all<Size>(const Size(120, 50)),
            ),
            child: const Text(
              "Entrar",
              style: TextStyle(fontSize: 22),
            ),
          ),
        )
      ],
    );
  }

  Widget _createAccountButton(){
    return const Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(24, 0, 4, 0),
          child: Text(
            "Criar conta",
            style: TextStyle(
              fontSize: 22,
              color: Color(0xff9489F5), 
            ),
          )
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 4, 0),
          child: Icon(
            Icons.arrow_forward,
            color: Color(0xff9489F5),
          )
        )
      ]
    );
  }

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
}
