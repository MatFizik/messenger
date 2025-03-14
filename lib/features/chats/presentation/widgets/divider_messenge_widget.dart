import 'package:flutter/material.dart';

class DividerMessengeWidget extends StatelessWidget {
  const DividerMessengeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(thickness: 1),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Сегодня', // доделать
            ),
          ),
          Expanded(
            child: Divider(thickness: 1),
          ),
        ],
      ),
    );
  }
}
