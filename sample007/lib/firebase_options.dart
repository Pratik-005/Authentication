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
    apiKey: 'AIzaSyAJTEb2AK5VqVWEHbpybB-kx3WOdOIk_Fk',
    appId: '1:988632970881:web:e632c141191c816ef67f80',
    messagingSenderId: '988632970881',
    projectId: 'assignment-fe549',
    authDomain: 'assignment-fe549.firebaseapp.com',
    storageBucket: 'assignment-fe549.appspot.com',
    measurementId: 'G-Z5ZL577HFT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC18aVuyfxytt2I9ruPSUfC2XcSE_IqOYs',
    appId: '1:988632970881:android:212e62746671fabaf67f80',
    messagingSenderId: '988632970881',
    projectId: 'assignment-fe549',
    storageBucket: 'assignment-fe549.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7-z7zRCinXm5g0kyxdC73pQklHTZEYlk',
    appId: '1:988632970881:ios:cb80c75663c6a92ef67f80',
    messagingSenderId: '988632970881',
    projectId: 'assignment-fe549',
    storageBucket: 'assignment-fe549.appspot.com',
    androidClientId: '988632970881-sj8b81vkjarp2h9mpg0urf8m42m0nim8.apps.googleusercontent.com',
    iosClientId: '988632970881-h0n9bfljpba2nanajj5gnvikqi9l2c1g.apps.googleusercontent.com',
    iosBundleId: 'com.example.sample007',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB7-z7zRCinXm5g0kyxdC73pQklHTZEYlk',
    appId: '1:988632970881:ios:cb80c75663c6a92ef67f80',
    messagingSenderId: '988632970881',
    projectId: 'assignment-fe549',
    storageBucket: 'assignment-fe549.appspot.com',
    androidClientId: '988632970881-sj8b81vkjarp2h9mpg0urf8m42m0nim8.apps.googleusercontent.com',
    iosClientId: '988632970881-h0n9bfljpba2nanajj5gnvikqi9l2c1g.apps.googleusercontent.com',
    iosBundleId: 'com.example.sample007',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAJTEb2AK5VqVWEHbpybB-kx3WOdOIk_Fk',
    appId: '1:988632970881:web:e46ffaa6ba3aac8bf67f80',
    messagingSenderId: '988632970881',
    projectId: 'assignment-fe549',
    authDomain: 'assignment-fe549.firebaseapp.com',
    storageBucket: 'assignment-fe549.appspot.com',
    measurementId: 'G-VJWLK860K5',
  );
}