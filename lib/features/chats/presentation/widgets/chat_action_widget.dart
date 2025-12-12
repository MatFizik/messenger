import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messenger/common/theme/app_colors.dart';

class ChatActionWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback sendMessege;

  const ChatActionWidget(
      {super.key, required this.controller, required this.sendMessege});

  @override
  State<ChatActionWidget> createState() => _ChatActionWidgetState();
}

class _ChatActionWidgetState extends State<ChatActionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 12,
        left: 12,
        right: 12,
        bottom: Platform.isIOS ? 36 : 18,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white.withValues(alpha: 0.9),
              ),
              child: TextFormField(
                controller: widget.controller,
                maxLines: 5,
                minLines: 1,
                onFieldSubmitted: (value) => widget.sendMessege(),
                style: const TextStyle(fontSize: 16, height: 1.4),
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      Theme.of(context).primaryColor.withValues(alpha: 0.7),
                  hintStyle:
                      const TextStyle(color: AppColors.textTertiaryLight),
                  hintText: 'Сообщение',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => widget.sendMessege(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                ),
                width: 45,
                height: 45,
                child: const Icon(Icons.send),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
