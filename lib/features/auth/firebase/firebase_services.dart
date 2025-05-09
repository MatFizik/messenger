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
      message: e.toString(),
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
    final String base64Name = base64Encode(utf8.encode(name));
    final String base64LastName = base64Encode(utf8.encode(lastName));
    final String base64FullName = base64Encode(utf8.encode('$name$lastName'));

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
      message: e.toString(),
    );
  }
}
