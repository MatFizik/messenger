import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messenger/common/theme/app_colors.dart';
import 'package:messenger/common/theme/app_theme.dart';
import 'package:messenger/features/chats/presentation/widgets/glass_container_widget.dart';

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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: GlassContainerWidget(
                  child: TextFormField(
                    controller: widget.controller,
                    maxLines: 5,
                    minLines: 1,
                    onFieldSubmitted: (value) => widget.sendMessege(),
                    style: const TextStyle(fontSize: 16, height: 1.4),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context)
                          .extension<ChatTheme>()
                          ?.actionColor
                          ?.withValues(
                            alpha: 0.2,
                          ),
                      hintStyle: const TextStyle(color: AppColors.textPrimary),
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
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => widget.sendMessege(),
            child: SizedBox(
              width: 50,
              height: 50,
              child: GlassContainerWidget(
                child: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
