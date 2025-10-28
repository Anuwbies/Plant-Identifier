import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../color/app_colors.dart';
import 'chat_page_model.dart';

class ChatPage extends StatelessWidget {
  final String plantName;
  final String scientificName;

  const ChatPage({
    super.key,
    required this.plantName,
    required this.scientificName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatPageModel(
        plantName: plantName,
        scientificName: scientificName,
      ),
      child: const _ChatPageView(),
    );
  }
}

class _ChatPageView extends StatelessWidget {
  const _ChatPageView();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ChatPageModel>();

    return Scaffold(
      backgroundColor: AppColors.surfaceA0,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: AppColors.surfaceA0,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      LucideIcons.arrowLeft,
                      size: 28,
                      color: AppColors.surfaceA80,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.plantName,
                        style: const TextStyle(
                          color: AppColors.surfaceA80,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        model.scientificName,
                        style: const TextStyle(
                          color: AppColors.surfaceA60,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 1, color: AppColors.surfaceA30),

            // Messages
            Expanded(
              child: ListView.builder(
                controller: model.scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: model.messages.length,
                itemBuilder: (context, index) {
                  final msg = model.messages[index];
                  final isUser = msg['role'] == 'user';
                  final isBot = msg['role'] == 'bot';

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
                              : isBot
                              ? AppColors.primaryDark10
                              : AppColors.surfaceA90,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Input Bar
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: model.controller,
                          decoration: InputDecoration(
                            hintText: 'Ask anything',
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
                          onSubmitted: (_) => model.sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: model.isSending
                            ? const Icon(Icons.hourglass_top)
                            : const Icon(Icons.send),
                        onPressed: model.sendMessage,
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
