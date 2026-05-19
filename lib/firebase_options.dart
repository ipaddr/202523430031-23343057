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
    apiKey: 'AIzaSyB1aEmWEYrOO_Pyx4yR_0_iIbzzeQy_n8I',
    appId: '1:1053943487939:web:3e228c1c8016008c6a7176',
    messagingSenderId: '1053943487939',
    projectId: 'auklus-f9d97',
    authDomain: 'auklus-f9d97.firebaseapp.com',
    storageBucket: 'auklus-f9d97.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIUr4hYEIL6h07ZE-Xb-i2rtpzc5EMnTQ',
    appId: '1:1053943487939:android:6aa737bdf76d41566a7176',
    messagingSenderId: '1053943487939',
    projectId: 'auklus-f9d97',
    storageBucket: 'auklus-f9d97.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBq29HPxPs7UNBix1QOzLpnEsOLinJPysc',
    appId: '1:1053943487939:ios:21c91535893ecf356a7176',
    messagingSenderId: '1053943487939',
    projectId: 'auklus-f9d97',
    storageBucket: 'auklus-f9d97.firebasestorage.app',
    iosBundleId: 'com.example.auklus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBq29HPxPs7UNBix1QOzLpnEsOLinJPysc',
    appId: '1:1053943487939:ios:21c91535893ecf356a7176',
    messagingSenderId: '1053943487939',
    projectId: 'auklus-f9d97',
    storageBucket: 'auklus-f9d97.firebasestorage.app',
    iosBundleId: 'com.example.auklus',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB1aEmWEYrOO_Pyx4yR_0_iIbzzeQy_n8I',
    appId: '1:1053943487939:web:3c91ec20527056376a7176',
    messagingSenderId: '1053943487939',
    projectId: 'auklus-f9d97',
    authDomain: 'auklus-f9d97.firebaseapp.com',
    storageBucket: 'auklus-f9d97.firebasestorage.app',
  );
}
