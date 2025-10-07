import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../api/ollama_api.dart';
import '../../color/app_colors.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final OllamaApi _api = const OllamaApi();

  bool _isSending = false;

  void _sendMessage() {
    if (_isSending) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _messages.add({'role': 'bot', 'text': ''});
      _controller.clear();
      _isSending = true;
    });

    _scrollToBottom();
    _streamReply(text);
  }

  void _streamReply(String userText) async {
    final botIndex = _messages.lastIndexWhere((msg) => msg['role'] == 'bot');

    try {
      await for (var chunk in _api.streamPrompt(
        model: 'Allen_Rodas11/llama3-plant:latest',
        prompt: userText,
      )) {
        setState(() {
          _messages[botIndex]['text'] =
              _messages[botIndex]['text']! + chunk;
        });
        _scrollToBottom();
      }
    } catch (e) {
      setState(() {
        _messages[botIndex]['text'] = 'Error: $e';
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _addInitialBotMessage();
  }

  void _addInitialBotMessage() {
    setState(() {
      _messages.add({
        'role': 'bot',
        'text': 'Hello! I am your assistant. Feel free to ask me anything.'
      });
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.surfaceA0,
      body: SafeArea(
        child: Column(
          children: [
            // Simple app bar
            Container(
              color: AppColors.surfaceA0,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: const [
                  Icon(LucideIcons.bot, color: AppColors.surfaceA80, size: 28),
                  SizedBox(width: 8),
                  Text(
                    "Chat-bot",
                    style: TextStyle(
                      color: AppColors.surfaceA80,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1.5, color: AppColors.surfaceA30),
            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg['role'] == 'user';
                  return Align(
                    alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color:
                        isUser ? AppColors.primaryDark10 : AppColors.surfaceA10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg['text'] ?? '',
                        style: TextStyle(
                          color: isUser
                              ? Colors.white
                              : AppColors.primaryDark10,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Input bar
            Padding(
              padding: const EdgeInsets.fromLTRB(8,8,80,8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything',
                        filled: true,
                        fillColor: AppColors.surfaceA20,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 0),
                  IconButton(
                    icon: _isSending
                        ? const Icon(Icons.hourglass_top)
                        : const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
