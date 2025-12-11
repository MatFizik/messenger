import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/common/utils/letters_avatar/letters_avatar_widget.dart';

class ChatTileWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String? avatarUrl;
  final String name;
  final String lastMessage;
  final Timestamp? timestamp;
  final bool divider;

  const ChatTileWidget({
    super.key,
    required this.onTap,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    this.avatarUrl,
    this.divider = true,
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
      String day = date.day.toString().padLeft(2, '0');
      String month = date.month.toString().padLeft(2, '0');
      String year = date.year.toString();
      return '$day.$month.$year';
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
                    getAvatar(name, avatarUrl),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: lastMessage != ''
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 2),
                        if (lastMessage != '')
                          SizedBox(
                            width: 200,
                            child: Text(
                              lastMessage,
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Text(
                  parseDate(timestamp),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            if (divider) const Divider(thickness: 1),
          ],
        ),
      ),
    );
  }
}
