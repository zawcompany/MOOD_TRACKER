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
    apiKey: 'AIzaSyCqCJbQldZKJDD1xrWiTMOCSYeTQyJpAjM',
    appId: '1:218608586742:web:b55a1ec6663232708f41d7',
    messagingSenderId: '218608586742',
    projectId: 'mood123tracker',
    authDomain: 'mood123tracker.firebaseapp.com',
    storageBucket: 'mood123tracker.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCN2MmB2LvpltxfiKfqllguBXqycFE_euQ',
    appId: '1:218608586742:android:d27681ce8a45c0b38f41d7',
    messagingSenderId: '218608586742',
    projectId: 'mood123tracker',
    storageBucket: 'mood123tracker.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfo-oqV7Ov_BTTGm5FsqdyVeJhJGPzyoo',
    appId: '1:218608586742:ios:b5156d221ac330b78f41d7',
    messagingSenderId: '218608586742',
    projectId: 'mood123tracker',
    storageBucket: 'mood123tracker.firebasestorage.app',
    iosBundleId: 'com.example.moodTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCfo-oqV7Ov_BTTGm5FsqdyVeJhJGPzyoo',
    appId: '1:218608586742:ios:b5156d221ac330b78f41d7',
    messagingSenderId: '218608586742',
    projectId: 'mood123tracker',
    storageBucket: 'mood123tracker.firebasestorage.app',
    iosBundleId: 'com.example.moodTracker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCqCJbQldZKJDD1xrWiTMOCSYeTQyJpAjM',
    appId: '1:218608586742:web:49d94e515935b0448f41d7',
    messagingSenderId: '218608586742',
    projectId: 'mood123tracker',
    authDomain: 'mood123tracker.firebaseapp.com',
    storageBucket: 'mood123tracker.firebasestorage.app',
  );
}
