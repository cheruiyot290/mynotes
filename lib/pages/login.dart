import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/pages/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_options.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: FutureBuilder(
                future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                ),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _email,
                                  keyboardType: TextInputType.emailAddress,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Enter Email",
                                      labelText: "Email"),
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Please enter email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _password,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter Password",
                                  labelText: "Password",
                                ),
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 100,
                              height: 50,
                            ),
                            SizedBox(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      final email = _email.text;
                                      final password = _password.text;
                                      try{
                                        final userCredential = await FirebaseAuth
                                            .instance
                                            .signInWithEmailAndPassword(
                                            email: email, password: password);
                                        print(userCredential);
                                      }on FirebaseAuthException catch(e){
                                        if(e.code == "INVALID_LOGIN_CREDENTIALS")
                                        {
                                          print('INVALID LOGIN CREDENTIALS!');
                                        }
                                      }
                                    },
                                    child: const Text("Login"))),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const RegistrationPage()));
                                },
                                child: const Text(
                                    "Don't Have An Account? Click Here To Register"))
                          ],
                        ),
                      );
                    default:
                      return const Text("Loading...");
                  // TODO: Handle this case.
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
