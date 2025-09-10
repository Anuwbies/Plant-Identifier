import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../api/ollama_api.dart';
import '../../color/app_colors.dart';

class ChatPage extends StatefulWidget {
  final String plantName;
  final String scientificName;

  const ChatPage({
    super.key,
    required this.plantName,
    required this.scientificName,
  });

  @override
  State<ChatPage> createState() => _ChatPagesState();
}

class _ChatPagesState extends State<ChatPage> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final OllamaApi _api = const OllamaApi();

  bool _isSending = false;

  void _sendMessage() {
    if (_isSending) return; // prevent sending multiple prompts
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

    final prompt =
        "I will give you a user prompt. Provide answers primarily about "
        "${widget.plantName} (${widget.scientificName}).\n\n"
        "Instruction: If the user prompt is not directly about this plant, "
        "you may gently remind to ask about it, but you can still "
        "give a polite, general response if appropriate.\n\n"
        "User prompt: $userText";

    try {
      await for (var chunk in _api.streamPrompt(model: 'llama3.2:1b', prompt: prompt)) {
        setState(() {
          _messages[botIndex]['text'] = _messages[botIndex]['text']! + chunk;
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
        'text': 'Hello! I am your plant guide for '
            '${widget.plantName} (${widget.scientificName}). '
            'I can provide details about its characteristics, uses, care tips, '
            'or interesting facts. Feel free to ask anything related to this plant!'
      });
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceA0,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed AppBar replacement
            Container(
              color: AppColors.surfaceA0,
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(LucideIcons.arrowLeft,
                        size: 28, color: AppColors.surfaceA80),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.plantName,
                        style: const TextStyle(
                            color: AppColors.surfaceA80, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        widget.scientificName,
                        style: const TextStyle(
                            color: AppColors.surfaceA60, fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: AppColors.surfaceA30,
            ),
            // Chat messages
            Expanded(
              child: Container(
                color: AppColors.surfaceA0,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 16, bottom: 16, left: 12, right: 12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg['role'] == 'user';
                    final isBot = msg['role'] == 'bot';
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: isUser
                              ? AppColors.primaryDark10
                              : AppColors.surfaceA10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg['text'] ?? '',
                          style: TextStyle(
                            color: isUser
                                ? Colors.white
                                : isBot
                                ? AppColors.primaryDark10 // Bot reply color
                                : AppColors.surfaceA90,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Bottom input
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceA0,
                    border: Border(
                      top: BorderSide(
                        color: AppColors.surfaceA30,
                        width: 1,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Ask anything',
                            filled: true,
                            fillColor: AppColors.surfaceA20,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: _isSending
                            ? const Icon(Icons.hourglass_top) // different icon while waiting
                            : const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
