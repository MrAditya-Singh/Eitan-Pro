import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cook_app/providers/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cook_app/ai_seeder.dart';
import 'package:cook_app/screens/home_screen.dart';
import 'package:cook_app/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  debugPrint("✔️ Firebase Initialized Successfully");
  await NotificationService().init();
  
  // Seed the new AI-Ready structure (Already seeded successfully)
  // await seedAiDatabase();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Eitan Pro',
          themeMode: themeProvider.themeMode,
          theme: ThemeProvider.lightTheme,
          darkTheme: ThemeProvider.darkTheme,
          home: const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // We'll keep it on Home for now but the App Drawer will update based on state
        return const HomeScreen();
      },
    );
  }
}
