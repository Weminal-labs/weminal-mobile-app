// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBa_OLEqnFCftFWT_TwLbNNPzfGp2h1BPw',
    appId: '1:228187093845:android:ddd0b4db5e4398a1ad8ddc',
    messagingSenderId: '228187093845',
    projectId: 'wenimal-d4779',
    storageBucket: 'wenimal-d4779.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCawzMnOMdAz45KHLz8q_UOUuQOsWYRYt8',
    appId: '1:228187093845:ios:ac14f208aec21796ad8ddc',
    messagingSenderId: '228187093845',
    projectId: 'wenimal-d4779',
    storageBucket: 'wenimal-d4779.appspot.com',
    androidClientId: '228187093845-mrficn5r3vah7r6gm18s0jj0740907ql.apps.googleusercontent.com',
    iosClientId: '228187093845-bih5q6btkkjv717sjfbl4rnqsptrmlc3.apps.googleusercontent.com',
    iosBundleId: 'com.example.example',
  );
}