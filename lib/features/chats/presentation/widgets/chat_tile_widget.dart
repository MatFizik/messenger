import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatTileWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String avatarUrl;
  final String name;
  final String lastMessage;
  final Timestamp? timestamp;

  const ChatTileWidget({
    super.key,
    required this.onTap,
    required this.avatarUrl,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
  });

  String parseDate(Timestamp? timestamp) {
    if (timestamp == null) return '';
    DateTime date = timestamp.toDate();
    if (-1 * date.difference(DateTime.now()).inSeconds < 60) {
      return 'Только что';
    } else if (-1 * date.difference(DateTime.now()).inMinutes < 5) {
      return '${-1 * date.difference(DateTime.now()).inMinutes} минут назад';
    } else if (-1 * date.difference(DateTime.now()).inDays == 0) {
      return date.toString().substring(11, 16);
    } else {
      return timestamp.toDate().toString().substring(0, 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: lastMessage != ''
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        if (lastMessage != '')
                          Text(
                            lastMessage,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Text(
                  parseDate(timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            const Divider(thickness: 1),
          ],
        ),
      ),
    );
  }
}
