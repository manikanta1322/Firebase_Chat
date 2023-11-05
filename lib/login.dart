import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = "";
  String smsCode = ""; // Added to store SMS code entered by the user.

  Future<void> _verifyPhone() async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      // This callback will be triggered when phone number is automatically verified.
      // You can handle the verification process here.
      await _auth.signInWithCredential(credential);
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      print('Phone verification failed: ${e.message}');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      setState(() {
        this.verificationId = verificationId;
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      setState(() {
        this.verificationId = verificationId;
      });
    };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber:
            '+1 555-555-5555', // Replace with the phone number to verify
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      print('Error verifying phone number: $e');
    }
  }

  Future<void> _signInWithPhoneNumber(String smsCode) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      print('User ID: ${userCredential.user!.uid}');
    } catch (e) {
      print('Error signing in with phone number: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _verifyPhone,
              child: Text('Verify Phone Number'),
            ),
            TextField(
              onChanged: (value) {
                smsCode = value; // Capture the SMS code entered by the user.
              },
            ),
            ElevatedButton(
              onPressed: () {
                _signInWithPhoneNumber(smsCode); // Use the captured SMS code.
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
