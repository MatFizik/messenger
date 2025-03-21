import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/common/theme/app_colors.dart';
import 'package:messenger/common/utils/letters_avatar/letters_avatar_widget.dart';
import 'package:messenger/features/chats/presentation/widgets/messenge_bubble_widget.dart';
import 'package:messenger/features/chats/presentation/widgets/messenge_own_bubble_widget.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String name;

  const ChatScreen({
    super.key,
    required this.name,
    required this.chatId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

TextEditingController _controller = TextEditingController();

class _ChatScreenState extends State<ChatScreen> {
  void _sendMessenge() {
    final String base64LastMessage =
        base64Encode(utf8.encode(_controller.text));
    if (_controller.text.isNotEmpty) {
      _firestore.collection('messenges').add({
        'chat_id': widget.chatId,
        'sender': FirebaseAuth.instance.currentUser?.uid,
        'text': _controller.text,
        'date_send': Timestamp.now(),
      });
      _firestore.collection('chats').doc(widget.chatId).update({
        'lastMessage': base64LastMessage,
        'last_message_date': Timestamp.now(),
      });

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: getAvatar(widget.name, ''),
              ),
              const SizedBox(width: 8),
              Text(widget.name),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 24.0),
        child: Column(
          children: [
            const Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messenges')
                    .where(
                      'chat_id',
                      isEqualTo: widget.chatId.toString(),
                    )
                    .orderBy('date_send', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Здесь пока нет сообщений'),
                    );
                  }

                  var messenges = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messenges.length,
                    itemBuilder: (context, index) {
                      var messenge = messenges[index];
                      return Column(
                        children: [
                          messenge['sender'].toString() !=
                                  FirebaseAuth.instance.currentUser?.uid
                              ? MessageBubbleWidget(
                                  message: messenge['text'].toString(),
                                  time: (messenge['date_send'] as Timestamp)
                                      .toDate()
                                      .toString()
                                      .substring(11, 16),
                                )
                              : MessengeOwnBubbleWidget(
                                  message: messenge['text'].toString(),
                                  time: (messenge['date_send'] as Timestamp)
                                      .toDate()
                                      .toString()
                                      .substring(11, 16),
                                ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: 5,
                    minLines: 1,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.lightBgSecondary,
                      hintStyle: TextStyle(color: AppColors.textTertiaryLight),
                      hintText: 'Сообщение',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: AppColors.lightBgSecondary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: AppColors.lightBgSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _sendMessenge(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color:
                          Theme.of(context).buttonTheme.colorScheme?.secondary,
                    ),
                    width: 42,
                    height: 42,
                    child: const Icon(Icons.send),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
