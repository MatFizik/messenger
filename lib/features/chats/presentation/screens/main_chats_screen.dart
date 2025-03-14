import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/features/chats/presentation/screens/chat_screen.dart';
import 'package:messenger/features/chats/presentation/widgets/chat_tile_widget.dart';
import 'package:messenger/features/chats/presentation/screens/create_chat.dart';
import 'package:messenger/features/chats/presentation/widgets/custom_search_textfield.dart';
import 'package:messenger/features/settings/presentation/settings_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _openChatScreen(String chatId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(chatId: chatId),
      ),
    );
  }

  void createChat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateChat(),
      ),
    );
  }

  void onSearch(String value) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Чаты',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              ),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          bottom: 24.0,
        ),
        child: Column(
          children: [
            CustomSearchTextfield(
              onChanged: onSearch,
              filter: true,
            ),
            const SizedBox(height: 24),
            const Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .where(
                      'users',
                      arrayContains: FirebaseAuth.instance.currentUser?.uid,
                    )
                    .orderBy('last_message_date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Чатов нет'),
                    );
                  }

                  var chats = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      var chat = chats[index];
                      return ChatTileWidget(
                        onTap: () => _openChatScreen(chat.id.trim()),
                        avatarUrl:
                            'https://randomuser.me/api/portraits/men/22.jpg',
                        name: chat['name'].toString(),
                        lastMessage: chat['lastMessage'].toString(),
                        timestamp: chat['last_message_date'],
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => createChat(),
                  label: const Text('Create chat'),
                  icon: const Icon(
                    Icons.add,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
