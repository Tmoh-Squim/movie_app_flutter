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
    apiKey: 'AIzaSyBlPITwDQoqSKaE1GHTA_x4ZniT8wANykU',
    appId: '1:1049814162413:web:da294f232d3b2e8f6225e4',
    messagingSenderId: '1049814162413',
    projectId: 'movie-app-2b842',
    authDomain: 'movie-app-2b842.firebaseapp.com',
    storageBucket: 'movie-app-2b842.appspot.com',
    measurementId: 'G-LQQN6KDK5F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCryK25SBcYLdSsLO0HKW96iYT8PSJFxlk',
    appId: '1:1049814162413:android:3a18a5fab490849d6225e4',
    messagingSenderId: '1049814162413',
    projectId: 'movie-app-2b842',
    storageBucket: 'movie-app-2b842.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDh9R07TiaW9F4WtbDDLLnzsrRFitcK8yU',
    appId: '1:1049814162413:ios:c3879c9a489771346225e4',
    messagingSenderId: '1049814162413',
    projectId: 'movie-app-2b842',
    storageBucket: 'movie-app-2b842.appspot.com',
    iosClientId: '1049814162413-27v9j6pijd72o388cmf337q4snmg4m28.apps.googleusercontent.com',
    iosBundleId: 'com.example.movieApp',
  );
}