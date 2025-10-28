import 'package:flutter/material.dart';
import '../../api/ollama_api.dart';

class ChatPageModel extends ChangeNotifier {
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final OllamaApi api = const OllamaApi();

  bool isSending = false;

  final String plantName;
  final String scientificName;

  ChatPageModel({
    required this.plantName,
    required this.scientificName,
  }) {
    _addInitialBotMessage();
  }

  void _addInitialBotMessage() {
    messages.add({
      'role': 'bot',
      'text': 'Hello! I am your plant guide for '
          '$plantName ($scientificName). '
          'I can provide details about its characteristics, uses, care tips, '
          'or interesting facts. Feel free to ask anything related to this plant!'
    });
    notifyListeners();
    _scrollToBottom();
  }

  void sendMessage() {
    if (isSending) return;
    final text = controller.text.trim();
    if (text.isEmpty) return;

    messages.add({'role': 'user', 'text': text});
    messages.add({'role': 'bot', 'text': ''});
    controller.clear();
    isSending = true;
    notifyListeners();

    _scrollToBottom();
    _streamReply(text);
  }

  Future<void> _streamReply(String userText) async {
    final botIndex = messages.lastIndexWhere((msg) => msg['role'] == 'bot');

    final prompt =
        "I will give you a user prompt. Provide answers primarily about "
        "$plantName ($scientificName).\n\n"
        "Instruction: If the user prompt is not directly about this plant, "
        "you may gently remind to ask about it, but you can still "
        "give a polite, general response if appropriate.\n\n"
        "User prompt: $userText";

    try {
      await for (var chunk in api.streamPrompt(model: 'llama3.2:1b', prompt: prompt)) {
        messages[botIndex]['text'] = messages[botIndex]['text']! + chunk;
        notifyListeners();
        _scrollToBottom();
      }
    } catch (e) {
      messages[botIndex]['text'] = 'Error: $e';
      notifyListeners();
    } finally {
      isSending = false;
      notifyListeners();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
