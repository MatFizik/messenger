import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/common/theme/app_colors.dart';
import 'package:messenger/common/utils/letters_avatar/letters_avatar_widget.dart';
import 'package:messenger/features/chats/presentation/widgets/divider_messenge_widget.dart';
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
  String? editingMessageId;

  void _sendMessenge() {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;

    final String base64LastMessage = base64Encode(utf8.encode(text));

    if (editingMessageId != null) {
      _firestore.collection('messenges').doc(editingMessageId).update({
        'text': text,
        'edited': true,
      });
      setState(() {
        editingMessageId = null;
      });
    } else {
      _firestore.collection('messenges').add({
        'chat_id': widget.chatId,
        'sender': FirebaseAuth.instance.currentUser?.uid,
        'text': text,
        'date_send': Timestamp.now(),
      });
      _firestore.collection('chats').doc(widget.chatId).update({
        'lastMessage': base64LastMessage,
        'last_message_date': Timestamp.now(),
      });
    }

    _controller.clear();
  }

  void _showOptions(
    BuildContext context,
    String messageId,
    String currentText,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                shape: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
                leading: const Icon(Icons.edit),
                title: const Text('Изменить'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    editingMessageId = messageId;
                    _controller.text = currentText;
                  });
                },
              ),
              ListTile(
                shape: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Удалить',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _firestore.collection('messenges').doc(messageId).delete();
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Отмена'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getDate(int index, List<QueryDocumentSnapshot> messages) {
    final currentMessage = messages[index];
    final currentDate = (currentMessage['date_send'] as Timestamp).toDate();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    String dateString;
    if (messageDate == today) {
      dateString = 'Сегодня';
    } else if (messageDate == yesterday) {
      dateString = 'Вчера';
    } else {
      String day = currentDate.day.toString().padLeft(2, '0');
      String month = currentDate.month.toString().padLeft(2, '0');
      String year = (currentDate.year % 100).toString().padLeft(2, '0');
      dateString = '$day.$month.$year';
    }

    if (index == messages.length - 1) {
      return DividerMessengeWidget(date: dateString);
    }

    final previousMessage = messages[index + 1];
    final previousDate = (previousMessage['date_send'] as Timestamp).toDate();
    final previousDateString = previousDate.toString().substring(0, 10);

    final currentDateIso = currentDate.toString().substring(0, 10);

    if (currentDateIso != previousDateString) {
      return DividerMessengeWidget(date: dateString);
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          shape: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          title: Row(
            children: [
              SizedBox(
                width: 40,
                child: getAvatar(
                  name: widget.name,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
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
                      final data = messenge.data() as Map<String, dynamic>;
                      return Column(
                        children: [
                          getDate(index, messenges),
                          data['sender'].toString() !=
                                  FirebaseAuth.instance.currentUser?.uid
                              ? MessageBubbleWidget(
                                  message: data['text'].toString(),
                                  edited: data['edited'] ?? false,
                                  time: (data['date_send'] as Timestamp)
                                      .toDate()
                                      .toString()
                                      .substring(11, 16),
                                )
                              : GestureDetector(
                                  onLongPress: () {
                                    _showOptions(
                                      context,
                                      messenge.id,
                                      data['text'].toString(),
                                    );
                                  },
                                  child: MessengeOwnBubbleWidget(
                                    message: data['text'].toString(),
                                    edited: data['edited'] ?? false,
                                    time: (data['date_send'] as Timestamp)
                                        .toDate()
                                        .toString()
                                        .substring(11, 16),
                                  ),
                                ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.fromBorderSide(
                  BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 14,
                  left: 12,
                  right: 12,
                  bottom: Platform.isIOS ? 36 : 18,
                ),
                child: Row(
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
                          hintStyle:
                              TextStyle(color: AppColors.textTertiaryLight),
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
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme
                              ?.secondary,
                        ),
                        width: 45,
                        height: 45,
                        child: const Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
