import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/features/auth/presentation/screens/auth_screen.dart';
import 'package:messenger/features/chats/presentation/screens/chat_screen.dart';
import 'package:messenger/features/chats/presentation/widgets/chat_tile_widget.dart';
import 'package:messenger/features/chats/presentation/widgets/create_chat.dart';
import 'package:messenger/features/chats/presentation/widgets/custom_search_textfield.dart';

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
        title: CustomSearchTextfield(
          onChanged: onSearch,
          filter: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 24.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .where(
                      'users',
                      arrayContains: FirebaseAuth.instance.currentUser?.uid,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Чатов нет'));
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
                        timestamp: (chat['timestamp'] ?? '' as Timestamp)
                            .toDate()
                            .toString()
                            .substring(0, 10)
                            .replaceAll('-', '.'),
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const AuthScreen()),
                    );
                  },
                  label: const Text('Exit'),
                  icon: const Icon(
                    Icons.exit_to_app,
                  ),
                ),
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
