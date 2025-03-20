import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/common/models/response_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<ResponseModel?> signInUser(String email, String password) async {
  try {
    final String base64Email = base64Encode(utf8.encode(email));
    final String base64Password = base64Encode(utf8.encode(password));

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: base64Email,
      password: base64Password,
    );
    return ResponseModel(
      type: ResponseType.success,
      message: 'Успешный вход',
    );
  } catch (e) {
    return ResponseModel(
      type: ResponseType.error,
      message: e.toString(),
    );
  }
}

Future<ResponseModel?> signUpUser(
  String email,
  String password,
  String name,
  String lastName,
) async {
  try {
    final String base64Name = base64Encode(utf8.encode(name));
    final String base64LastName = base64Encode(utf8.encode(password));

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    var newUser = _firestore.collection('users').doc();
    await newUser.set({
      'name': base64Name,
      'lastName': base64LastName,
      'full_name': '$base64Name $base64LastName',
    });

    return ResponseModel(
      type: ResponseType.success,
      message: 'Успешная регистрация',
    );
  } catch (e) {
    return ResponseModel(
      type: ResponseType.error,
      message: e.toString(),
    );
  }
}
