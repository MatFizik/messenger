import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/common/theme/app_colors.dart';

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
      return timestamp.toDate().toString().substring(0, 16);
    }
  }

  Widget getAvatar() {
    String firstName = 'A';
    String lastName = 'A';
    if (name != '' && name != ' ') {
      if (name.split(' ').length > 1) {
        firstName = name.split(' ')[0];
        lastName = name.split(' ')[1];
      } else {
        lastName = name.split(' ')[0];
        firstName = name.split(' ')[0];
      }
    }

    if (avatarUrl != null && avatarUrl != '') {
      return CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(avatarUrl!),
      );
    } else {
      return Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.blue, AppColors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          firstName[0].toUpperCase() + lastName[0].toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
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
                    getAvatar(),
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
