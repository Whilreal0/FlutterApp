import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Tourism App\n\nDiscover beautiful spots in the Philippines.\n\nDeveloped with ❤️ using Flutter & Firebase.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
