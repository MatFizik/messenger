import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<User?> signInUser(String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } catch (e) {
    print('Ошибка входа: $e');
    return null;
  }
}

Future<User?> signUpUser(
  String email,
  String password,
  String name,
  String lastName,
) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    var newUser = _firestore.collection('users').doc();
    await newUser.set({
      'name': name,
      'lastName': lastName,
      'full_name': '$name $lastName',
    });

    return userCredential.user;
  } catch (e) {
    print('Ошибка регистрации: $e');
    return null;
  }
}
