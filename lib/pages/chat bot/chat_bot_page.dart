import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../color/app_colors.dart';
import 'chat_bot_page_model.dart';

class ChatBotPage extends StatelessWidget {
  const ChatBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatBotPageModel(),
      child: const _ChatBotPageView(),
    );
  }
}

class _ChatBotPageView extends StatelessWidget {
  const _ChatBotPageView();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ChatBotPageModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                controller: model.scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: model.messages.length,
                itemBuilder: (context, index) {
                  final msg = model.messages[index];
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
              padding: const EdgeInsets.fromLTRB(8, 8, 80, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: model.controller,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything',
                        filled: true,
                        fillColor: AppColors.surfaceA20,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => model.sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 0),
                  IconButton(
                    icon: model.isSending
                        ? const Icon(Icons.hourglass_top)
                        : const Icon(Icons.send),
                    onPressed: model.sendMessage,
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
