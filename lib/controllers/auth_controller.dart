import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  Rxn<UserCredential> firebaseUser = Rxn<UserCredential>();
  RxBool isLoading = false.obs;
  Future<UserCredential> signInWithGoogle() async {
    isLoading.value = true;
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    firebaseUser.value =
        await FirebaseAuth.instance.signInWithCredential(credential);
    log("firebaseUser ${firebaseUser.value}");
    isLoading.value = false;
    return firebaseUser.value!;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    firebaseUser.value = null;
  }
}
