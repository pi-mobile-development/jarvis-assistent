import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarvis_assistant/Prompt/prompt_controller.dart';
import 'package:jarvis_assistant/Themes/themes.dart';
import 'prompt_model.dart';


class PromptsScreen extends StatefulWidget {
  const PromptsScreen({super.key});

  @override
  _PromptsScreenState createState() => _PromptsScreenState();
}

class _PromptsScreenState extends State<PromptsScreen> {
  PromptController _controller = PromptController();
  List<Prompt> _prompts = [];
  bool _updated = true;

  Future<void> _updatePrompts() async {
    final data = await _controller.getAllPrompts();
    setState(() {
      _prompts = data;
      _updated = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _updatePrompts();
  }

  void _openUpdatePromptModal(Prompt prompt) {
    TextEditingController titleController = TextEditingController(text: prompt.title);
    TextEditingController textController = TextEditingController(text: prompt.prompt);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.primaryColor,
          title: Text('Editar Prompt', style: TextStyle(color: AppTheme.textColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: AppTheme.textColor),
                ),
                style: TextStyle(color: AppTheme.textColor),
              ),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Texto do prompt',
                  labelStyle: TextStyle(color: AppTheme.textColor),
                ),
                style: TextStyle(color: AppTheme.textColor),
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty && textController.text.isNotEmpty) {
                  await _controller.updatePrompt(prompt, titleController.text, textController.text);
                  Navigator.pop(context);
                  await _updatePrompts();
                } else {
                  _inputTextErrorMessage();
                }
              },
              child: Text('Salvar', style: TextStyle(color: AppTheme.secondaryColor)),
            ),
            TextButton(
              onPressed: () => _confirmDeletePrompt(prompt),
              child: Text('Apagar', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: TextStyle(color: AppTheme.secondaryColor)),
            ),
          ],
        );
      },
    );
  }

  // Show a confirmation dialog before deleting a prompt
  void _confirmDeletePrompt(Prompt prompt) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.primaryColor,
          title: Text('Confirmar exclusão', style: TextStyle(color: AppTheme.textColor)),
          content: Text(
            'Tem certeza de que deseja excluir este prompt? Esta ação não pode ser desfeita.',
            style: TextStyle(color: AppTheme.textColor),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _controller.deletePrompt(prompt.id!);
                Navigator.pop(context); // Close confirmation dialog
                Navigator.pop(context); // Close edit modal
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Prompt apagado!'),
                ));
                await _updatePrompts();
              },
              child: Text('Deletar', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: TextStyle(color: AppTheme.secondaryColor)),
            ),
          ],
        );
      },
    );
  }

  // Opens a modal to create a new prompt
  void _openCreateNewPromptModal() {
    TextEditingController titleController = TextEditingController();
    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.primaryColor,
          title: Text('Criar um novo prompt', style: TextStyle(color: AppTheme.textColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: AppTheme.textColor),
                ),
                style: TextStyle(color: AppTheme.textColor),
              ),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Texto do prompt',
                  labelStyle: TextStyle(color: AppTheme.textColor),
                ),
                style: TextStyle(color: AppTheme.textColor),
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty && textController.text.isNotEmpty) {
                  await _controller.addPrompt(titleController.text, textController.text);
                  Navigator.pop(context); // Close the modal after saving
                  await _updatePrompts();
                } else {
                  _inputTextErrorMessage();
                }
              },
              child: Text('Salvar', style: TextStyle(color: AppTheme.secondaryColor)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: TextStyle(color: AppTheme.secondaryColor)),
            ),
          ],
        );
      },
    );
  }

  // Copies the prompt text to the clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Prompt copiado para área de transferência.')),
    );
  }

  String _formatDate(String isoDate) {
    List<String> dateParts = isoDate.substring(0, 10).split('-');

    return '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prompts', style: TextStyle(color: AppTheme.textColor)),
        backgroundColor: AppTheme.appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.secondaryColor), // Botão de voltar, VOLTA VIDA
          onPressed: () {
            Navigator.pop(context); // Trocar pra tela principal, tem que fazer esse codiguin ai
          },
        )
      ),
      backgroundColor: AppTheme.primaryColor,
      body: _updated
          ? const Center(child: CircularProgressIndicator())
          :ListView.builder(
            itemCount: _prompts.length,
            itemBuilder: (context, index) {
              final prompt = _prompts[index];
              return Card(
                color: AppTheme.primaryColor.withOpacity(0.1), // Slightly lighter color for card background
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(prompt.title, style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textColor)),
                      IconButton(
                        icon: Icon(Icons.copy, color: AppTheme.secondaryColor),
                        onPressed: () => _copyToClipboard(prompt.prompt),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(prompt.prompt, style: TextStyle(color: AppTheme.textColor)),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Criado em: ${_formatDate(prompt.createdAt)}',
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          ),
                          Text(
                            'Atualizado em: ${_formatDate(prompt.updatedAt)}',
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () => _openUpdatePromptModal(prompt),
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateNewPromptModal,
        backgroundColor: AppTheme.secondaryColor,
        child: Icon(Icons.add, color: AppTheme.textColor),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _inputTextErrorMessage() {
    return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Os campos "Título" e "Texto" não podem ser vazios!'),
    ));
  }
}
