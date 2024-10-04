import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:nasa_space_app/homepage/model/usermodel.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Usermodel? usermodel;

  User? firebaseUser;
  bool isLoading = false;


  void setUserModel(Usermodel? model) {
    usermodel = model;
    update();
  }

  Future<void> googleSignIn() async {
    try {
      isLoading = true;
      update();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);
      } else {
        Get.snackbar("Error", "Google sign-in was canceled");
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> googleSignOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();

      firebaseUser = null;
      Get.offAllNamed('/');
      Get.snackbar("Success", "Logged out successfully");
      update();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> saveUserData(
      {required String name,
      required String adress,
      required String mobile}) async {
    isLoading = true;
    update();
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final email = FirebaseAuth.instance.currentUser!.email;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'address': adress,
        'mobile': mobile,
        'email': email,
        "uid": uid,
      });

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    isLoading = false;
    update();
  }

  Future<void> updateUserData({
    String? name,
    String? address,
    String? mobile,
  }) async {
    isLoading = true;
    update();

    try {
      final uid = _auth.currentUser!.uid;

      Map<String, dynamic> updates = {};

      if (name != null && name.isNotEmpty) {
        updates['name'] = name;
      }
      if (address != null && address.isNotEmpty) {
        updates['address'] = address;
      }
      if (mobile != null && mobile.isNotEmpty) {
        updates['mobile'] = mobile;
      }

      if (updates.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update(updates);
        Get.snackbar("Success", "User data updated successfully!");
        final userDoc = await _firestore.collection('users').doc(uid).get();

        if (userDoc.exists) {
          setUserModel(Usermodel.fromMap(userDoc.data()!));
        }
      } else {
        Get.snackbar("Info", "No fields to update.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }

    isLoading = false;
    update();
  }
}
