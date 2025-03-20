import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/bloc/cubit/theme_cubit.dart';
import 'package:messenger/common/models/user_model.dart';
import 'package:messenger/common/theme/app_colors.dart';
import 'package:messenger/common/widgets/snackbar/snackbar.dart';
import 'package:messenger/features/auth/presentation/screens/auth_screen.dart';
import 'package:messenger/features/chats/presentation/widgets/chat_tile_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? userModel;

  @override
  void initState() {
    loadUser();
    super.initState();
  }

  Future<void> loadUser() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('users').doc(uid).get();
        if (userDoc.exists) {
          setState(() {
            userModel = UserModel.fromMap(userDoc.data()!);
            userModel?.name = utf8.decode(base64Decode(userModel!.name));
            userModel?.lastName =
                utf8.decode(base64Decode(userModel!.lastName));
            userModel?.fullName =
                utf8.decode(base64Decode(userModel!.fullName ?? ''));
          });
        }
      } catch (e) {
        AppSnackBar.showSnackBar(
          context,
          'Ошибка загрузки пользователя',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        context.watch<ThemeCubit>().state.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Настройки',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 24.0),
        child: Column(
          children: [
            if (userModel?.fullName != null &&
                userModel?.fullName != 'null' &&
                userModel?.fullName != '')
              ChatTileWidget(
                onTap: () => {},
                name: '${userModel?.fullName}',
                lastMessage: '',
                timestamp: null,
                divider: false,
              ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Темная тема',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Switch(
                  value: isDarkTheme,
                  onChanged: (v) =>
                      context.read<ThemeCubit>().toggleTheme(isDarkTheme),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 24),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.red.withOpacity(0.1),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Выйти',
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      Icons.exit_to_app,
                      color: AppColors.red,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
