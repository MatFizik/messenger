import 'package:flutter/material.dart';
import 'package:messenger/features/chats/presentation/widgets/messenge_bubble_widget.dart';
import 'package:messenger/features/chats/presentation/widgets/messenge_own_bubble_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  MessageBubbleWidget(
                    message: 'Привет, как ты?',
                    time: '10:00',
                  ),
                  MessengeOwnBubbleWidget(
                    message: 'Нормально, спасибо',
                    time: '10:01',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Сегодня',
                          ),
                        ),
                        Expanded(
                          child: Divider(thickness: 1),
                        ),
                      ],
                    ),
                  ),
                  MessengeOwnBubbleWidget(
                    message: 'Как сам?',
                    time: '10:02',
                  ),
                  MessageBubbleWidget(
                    message: 'Да и я тоже нормально',
                    time: '10:03',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
