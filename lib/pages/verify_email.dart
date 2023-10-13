import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Text("We've sent an email verification, please open your email account to verify.\n"),
          const Text("If you haven't received a verification email yet, press the button below."),
          TextButton(onPressed: () async{
            await AuthService.firebase().sendEmailVerification();
          }, child: const Text('Send email verification')),
          TextButton(onPressed: () async{
            await AuthService.firebase().logOut();
            Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
          }, child: const Text('Restart')),
          TextButton(onPressed: () async{
            await AuthService.firebase().logOut();
            Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
          }, child: const Text('Login')),
        ],
      ),
    );
  }
}
