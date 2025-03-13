import 'package:firebase_auth/firebase_auth.dart';

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

Future<User?> signUpUser(String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } catch (e) {
    print('Ошибка регистрации: $e');
    return null;
  }
}
