import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/common/constant/assets.dart';
import 'package:messenger/common/models/response_model.dart';
import 'package:messenger/common/widgets/snackbar/snackbar.dart';
import 'package:messenger/common/widgets/textfields/custom_textfield.dart';
import 'package:messenger/features/auth/firebase/firebase_services.dart';
import 'package:messenger/features/auth/presentation/screens/register_screen.dart';
import 'package:messenger/features/chats/presentation/screens/main_chats_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _onNext(String email, String password) async {
    final res = await signInUser(email, password);
    if (res?.type == ResponseType.success) {
      AppSnackBar.showSnackBar(
        context,
        res?.message ?? 'Успешный вход',
        status: SnackBarStatuses.success,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ChatsScreen(),
        ),
      );
    } else {
      AppSnackBar.showSnackBar(
        context,
        res?.message ?? 'Что-то пошло не так',
        status: SnackBarStatuses.error,
      );
    }
  }

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
                        Assets.authImage,
                        width: 300,
                      ),
                      Text(
                        'Авторизация',
                        style: Theme.of(context).textTheme.titleLarge,
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
                      ElevatedButton(
                        onPressed: () {
                          _onNext(
                            emailController.text,
                            passwordController.text,
                          );
                        },
                        child: const Text('Войти'),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        ),
                        child: const Text('Еще не зарегистрированы?'),
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
