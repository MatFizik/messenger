import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChatEmptyStateWidget extends StatefulWidget {
  final VoidCallback onTap;

  const ChatEmptyStateWidget({
    super.key,
    required this.onTap,
  });

  @override
  State<ChatEmptyStateWidget> createState() => _ChatEmptyStateWidgetState();
}

class _ChatEmptyStateWidgetState extends State<ChatEmptyStateWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 1,
              )
            ],
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Сообщений пока нет...',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white),
                ),
                Text(
                  'Отправьте сообщение или нажмите на анимацию ниже',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    widget.onTap();
                  },
                  child: Lottie.asset(
                    width: 250,
                    'assets/animations/message_animation.json',
                    onLoaded: (composition) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
