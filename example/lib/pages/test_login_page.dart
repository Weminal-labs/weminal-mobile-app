import 'package:example/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(const MaterialApp(home: MyLogin()));
}

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
        .whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  Future<UserCredential> signInWithGoogle() async {
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
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> authenticateWithGoogle({required BuildContext context}) async {
    try {
      await signInWithGoogle();
    } catch (e) {
      print(e);
      if (!context.mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await GoogleSignIn().signOut();

              // await signInWithGoogle();
              UserCredential userCredential = await signInWithGoogle();
              print(
                'userCredential.credential?.accessToken: ${userCredential.credential?.accessToken}',
              );
              print(
                'userCredential.credential?.token: ${userCredential.credential?.token}',
              );
              var userIdToken = await userCredential.user?.getIdToken();
              print('userIdToken: $userIdToken');
              var userIdTokenResult =
                  await userCredential.user?.getIdTokenResult();
              print('userIdTokenResult: $userIdTokenResult');
            },
            child: const Text('Login')),
      ),
    );
  }
}
