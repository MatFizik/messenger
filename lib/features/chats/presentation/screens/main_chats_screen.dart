import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/common/models/user_model.dart';
import 'package:messenger/common/widgets/snackbar/snackbar.dart';
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
  List<QueryDocumentSnapshot<Object?>>? chats;
  List<QueryDocumentSnapshot<Object?>>? filteredChats;
  bool isSearching = false;
  UserModel? userModel;

  @override
  void initState() {
    loadUser();
    super.initState();
  }

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

  void onSearch(String value) {
    isSearching = true;
    value = value.toLowerCase();
    setState(() {
      filteredChats = chats
          ?.where((element) => element['name']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> loadUser() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('users').doc(uid).get();
        if (userDoc.exists) {
          setState(() {
            userModel = UserModel.fromMap(userDoc.data()!);
            userModel?.name = utf8.decode(base64Decode(userModel!.name));
            userModel?.lastName =
                utf8.decode(base64Decode(userModel!.lastName));
            userModel?.fullName =
                utf8.decode(base64Decode(userModel!.fullName ?? ''));
          });
        }
      } catch (e) {
        AppSnackBar.showSnackBar(
          context,
          'Ошибка загрузки пользователя',
        );
      }
    }
  }

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
              onChanged: (v) => onSearch(v),
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

                  chats = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount:
                        isSearching ? filteredChats?.length : chats?.length,
                    itemBuilder: (context, index) {
                      var chat =
                          isSearching ? filteredChats![index] : chats?[index];
                      return Dismissible(
                        background: Container(
                          color: Colors.red,
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          _firestore.collection('chats').doc(chat.id).update({
                            'users': FieldValue.arrayRemove(
                                [FirebaseAuth.instance.currentUser?.uid])
                          });
                        },
                        direction: DismissDirection.endToStart,
                        key: Key(chat?.id ?? ''),
                        child: ChatTileWidget(
                          onTap: () => _openChatScreen(chat.id.trim()),
                          avatarUrl: null,
                          name: userModel?.fullName ==
                                  (utf8.decode(base64Decode(
                                      chat?['name_first'].toString() ?? '')))
                              ? utf8.decode(
                                  base64Decode(chat!['name_second'].toString()))
                              : utf8.decode(
                                  base64Decode(chat!['name_first'].toString())),
                          lastMessage: utf8.decode(
                              base64Decode(chat['lastMessage'].toString())),
                          timestamp: chat['last_message_date'],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => createChat(),
                  icon: const Icon(
                    Icons.add,
                    size: 32,
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
