import 'package:flutter/material.dart';
import 'package:messenger/common/theme/app_colors.dart';

Widget getAvatar({
  required String name,
  String? avatarUrl,
  double fontSize = 20,
}) {
  String firstName = 'A';
  String lastName = 'A';
  if (name != '' && name != ' ') {
    if (name.trim().split(' ').length > 1) {
      firstName = name.trim().split(' ')[0];
      lastName = name.trim().split(' ')[1];
    } else {
      lastName = name.trim().split(' ')[0];
      firstName = name.trim().split(' ')[0];
    }
  }

  if (avatarUrl != null && avatarUrl != '') {
    return CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage(avatarUrl),
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
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
