import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/features/chats/presentation/screens/chat_screen.dart';
import 'package:messenger/features/chats/presentation/widgets/chat_tile_widget.dart';
import 'package:messenger/features/chats/presentation/widgets/custom_search_textfield.dart';

class CreateChat extends StatefulWidget {
  const CreateChat({super.key});

  @override
  State<CreateChat> createState() => _CreateChatState();
}

String searchValue = '';

class _CreateChatState extends State<CreateChat> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void onSearch(String value) {
    setState(() {
      searchValue = value;
    });
  }

  void _openChatScreen(BuildContext context, String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final chatQuery = await _firestore
        .collection('chats')
        .where('users', isEqualTo: [userId, currentUser.uid]).get();

    String? chatId;

    for (var doc in chatQuery.docs) {
      var users = doc['users'] as List<dynamic>;
      if (users.contains(userId)) {
        chatId = doc.id;
        break;
      }
    }

    String nameSecond = await _firestore
        .collection('users')
        .doc(userId)
        .get()
        .then((value) => value['full_name']);
    if (chatId == null) {
      var newChatRef = _firestore.collection('chats').doc();
      await newChatRef.set({
        'users': [currentUser.uid, userId],
        'lastMessage': '',
        'messenges': [],
        'name_first':
            '${await _firestore.collection('users').doc(userId).get().then((value) => value['full_name'])}',
        'name_second': currentUser.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      chatId = newChatRef.id;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          chatId: chatId!,
          name: utf8.decode(base64Decode(nameSecond)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomSearchTextfield(
          onChanged: onSearch,
          filter: true,
        ),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 24.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Чатов нет'));
              }

              final currentUserId = FirebaseAuth.instance.currentUser?.uid;

              var users = snapshot.data!.docs.where((user) {
                return user.id != currentUserId;
              }).toList();

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  return ChatTileWidget(
                    onTap: () => _openChatScreen(context, user.id),
                    avatarUrl: null,
                    name:
                        utf8.decode(base64Decode(user['full_name'].toString())),
                    lastMessage: '',
                    timestamp: null,
                  );
                },
              );
            },
          )),
    );
  }
}
