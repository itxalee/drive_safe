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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5ZBbgYlVWDoBWWFy2YUTHw42f_F9hI58',
    appId: '1:458851833231:android:3ac928bbc3be0b2341a7fa',
    messagingSenderId: '458851833231',
    projectId: 'drivesafe-project',
    storageBucket: 'drivesafe-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDr_jUK8achUNKkvIEZgTNM1bK27Fn7xFA',
    appId: '1:458851833231:ios:d646574f09b2dba341a7fa',
    messagingSenderId: '458851833231',
    projectId: 'drivesafe-project',
    storageBucket: 'drivesafe-project.appspot.com',
    iosClientId: '458851833231-h9k70fv8s5v9b5icq0rnipiuvfojlvf5.apps.googleusercontent.com',
    iosBundleId: 'com.example.driveSafe',
  );
}
