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
        return macos;
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
    apiKey: 'AIzaSyBc_Xucsj6DAcZfFVBfBXUfR-MQEvpN98U',
    appId: '1:544883126664:web:b41d3f952380d93215ca3d',
    messagingSenderId: '544883126664',
    projectId: 'unisofty-a6a1c',
    authDomain: 'unisofty-a6a1c.firebaseapp.com',
    storageBucket: 'unisofty-a6a1c.appspot.com',
    measurementId: 'G-PS90F41FZF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCnChJzfjmtqOOO7P3r43ysNPQC3ReA_ac',
    appId: '1:544883126664:android:d88ddcbfc6794f7415ca3d',
    messagingSenderId: '544883126664',
    projectId: 'unisofty-a6a1c',
    storageBucket: 'unisofty-a6a1c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBnHFMuBFcA6YOXDQr2tjySW-GJK86b-WM',
    appId: '1:544883126664:ios:6aa2892c8733c36a15ca3d',
    messagingSenderId: '544883126664',
    projectId: 'unisofty-a6a1c',
    storageBucket: 'unisofty-a6a1c.appspot.com',
    iosClientId: '544883126664-n8s6md3e1ueqapqdfkif3vmhandbt8v8.apps.googleusercontent.com',
    iosBundleId: 'com.example.unisoftApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBnHFMuBFcA6YOXDQr2tjySW-GJK86b-WM',
    appId: '1:544883126664:ios:6aa2892c8733c36a15ca3d',
    messagingSenderId: '544883126664',
    projectId: 'unisofty-a6a1c',
    storageBucket: 'unisofty-a6a1c.appspot.com',
    iosClientId: '544883126664-n8s6md3e1ueqapqdfkif3vmhandbt8v8.apps.googleusercontent.com',
    iosBundleId: 'com.example.unisoftApp',
  );
}