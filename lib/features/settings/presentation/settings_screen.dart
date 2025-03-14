import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/bloc/cubit/theme_cubit.dart';
import 'package:messenger/common/theme/app_colors.dart';
import 'package:messenger/features/auth/presentation/screens/auth_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
