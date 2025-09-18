import 'package:chowdeck_refix/screen/notification_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elegant_notification/elegant_notification.dart';

class PhoneAuthentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send OTP using Firebase Auth
  Future<void> sendOTPCode({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException e) onFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber.trim(),
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval case (optional)
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onFailed(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Verify OTP & save user info to Firestore
  Future<String> verifyOTPCode({
    required String verificationId,
    required String smsCode,
    required String phoneNumber,
    required String email,
    required String firstName,
    required String lastName,
    required String birthday,
    required String referralCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential); // Firebase phone auth ✅

      // Save to Firestore
      await _firestore.collection('users').add({
        'phoneNumber': phoneNumber.trim(),
        'email': email.trim(),
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'birthday': birthday.trim(),
        'referralCode': referralCode.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return 'success';
    } catch (e) {
      return 'error: ${e.toString()}';
    }
  }
}
