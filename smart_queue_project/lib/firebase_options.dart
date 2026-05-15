import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBNW72C8_5usVc6mt6SXXIpXQKxOhcc8D8',
    appId: '1:632886911832:web:499113bc7f83297e0ebb2d',
    messagingSenderId: '632886911832',
    projectId: 'smart-queue-managment',
    authDomain: 'smart-queue-managment.firebaseapp.com',
    storageBucket: 'smart-queue-managment.firebasestorage.app',
    measurementId: 'G-H1W1G9YDJC',
  );

  // Temporary Android options using available project credentials.
  // Replace appId with Android app id from Firebase console when available.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNW72C8_5usVc6mt6SXXIpXQKxOhcc8D8',
    appId: '1:632886911832:web:499113bc7f83297e0ebb2d',
    messagingSenderId: '632886911832',
    projectId: 'smart-queue-managment',
    storageBucket: 'smart-queue-managment.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBNW72C8_5usVc6mt6SXXIpXQKxOhcc8D8',
    appId: '1:632886911832:web:499113bc7f83297e0ebb2d',
    messagingSenderId: '632886911832',
    projectId: 'smart-queue-managment',
    authDomain: 'smart-queue-managment.firebaseapp.com',
    storageBucket: 'smart-queue-managment.firebasestorage.app',
    measurementId: 'G-H1W1G9YDJC',
  );
}
