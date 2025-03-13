import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/features/auth/firebase/firebase_services.dart';
import 'package:messenger/features/chats/presentation/screens/main_chats_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

void _onNext(BuildContext context, String email, String password) async {
  final user = await signInUser(email, password);
  if (user != null) {
    print(user.email);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ChatsScreen()),
    );
  }
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Auth Screen'),
                    SizedBox(height: 16),
                    CupertinoTextField(
                      placeholder: 'Email',
                      controller: emailController,
                    ),
                    SizedBox(height: 16),
                    CupertinoTextField(
                      placeholder: 'Password',
                      controller: passwordController,
                    ),
                    SizedBox(height: 26),
                    ElevatedButton(
                      onPressed: () {
                        _onNext(
                          context,
                          emailController.text,
                          passwordController.text,
                        );
                      },
                      child: const Text('Go to Auth Screen'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
