import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/features/chats/presentation/screens/chat_screen.dart';
import 'package:messenger/features/chats/presentation/widgets/chat_tile_widget.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final List<Map<String, String>> chats = [
    {
      'avatarUrl': 'https://randomuser.me/api/portraits/men/1.jpg',
      'name': 'Макдональдс',
      'lastMessage': 'Хочешь хавать?',
      'timestamp': '10:30',
    },
    {
      'avatarUrl': 'https://randomuser.me/api/portraits/men/2.jpg',
      'name': 'Шефф',
      'lastMessage': 'И где ты?',
      'timestamp': '09:01',
    },
    {
      'avatarUrl': 'https://randomuser.me/api/portraits/women/3.jpg',
      'name': 'Alice',
      'lastMessage': 'See you soon.',
      'timestamp': '12:15',
    },
    {
      'avatarUrl': 'https://randomuser.me/api/portraits/men/4.jpg',
      'name': 'Братишка',
      'lastMessage': 'Давай пока!',
      'timestamp': '01:45',
    },
  ];

  void _openChatScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ChatScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ChatTileWidget(
            onTap: _openChatScreen,
            avatarUrl: chat['avatarUrl']!,
            name: chat['name']!,
            lastMessage: chat['lastMessage']!,
            timestamp: chat['timestamp']!,
          );
        },
      ),
    );
  }
}
