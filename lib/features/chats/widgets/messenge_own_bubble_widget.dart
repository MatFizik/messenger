import 'package:flutter/material.dart';

class MessengeOwnBubbleWidget extends StatelessWidget {
  final String message;
  final String time;

  const MessengeOwnBubbleWidget({
    super.key,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: const BoxDecoration(
          color: Color(0xFF3CED78),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(width: 6),
            Text(
              time,
              style:
                  TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }
}
