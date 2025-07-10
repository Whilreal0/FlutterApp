import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'custom_firebase_options.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart'; // ✅ Import dotenv
import 'screens/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   // 👇 Load .env BEFORE using any dotenv.env
  await dotenv.load();
  await Firebase.initializeApp(options: CustomFirebaseOptions.currentPlatform);
  runApp(const TourismApp());
}

class TourismApp extends StatelessWidget {
  const TourismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourism App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        textTheme: GoogleFonts.poppinsTextTheme(),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          elevation: 3,
          clipBehavior: Clip.hardEdge,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
      ),
      home: const MainScaffold(),
    );
  }
}
