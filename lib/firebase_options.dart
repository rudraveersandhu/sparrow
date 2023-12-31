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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC8iSfMmWPAEMkRyHNr2pfLT8X7XUL7GKg',
    appId: '1:279574373817:web:83d5c8822adc7f211fc268',
    messagingSenderId: '279574373817',
    projectId: 'sparrow-v1',
    authDomain: 'sparrow-v1.firebaseapp.com',
    storageBucket: 'sparrow-v1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1zi2oXqECSJmWNg3YUNNcG082YHHtFbQ',
    appId: '1:279574373817:android:1bb26a1fb1ddd4391fc268',
    messagingSenderId: '279574373817',
    projectId: 'sparrow-v1',
    storageBucket: 'sparrow-v1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeghDOC7XUzf7agTdq1vfqBtvSWmIjYWA',
    appId: '1:279574373817:ios:b61ec0b58291c03a1fc268',
    messagingSenderId: '279574373817',
    projectId: 'sparrow-v1',
    storageBucket: 'sparrow-v1.appspot.com',
    androidClientId: '279574373817-v0ho739j45267u5e0ngmcgpqrmv95hsp.apps.googleusercontent.com',
    iosClientId: '279574373817-k8eh7uoue0flif0jk7dkpoo8ejmt755r.apps.googleusercontent.com',
    iosBundleId: 'com.example.sparrowV1',
  );
}
