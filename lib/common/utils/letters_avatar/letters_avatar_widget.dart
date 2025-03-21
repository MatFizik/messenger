import 'package:flutter/material.dart';
import 'package:messenger/common/theme/app_colors.dart';

Widget getAvatar(String name, String? avatarUrl) {
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
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
