import 'package:flutter/material.dart';

class DividerMessengeWidget extends StatelessWidget {
  final String date;
  const DividerMessengeWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white.withValues(alpha: 0.5),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              child: Text(
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                date,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
