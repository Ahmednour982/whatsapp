import 'package:flutter/material.dart';
import 'whatsApp_screen.dart';

void main() {
  runApp(const WhatsAppCloneApp());
}

class WhatsAppCloneApp extends StatelessWidget {
  const WhatsAppCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp Clone',
      theme: ThemeData(
        primaryColor: const Color(0xFF1B8C4B),
        scaffoldBackgroundColor: const Color(0xFF1B1B1B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B8C4B),
          brightness: Brightness.dark,
        ),
      ),
      home: const whatsAppScreen(),
    );
  }
}