import 'package:firebase_auth/firebase_auth.dart';

class Authenticate {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> signIn({String email, String password}) async {
    FirebaseUser user;
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
    } catch (e) {
      print('Erro is : $e');
    }

    return user;
  }

  Future signUpWithEmailAndPassword({String email, String password}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e);
    }
  }
}
