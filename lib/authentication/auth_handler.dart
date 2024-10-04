import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nasa_space_app/authentication/auth_controller.dart';
import 'package:nasa_space_app/authentication/authentication_screen.dart';
import 'package:nasa_space_app/authentication/user_form_screen.dart';
import 'package:nasa_space_app/homepage/homepage.dart';
import 'package:nasa_space_app/homepage/model/usermodel.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  Future<bool> _checkUserExists(String uid) async {
    log(uid);
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final AuthController authController = Get.find();
    if (userDoc.exists) {
      authController.setUserModel(Usermodel.fromMap(userDoc.data()!));
    }

    return userDoc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          return FutureBuilder<bool>(
            future: _checkUserExists(user.uid),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (userSnapshot.hasData && userSnapshot.data == true) {
                return const Homepage();
              } else {
                return const UserFormScreen();
              }
            },
          );
        } else {
          return const AuthenticationScreen();
        }
      },
    );
  }
}
