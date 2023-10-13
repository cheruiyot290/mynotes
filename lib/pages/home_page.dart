import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/pages/login.dart';
import 'package:mynotes/pages/notes_view.dart';
import 'package:mynotes/pages/verify_email.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if(user != null){
              if(user.isEmailVerified){
                return const NotesView();
              }else{
                return const VerifyEmail();
              }
            }else{
              return const LoginPage();
            }
            return const Text('Done...');
        // TODO: Handle this case.
          default:
            return const CircularProgressIndicator(

            );
        }
      },
    );
  }
}
