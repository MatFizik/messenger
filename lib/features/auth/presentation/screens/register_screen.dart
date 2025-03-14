import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/features/auth/firebase/firebase_services.dart';
import 'package:messenger/features/chats/presentation/screens/main_chats_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

void _onNext(
  BuildContext context,
  String email,
  String password,
  String name,
  String lastName,
) async {
  var user = signUpUser(email, password, name, lastName);
  if (user != null) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ChatsScreen()),
    );
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
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
                    CupertinoTextField(
                      placeholder: 'Name',
                      controller: nameController,
                    ),
                    SizedBox(height: 26),
                    CupertinoTextField(
                      placeholder: 'Last Name',
                      controller: lastNameController,
                    ),
                    SizedBox(height: 26),
                    ElevatedButton(
                      onPressed: () {
                        _onNext(
                          context,
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                          lastNameController.text,
                        );
                      },
                      child: const Text('Регистрация'),
                    )
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
