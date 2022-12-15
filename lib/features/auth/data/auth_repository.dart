import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuthInstance = FirebaseAuth.instance;

  Future<String> sendOTP({required String mobileNumber}) async {
    //_firebaseAuthInstance.setSettings(appVerificationDisabledForTesting: true);
    Completer<String> c = Completer<String>();
    await _firebaseAuthInstance.verifyPhoneNumber(
      phoneNumber: mobileNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        c.completeError(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        c.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    return c.future;
  }

  Future<void> loginWithOtp(
      {required String verificationId, required String otp}) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    await _firebaseAuthInstance.signInWithCredential(credential);
  }


  Future<void> dispose() async {
    await _firebaseAuthInstance.signOut();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = AuthRepository();
  ref.onDispose(() async => await auth.dispose());
  return auth;
});
