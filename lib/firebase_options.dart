import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Platform belum dikonfigurasi.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9pS0FNMQbI5lpJVYnhemkcazPoWpGQ3Y',
    appId: '1:133416654509:android:fb8ed9d4ecb3d56cea1824',
    messagingSenderId: '133416654509',
    projectId: 'skinvision-ai-25227',
    storageBucket: 'skinvision-ai-25227.firebasestorage.app',
  );
}
