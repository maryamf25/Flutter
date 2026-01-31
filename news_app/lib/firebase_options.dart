import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
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
    apiKey: 'AIzaSyC3RZYVcnKN7ojn_dDhBGj5GRlNgt-Zqyo',
    appId: '1:227550646312:web:5bb40f8b723dceff56e51d',
    messagingSenderId: '227550646312',
    projectId: 'dailypulse12345',
    authDomain: 'dailypulse12345.firebaseapp.com',
    storageBucket: 'dailypulse12345.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFPpFG92ThrEMP8Op889udpKZT1klZXvQ',
    appId: '1:227550646312:android:b5e2eb685621a3e356e51d',
    messagingSenderId: '227550646312',
    projectId: 'dailypulse12345',
    storageBucket: 'dailypulse12345.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCyLy6Sg_6j5ebHiVxMv1FXr2VbArbDE0k',
    appId: '1:227550646312:ios:af26eb3aa9981df256e51d',
    messagingSenderId: '227550646312',
    projectId: 'dailypulse12345',
    storageBucket: 'dailypulse12345.firebasestorage.app',
    iosBundleId: 'com.example.newsApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCyLy6Sg_6j5ebHiVxMv1FXr2VbArbDE0k',
    appId: '1:227550646312:ios:af26eb3aa9981df256e51d',
    messagingSenderId: '227550646312',
    projectId: 'dailypulse12345',
    storageBucket: 'dailypulse12345.firebasestorage.app',
    iosBundleId: 'com.example.newsApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC3RZYVcnKN7ojn_dDhBGj5GRlNgt-Zqyo',
    appId: '1:227550646312:web:e96cdbb477e0185256e51d',
    messagingSenderId: '227550646312',
    projectId: 'dailypulse12345',
    authDomain: 'dailypulse12345.firebaseapp.com',
    storageBucket: 'dailypulse12345.firebasestorage.app',
  );
}
