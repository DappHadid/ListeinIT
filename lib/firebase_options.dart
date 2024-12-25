// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBcOGK2GirYK_OvCjvdpKrKVbajut3velg',
    appId: '1:960673916250:web:b90f023365f983c04a7f63',
    messagingSenderId: '960673916250',
    projectId: 'listenit-42016',
    authDomain: 'listenit-42016.firebaseapp.com',
    storageBucket: 'listenit-42016.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBuAUPTLo3SmDcc-TD3pH6mADjdSQlaWeg',
    appId: '1:960673916250:android:4601ba9a77f76eda4a7f63',
    messagingSenderId: '960673916250',
    projectId: 'listenit-42016',
    storageBucket: 'listenit-42016.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA-HPkgNgL7s9QRSFkqH4c2-7qSwJrXXS0',
    appId: '1:960673916250:ios:571690b8a7c4099c4a7f63',
    messagingSenderId: '960673916250',
    projectId: 'listenit-42016',
    storageBucket: 'listenit-42016.firebasestorage.app',
    iosBundleId: 'com.example.listenit',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA-HPkgNgL7s9QRSFkqH4c2-7qSwJrXXS0',
    appId: '1:960673916250:ios:571690b8a7c4099c4a7f63',
    messagingSenderId: '960673916250',
    projectId: 'listenit-42016',
    storageBucket: 'listenit-42016.firebasestorage.app',
    iosBundleId: 'com.example.listenit',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBcOGK2GirYK_OvCjvdpKrKVbajut3velg',
    appId: '1:960673916250:web:8316cb245b52c8774a7f63',
    messagingSenderId: '960673916250',
    projectId: 'listenit-42016',
    authDomain: 'listenit-42016.firebaseapp.com',
    storageBucket: 'listenit-42016.firebasestorage.app',
  );
}