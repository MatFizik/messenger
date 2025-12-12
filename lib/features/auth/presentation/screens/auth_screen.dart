import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  final _formKey = GlobalKey<FormState>();
  int tapCounter = 0;

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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            tapCounter++;
                            if (tapCounter >= 3) {
                              tapCounter = 0;
                              AppSnackBar.showSnackBar(
                                context,
                                'ЧО ТЫ ТЫКАЕШЬ???',
                                status: SnackBarStatuses.warning,
                              );
                            }
                          },
                          child: DotLottieLoader.fromNetwork(
                            "https://lottie.host/b86edf3c-e498-4e69-a0bf-60b9b36b2aa3/3gpiceN4mv.lottie",
                            frameBuilder: (context, dotlottie) {
                              if (dotlottie != null) {
                                return Lottie.memory(
                                  dotlottie.animations.values.first,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.contain,
                                  repeat: true,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        Text(
                          'Авторизация',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 36),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextfield(
                                validators: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Введите email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Некорректный email';
                                  }
                                  return null;
                                },
                                controller: emailController,
                                labelText: 'Email',
                              ),
                              const SizedBox(height: 16),
                              CustomTextfield(
                                validators: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Введите пароль';
                                  }
                                  if (value.length < 6) {
                                    return 'Минимум 6 символов';
                                  }
                                  return null;
                                },
                                controller: passwordController,
                                labelText: 'Пароль',
                              ),
                              const SizedBox(height: 36),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _onNext(
                                      emailController.text,
                                      passwordController.text,
                                    );
                                  }
                                },
                                child: const Text('Войти'),
                              ),
                            ],
                          ),
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
      ),
    );
  }
}
