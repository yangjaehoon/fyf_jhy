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
    apiKey: 'AIzaSyDT4DAhikPGjHBbvjyK4ksLmYuvCOG-lb0',
    appId: '1:335733810987:web:a6af5ab2be84f48c58476e',
    messagingSenderId: '335733810987',
    projectId: 'fill-your-festival-suchang',
    authDomain: 'fill-your-festival-suchang.firebaseapp.com',
    databaseURL: 'https://fill-your-festival-suchang-default-rtdb.firebaseio.com',
    storageBucket: 'fill-your-festival-suchang.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbqtD5xJBg_jV_pOr7CfezGAXzr8G-5ks',
    appId: '1:335733810987:android:809a1fa7aa0bba9258476e',
    messagingSenderId: '335733810987',
    projectId: 'fill-your-festival-suchang',
    databaseURL: 'https://fill-your-festival-suchang-default-rtdb.firebaseio.com',
    storageBucket: 'fill-your-festival-suchang.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDBih94wx0sumQcijXSRaj3SfzEI8Szv0U',
    appId: '1:335733810987:ios:4ada81ae78a51ea058476e',
    messagingSenderId: '335733810987',
    projectId: 'fill-your-festival-suchang',
    databaseURL: 'https://fill-your-festival-suchang-default-rtdb.firebaseio.com',
    storageBucket: 'fill-your-festival-suchang.appspot.com',
    iosClientId: '335733810987-krm732md5tsajjbpf0507aelp3008cp5.apps.googleusercontent.com',
    iosBundleId: 'com.example.fastAppBase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDBih94wx0sumQcijXSRaj3SfzEI8Szv0U',
    appId: '1:335733810987:ios:4ada81ae78a51ea058476e',
    messagingSenderId: '335733810987',
    projectId: 'fill-your-festival-suchang',
    databaseURL: 'https://fill-your-festival-suchang-default-rtdb.firebaseio.com',
    storageBucket: 'fill-your-festival-suchang.appspot.com',
    iosClientId: '335733810987-krm732md5tsajjbpf0507aelp3008cp5.apps.googleusercontent.com',
    iosBundleId: 'com.example.fastAppBase',
  );
}
