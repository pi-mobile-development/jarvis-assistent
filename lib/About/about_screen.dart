import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  final List<Map<String, String>> collaborators = [
    {"name": "Rodrigo Fuchs"},
    {"name": "Rodrigo Reis"},
    {"name": "Enzo Rodrigues"},
    {"name": "Italo Henrique"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282A36), // Fundo estilo Dracula
      appBar: AppBar(
        backgroundColor: const Color(0xFF44475A), // AppBar no tema Dracula
        title: const Text("Sobre o App", style: TextStyle(color: Color(0xFFF8F8F2))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color(0xFF8BE9FD)), // Botão de voltar, VOLTA VIDA
          onPressed: () {
            Navigator.pop(
                context); // Trocar pra tela principal, tem que fazer esse codiguin ai
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bloco 1: Nome, Versão e Logo (ILO)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF44475A), // Fundo do bloco estilo Dracula
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // Sombra leve
                    blurRadius: 6,
                    offset: const Offset(2, 4), // Deslocamento sutil para relevo
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1), // Destaque sutil
                    blurRadius: 6,
                    offset: const Offset(-2, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.network(
                    "https://media.licdn.com/dms/image/v2/D4D22AQFkFzGjFcVSEg/feedshare-shrink_2048_1536/feedshare-shrink_2048_1536/0/1718460036903?e=2147483647&v=beta&t=81wRif-_BQNbBrqhtKfoQX6mD5xd-5CI-9QjSaABkxI", // FACA LOGO DO APP
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jarvis", // Nome do app
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 24,
                            color: Color(0xFFF8F8F2), // Texto claro
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "1.4.2", // Versão do app
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6272A4), // Texto secundário
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bloco 2: Colaboradores
            Text(
              "Colaboradores",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF8F8F2), // Texto claro
                ),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: collaborators.map((collaborator) {
                return Card(
                  color: const Color(0xFF44475A), // Fundo do card de colaborador
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor:
                          Color(0xFF6272A4), // Cor de fundo do ícone de perfil
                      child: Icon(
                        Icons.person, // Ícone de perfil padrão (silhueta)
                        color: Color(0xFFF8F8F2), // Cor do ícone (texto claro)
                        size: 30,
                      ),
                    ),
                    title: Text(
                      collaborator["name"]!,
                      style: const TextStyle(
                        color: Color(0xFFF8F8F2), // Texto claro
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Bloco 3: Descrição ou nao nao sei ainda
            const SizedBox(height: 20),
            Text(
              "Descrição",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF8F8F2), // Texto claro
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "O Jarvis é um assistente virtual projetado para auxiliar em uma ampla gama de tarefas. "
              "Ele opera através de comandos de voz, texto e possui a capacidade de reconhecer imagens, "
              "proporcionando uma experiência interativa e intuitiva.",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Color(0xFF6272A4), // Texto secundário
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
