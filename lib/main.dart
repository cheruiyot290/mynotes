import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/pages/home_page.dart';
import 'package:mynotes/pages/login.dart';
import 'package:mynotes/pages/notes_view.dart';
import 'package:mynotes/pages/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/pages/verify_email.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute : (context) => const LoginPage(),
        registerRoute : (context) => const RegistrationPage(),
        notesRoute : (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmail(),
      },
    );
  }
}
