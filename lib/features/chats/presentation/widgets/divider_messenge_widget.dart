import 'package:flutter/material.dart';

class DividerMessengeWidget extends StatelessWidget {
  final String date;
  const DividerMessengeWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          const Expanded(
            child: Divider(thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
              date,
            ),
          ),
          const Expanded(
            child: Divider(thickness: 1),
          ),
        ],
      ),
    );
  }
}
