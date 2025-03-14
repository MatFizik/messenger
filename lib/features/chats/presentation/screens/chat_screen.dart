import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/features/chats/presentation/widgets/messenge_bubble_widget.dart';
import 'package:messenger/features/chats/presentation/widgets/messenge_own_bubble_widget.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({
    super.key,
    required this.chatId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

TextEditingController _controller = TextEditingController();

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 24.0),
        child: Column(
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Введите сообщение',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _firestore.collection('messenges').add({
                        'chat_id': widget.chatId,
                        'sender': FirebaseAuth.instance.currentUser?.uid,
                        'text': _controller.text,
                        'date_send': Timestamp.now(),
                      });
                      _controller.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
