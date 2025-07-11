import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseConfig {
  static Future<FirebaseApp> initialize() async {
    await dotenv.load(fileName: ".env");

    if (kIsWeb) {
      return Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: dotenv.env['WEB_API_KEY']!,
          authDomain: dotenv.env['AUTH_DOMAIN']!,
          projectId: dotenv.env['PROJECT_ID']!,
          storageBucket: dotenv.env['STORAGE_BUCKET']!,
          messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
          appId: dotenv.env['WEB_APP_ID']!,
          measurementId: dotenv.env['MEASUREMENT_ID'],
        ),
      );
    } else if (Platform.isAndroid) {
      return Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: dotenv.env['ANDROID_API_KEY']!,
          appId: dotenv.env['ANDROID_APP_ID']!,
          messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
          projectId: dotenv.env['PROJECT_ID']!,
          storageBucket: dotenv.env['STORAGE_BUCKET']!,
        ),
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      return Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: dotenv.env['IOS_API_KEY']!,
          appId: dotenv.env['IOS_APP_ID']!,
          messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
          projectId: dotenv.env['PROJECT_ID']!,
          storageBucket: dotenv.env['STORAGE_BUCKET']!,
          iosBundleId: dotenv.env['IOS_BUNDLE_ID'],
        ),
      );
    } else {
      throw UnsupportedError('Unsupported platform for Firebase initialization');
    }
  }
}
