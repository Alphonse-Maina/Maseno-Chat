import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AuthService extends ChangeNotifier{
  // firebase instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign user in
  UserCredential signInWithEmailAndPassword(String email, String password){
    try{
      UserCredential userCredential = _firebaseAuth.signInWithEmailAndPassword(email: email, password: password,) as UserCredential;
      //add a new document for the user in users collection if it doesn't exist
      // _firestore.collection('users').doc(userCredential.user!.uid).set({
      //   'uid':userCredential.user!.uid,
      //   'email': email,
      //
      // }, SetOptions(merge: true));
      return userCredential;

    }
    on FirebaseAuthException catch(e){
     throw Exception(e.code);
    }
  }
  //create a new user
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password, File profile, String uname) async {
    try {
      String? downloadUrl;
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      // Store profile photo on Firebase Storage
      Reference referenceRoot = FirebaseStorage.instance.ref().child('profilPics');
      Reference referenceImageToUpload = referenceRoot.child(_firebaseAuth.currentUser!.uid);

      try {
        // Store the file
        UploadTask uploadTask = referenceImageToUpload.putFile(profile);
        TaskSnapshot snap = await uploadTask;

        print('File uploaded successfully');

        // Get download URL
        downloadUrl = await snap.ref.getDownloadURL();
      } catch (e) {
        print('Error uploading file: $e');
      }

      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'profile': downloadUrl,
        'uname': uname,
      }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


// sign user out
Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
}
}