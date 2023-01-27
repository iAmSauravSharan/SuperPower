import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const double homeIconSize = 29.0;
const Color homeIconColor = Color.fromARGB(255, 249, 246, 246);
const double homeTextSize = 16.0;
const Color homeTextColor = Color.fromARGB(255, 249, 246, 246);

final messengerKey = GlobalKey<ScaffoldMessengerState>();

snackbar(String? message) {
  if (message == null) return;
  final snackBar = SnackBar(content: Text(message));
  messengerKey.currentState!
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}

bool isLoggedIn() => (FirebaseAuth.instance.currentUser != null &&
    FirebaseAuth.instance.currentUser!.photoURL != null);

Widget loadProfileImage({double size = 38}) {
  return isLoggedIn()
      ? CircleAvatar(
          radius: size,
          backgroundColor: Colors.white,
          child: Image.network(
            FirebaseAuth.instance.currentUser!.photoURL!,
            fit: BoxFit.fill,
          ),
        )
      : Icon(
          Icons.account_circle_rounded,
          size: size,
        );
}
