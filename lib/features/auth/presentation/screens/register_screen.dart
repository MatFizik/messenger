import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/common/constant/assets.dart';
import 'package:messenger/common/widgets/textfields/custom_textfield.dart';
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
  signUpUser(email, password, name, lastName).then(
    (v) {
      if (v != null) {
        return Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ChatsScreen()),
        );
      }
    },
  );
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.registerImage,
                        width: 200,
                      ),
                      const SizedBox(height: 36),
                      CustomTextfield(
                        controller: emailController,
                        labelText: 'Email',
                      ),
                      const SizedBox(height: 16),
                      CustomTextfield(
                        controller: passwordController,
                        labelText: 'Password',
                      ),
                      const SizedBox(height: 26),
                      CustomTextfield(
                        controller: nameController,
                        labelText: 'Имя',
                      ),
                      const SizedBox(height: 26),
                      CustomTextfield(
                        controller: lastNameController,
                        labelText: 'Фамилия',
                      ),
                      const SizedBox(height: 36),
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
                        child: const Text('Зарегистрироваться'),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Уже зарегистрированы?'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
