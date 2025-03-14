import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/bloc/cubit/theme_cubit.dart';

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
            )
          ],
        ),
      ),
    );
  }
}
