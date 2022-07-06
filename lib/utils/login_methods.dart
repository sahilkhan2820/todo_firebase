import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/google_signin_model.dart';

//Google SignIn Process

Future<GoogleSignInModel> googleSignInProcess(BuildContext context) async {
  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  String? token = googleAuth?.idToken;
  GoogleSignInModel socialGoogleUser = GoogleSignInModel(
      displayName: googleUser?.displayName,
      email: googleUser?.email,
      photoUrl: googleUser?.photoUrl,
      id: googleUser?.id,
      token: token);

  Fluttertoast.showToast(
      msg: "Welcome", backgroundColor: Colors.green, textColor: Colors.white);

  //add user to firebase
  updateUserData(socialGoogleUser);

  return socialGoogleUser;
}

void updateUserData(GoogleSignInModel user) async {
  DocumentReference ref =
      FirebaseFirestore.instance.collection('users').doc(user.id);

  return ref.set(
    {
      'uid': user.id,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    },
  );
}
