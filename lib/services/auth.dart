import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:msn_chat/models/user.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FUser? _userFromFirebaseUser(User user){
    return user != null ? FUser(uid: user.uid) : null;
  }
  // sign in anonymously
Future<UserCredential> signInWithEmailAndPassword(String email,String password) async{
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    }on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
}

  // Sign in with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}