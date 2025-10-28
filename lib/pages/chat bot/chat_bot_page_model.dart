import 'dart:async';
import 'package:flutter/material.dart';
import '../../api/ollama_api.dart';

class ChatBotPageModel extends ChangeNotifier {
  final OllamaApi _api = const OllamaApi();
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isSending = false;

  ChatBotPageModel() {
    _addInitialBotMessage();
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

    try {
      await for (var chunk in _api.streamPrompt(
        model: 'Allen_Rodas11/llama3-plant:latest',
        prompt: userText,
      )) {
        messages[botIndex]['text'] =
            messages[botIndex]['text']! + chunk;
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

  void _addInitialBotMessage() {
    messages.add({
      'role': 'bot',
      'text': 'Hello! I am your assistant. Feel free to ask me anything.'
    });
    _scrollToBottom();
    notifyListeners();
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
