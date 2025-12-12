import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/common/constant/assets.dart';
import 'package:messenger/common/theme/app_colors.dart';
import 'package:messenger/common/theme/app_theme.dart';
import 'package:messenger/common/utils/letters_avatar/letters_avatar_widget.dart';
import 'package:messenger/common/widgets/animations/disintegration_widget.dart';
import 'package:messenger/features/chats/presentation/widgets/chat_action_widget.dart';
import 'package:messenger/features/chats/presentation/widgets/chat_empty_state_widget.dart';
import 'package:messenger/features/chats/presentation/widgets/divider_messenge_widget.dart';
import 'package:messenger/features/chats/presentation/widgets/messenge_bubble_widget.dart';
import 'package:messenger/features/chats/presentation/widgets/messenge_own_bubble_widget.dart';
import 'package:vibration/vibration.dart';

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
  final Map<String, GlobalKey<DisintegrationWidgetState>> _messageKeys = {};

  void _sendMessage() {
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
                  FocusScope.of(context).unfocus();
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
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                  final key = _messageKeys[messageId];
                  if (key?.currentState != null) {
                    key!.currentState!.disintegrate();
                  } else {
                    _firestore.collection('messenges').doc(messageId).delete();
                  }
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
          backgroundColor:
              Theme.of(context).primaryColor.withValues(alpha: 0.1),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Text(
                widget.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                width: 40,
                child: getAvatar(
                  name: widget.name,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Theme.of(context).extension<ChatTheme>()?.backgroundChat ??
                    Assets.chatBackground_1,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
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
                      return ChatEmptyStateWidget(onTap: () {
                        _controller.text = 'Привет!';
                        _sendMessage();
                      });
                    }

                    var messenges = snapshot.data!.docs;

                    return ListView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 100,
                        left: 12,
                        right: 12,
                      ),
                      reverse: true,
                      itemCount: messenges.length,
                      itemBuilder: (context, index) {
                        var messenge = messenges[index];
                        final data = messenge.data() as Map<String, dynamic>;
                        final key = _messageKeys.putIfAbsent(messenge.id,
                            () => GlobalKey<DisintegrationWidgetState>());

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
                                    onLongPress: () async {
                                      Vibration.vibrate(duration: 20);
                                      _showOptions(
                                        context,
                                        messenge.id,
                                        data['text'].toString(),
                                      );
                                    },
                                    child: DisintegrationWidget(
                                      key: key,
                                      particleColor: AppColors.green,
                                      onDisintegrated: () {
                                        _firestore
                                            .collection('messenges')
                                            .doc(messenge.id)
                                            .delete();
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
                                  ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ChatActionWidget(
                  controller: _controller,
                  sendMessege: _sendMessage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
