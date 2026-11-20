import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] configured from project SMART KJA credentials.
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
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCiyGkS2vfvWJutNR1S2kgtP2xIdLzUfK8',
    appId: '1:102938475610:web:abcdef1234567890',
    messagingSenderId: '102938475610',
    projectId: 'monitoring-tambak-smart-kja',
    databaseURL:
        'https://monitoring-tambak-smart-kja-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCiyGkS2vfvWJutNR1S2kgtP2xIdLzUfK8',
    appId: '1:102938475610:android:abcdef1234567890',
    messagingSenderId: '102938475610',
    projectId: 'monitoring-tambak-smart-kja',
    databaseURL:
        'https://monitoring-tambak-smart-kja-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCiyGkS2vfvWJutNR1S2kgtP2xIdLzUfK8',
    appId: '1:102938475610:ios:abcdef1234567890',
    messagingSenderId: '102938475610',
    projectId: 'monitoring-tambak-smart-kja',
    databaseURL:
        'https://monitoring-tambak-smart-kja-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
}
