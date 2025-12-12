import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/common/models/response_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<ResponseModel?> signInUser(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return ResponseModel(
      type: ResponseType.success,
      message: 'Успешный вход',
    );
  } catch (e) {
    return ResponseModel(
      type: ResponseType.error,
      message: getMessageFromError(e),
    );
  }
}

void signOutUser() {
  FirebaseAuth.instance.signOut();
}

Future<ResponseModel?> signUpUser(
  String email,
  String password,
  String name,
  String lastName,
) async {
  try {
    final String base64Name = base64Encode(utf8.encode(name.trim()));
    final String base64LastName = base64Encode(utf8.encode(lastName.trim()));
    final String base64FullName =
        base64Encode(utf8.encode('${name.trim()} ${lastName.trim()}'));

    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    var newUser = _firestore.collection('users').doc(userCredential.user!.uid);
    await newUser.set({
      'name': base64Name,
      'lastName': base64LastName,
      'full_name': base64FullName,
    });

    return ResponseModel(
      type: ResponseType.success,
      message: 'Успешная регистрация',
    );
  } catch (e) {
    return ResponseModel(
      type: ResponseType.error,
      message: getMessageFromError(e),
    );
  }
}

String getMessageFromError(Object error) {
  String errorMessage = 'Что-то пошло не так';

  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-credential':
        errorMessage = 'Неверный email или пароль';
        break;
      case 'invalid-email':
        errorMessage = 'Неверный формат email';
      case 'email-already-in-use':
        errorMessage = 'Этот email уже используется';
        break;
      case 'weak-password':
        errorMessage = 'Пароль слишком слабый';
        break;
      default:
        errorMessage = 'Произошла ошибка: ${error.message}';
    }
  }

  return errorMessage;
}
